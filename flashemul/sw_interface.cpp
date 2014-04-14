/* Copyright (c) 2013 Quanta Research Cambridge, Inc
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
#include <stdio.h>
#include <sys/mman.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <monkit.h>
#include <semaphore.h>
#include "StdDmaIndication.h"

#include <time.h>
#include "DmaConfigProxy.h"
#include "GeneratedTypes.h"
#include "InterfaceIndicationWrapper.h"
#include "InterfaceRequestProxy.h"

#include "rawWordManager.h"

#define MAX_TAG_COUNT 64
#define TAG_COUNT 64
#define WRITE_TAG_COUNT 1
#define PAGE_SIZE 4096

pthread_mutex_t readTagMutex;
pthread_cond_t readTagCond;

int readTagStatus[TAG_COUNT];
InterfaceRequestProxy *device;

PortalAlloc *hostBufferAlloc;
unsigned int *hostBuffer;

int readTagCount[TAG_COUNT];

int writePage(unsigned long long pageIdx) {
	pthread_mutex_lock(&readTagMutex);
	while (true) {
		for ( int i = 0; i < WRITE_TAG_COUNT; i++ ) {
			if ( readTagStatus[i] == 0 ) {
				readTagStatus[i] = 1024*4;
				//printf( "sending read %llx %d\n", pageIdx, i );
				device->writePage(pageIdx,i);
				pthread_mutex_unlock(&readTagMutex);
				return i;
			}
		}
		pthread_cond_wait(&readTagCond, &readTagMutex);
	}
	pthread_mutex_unlock(&readTagMutex);
}

int readPage(unsigned long long pageIdx) {
	pthread_mutex_lock(&readTagMutex);
	while (true) {
		for ( int i = 0; i < TAG_COUNT; i++ ) {
			if ( readTagStatus[i] == 0 ) {
				readTagStatus[i] = 1024*4;
				//printf( "sending read %llx %d\n", pageIdx, i );
				device->readPage(pageIdx,i);
				pthread_mutex_unlock(&readTagMutex);
				return i;
			}
		}
		pthread_cond_wait(&readTagCond, &readTagMutex);
	}
	pthread_mutex_unlock(&readTagMutex);
}

RawWordManager* rawWordManager;

unsigned int pageReadTotal;
unsigned int pageWriteTotal;
int maxTagUsed;
class InterfaceIndication : public InterfaceIndicationWrapper
{
public:
  InterfaceIndication(unsigned int id) : InterfaceIndicationWrapper(id){}

	virtual void pageWriteDone(unsigned int tag) {
		pthread_mutex_lock(&readTagMutex);
		//fprintf(stderr, "Memread::writeDone(%ld, %d)\n", tag, pageWriteTotal);
		readTagStatus[tag] = 0;
		pageWriteTotal++;
		pthread_cond_broadcast(&readTagCond);
		pthread_mutex_unlock(&readTagMutex);
	}
	virtual void pageWriteFail(unsigned int tag) {
		pthread_mutex_lock(&readTagMutex);
		fprintf(stderr, "Memread::writeFailed(%ld, %d)\n", tag, pageWriteTotal);
		readTagStatus[tag] = 0;
		pthread_cond_broadcast(&readTagCond);
		pthread_mutex_unlock(&readTagMutex);
	}
	virtual void pageReadDone(unsigned int tag) {
		pthread_mutex_lock(&readTagMutex);
		//fprintf(stderr, "Memread::writeDone(%lx)\n", tag);
		if ( readTagStatus[tag] == 0 ) {
			printf( "!!!%d \n", tag );
		}
		readTagStatus[tag] = 0;
		pthread_mutex_unlock(&readTagMutex);
		pthread_cond_broadcast(&readTagCond);
		pageReadTotal ++;
		readTagCount[tag]++;
		if ( tag > maxTagUsed ) {
			maxTagUsed = tag;
			//printf( "max tag: %d\n", tag );
		}
	}
	virtual void hexdump(unsigned int a, unsigned int b) {
		printf( "%x %x\n", a, b );
	}
	virtual void writeRawWord(uint64_t data){
		//printf( "\t### %llx\n", (unsigned long long)data );
		rawWordManager->writeWord(data);
	}
};

void waitTagFlush(int reqs, int resps) {
	pthread_mutex_lock(&readTagMutex);
	while (true) {
		int i = 0;
		for ( i = 0; i < TAG_COUNT; i++ ) {
			if ( readTagStatus[i] != 0 ) {
				break;
			}
		}
		if ( i >= TAG_COUNT ) break;

/*
		for ( i = 0; i < TAG_COUNT; i++ ) {
			printf( "%d : %d\n", i, readTagStatus[i] );
		}

		printf( "%d/%d\n", resps, reqs );
		p
		*/
		pthread_cond_wait(&readTagCond, &readTagMutex);
	}
	pthread_mutex_unlock(&readTagMutex);
	printf( "wait done!\n" );
}

double timespec_diff_sec( timespec start, timespec end ) {
	double t = end.tv_sec - start.tv_sec;
	t += ((double)(end.tv_nsec - start.tv_nsec)/1000000000L);
	return t;
}


// we can use the data synchronization barrier instead of flushing the 
// cache only because the ps7 is configured to run in buffered-write mode
//
// an opc2 of '4' and CRm of 'c10' encodes "CP15DSB, Data Synchronization Barrier 
// operation". this is a legal instruction to execute in non-privileged mode (mdk)
//
// #define DATA_SYNC_BARRIER   __asm __volatile( "MCR p15, 0, %0, c7, c10, 4" ::  "r" (0) );

int main(int argc, const char **argv)
{
  device = 0;
  DmaConfigProxy *dma = 0;
  
  InterfaceIndication *deviceIndication = 0;
  DmaIndication *dmaIndication = 0;

  fprintf(stderr, "%s %s\n", __DATE__, __TIME__);

  device = new InterfaceRequestProxy(IfcNames_InterfaceRequest);
  dma = new DmaConfigProxy(IfcNames_DmaConfig);

  deviceIndication = new InterfaceIndication(IfcNames_InterfaceIndication);
  dmaIndication = new DmaIndication(dma, IfcNames_DmaIndication);

	fprintf(stderr, "Main::allocating memory...\n");

	dma->alloc(PAGE_SIZE*MAX_TAG_COUNT, &hostBufferAlloc);
	hostBuffer = (unsigned int *)mmap(0, PAGE_SIZE*MAX_TAG_COUNT, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED, hostBufferAlloc->header.fd, 0);

	pthread_t tid;
	fprintf(stderr, "creating exec thread\n");
	if(pthread_create(&tid, NULL,  portalExec, NULL)){
		fprintf(stderr, "error creating exec thread\n");
		exit(1);
	}

	dma->dCacheFlushInval(hostBufferAlloc, hostBuffer);
	fprintf(stderr, "Main::flush and invalidate complete\n");

	unsigned int ref_hostBufferAlloc = dma->reference(hostBufferAlloc);

	sleep(1);
	dma->addrRequest(ref_hostBufferAlloc, 1*sizeof(unsigned int));
	sleep(1);
	device->setDmaHandle(ref_hostBufferAlloc);

	pthread_mutex_init(&readTagMutex, NULL);
	pthread_cond_init(&readTagCond, NULL);
	rawWordManager = RawWordManager::getInstance();
	for ( int i = 0; i < TAG_COUNT; i++ ) readTagStatus[i] = 0;
	pageReadTotal = 0;
	pageWriteTotal = 0;
	maxTagUsed = 0;
	printf( "Main started server\n" );
	start_timer(0);

	for ( int i = 0; i < 1024*64; i++ ) {
		hostBuffer[i] = i;
	}
	//dma->dCacheFlushInval(hostBufferAlloc, hostBuffer);
	int writeReqSent = 0;
	portalTrace_start();

	for ( int i = 0; i < 16; i++ ) {
		int widx = writePage(i);
		//printf( "Write idx:%d %d\n", widx, i );
		writeReqSent++;
	}
	portalTrace_stop();
	waitTagFlush(writeReqSent, pageWriteTotal);

	printf( "\t\t**Write done\n" );
	//sleep(2);
	//dma->dCacheFlushInval(hostBufferAlloc, hostBuffer);
	
	for ( int i = 0; i < 64; i++ ) { 
		device->readRawWord(i*64);
		usleep(10000);
	//	device->rawWord(i*64+16);
	}
	for ( int i = 0; i < 63; i++ ) { 
		device->readRawWord(i*64+(64-24));
		usleep(10000);
	//	device->rawWord(i*64+16);
	}
	device->readRawWord(0);
	/*
	sleep(1);
	
	for ( int i = 0; i < 128; i++ ) { 
		usleep(10);
		device->rawWord(i*64);
	//	device->rawWord(i*64+16);
	}
	*/


	timespec start, now;

	clock_gettime(CLOCK_REALTIME, & start);

	int readReqSent = 0;
	for ( int i = 0; i < 1024*256; i++ ) {
	  readPage(i);
	  readReqSent ++;
	  //if ( i % 1024 == 0) 
	  //	printf( "--%d\n", i);
	}
	waitTagFlush(readReqSent, pageReadTotal);
	clock_gettime(CLOCK_REALTIME, & now);
	printf( "Total pages read: %d (%d)\n", pageReadTotal, maxTagUsed );
	printf( "elapsed : %f\n", timespec_diff_sec(start,now) );

	
	/*
	for ( int i = 0; i < TAG_COUNT; i++ ) {
		printf( "%2d - %8d - %8d: %x\n", i, readTagCount[i], readTagStatus[i], hostBuffer[i*1024] );
	}
	*/
	printf( "---\n\n" );
	for ( int i = 0; i < TAG_COUNT; i++ ) {
		int ival = hostBuffer[i*1024];
		for ( int j = 0; j < 1024; j++ ) {
			int idx = i*1024 + j;
			int rval = hostBuffer[idx];
			if ( ival != rval ) {
				printf( "!!! %d  != %d (%d)\n", ival, rval, idx );
			}
			ival++;
		}
	}
	/*
	for ( int i = 0; i < TAG_COUNT*1024; i++ ) {
		printf( "%2d - %8d: %x\n", i/1024, i, hostBuffer[i] );
	}
	*/
  
  //fprintf(stderr, "Main::starting mempcy numWords:%d\n", numWords);
  //device->startCopy(ref_dstAlloc, ref_srcAlloc, numWords, burstLen, iterCnt);
  
  
  
  
  uint64_t cycles = lap_timer(0);
  uint64_t read_beats = dma->show_mem_stats(ChannelType_Write);
  uint64_t write_beats = dma->show_mem_stats(ChannelType_Write);
  float read_util = (float)read_beats/(float)cycles;
  float write_util = (float)write_beats/(float)cycles;
  fprintf(stderr, "memory read utilization (beats/cycle): %f\n", read_util);
  fprintf(stderr, "memory write utilization (beats/cycle): %f\n", write_util);
  
  /*
  MonkitFile("perf.monkit")
    .setHwCycles(cycles)
    .setReadBwUtil(read_util)
    .setWriteBwUtil(write_util)
    .writeFile();

  sleep(2);
  */
  exit(0);
}
