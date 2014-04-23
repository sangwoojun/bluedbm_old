#include "platform.hpp"

extern int readPage(unsigned long long pageIdx);
extern int writePage(unsigned long long pageIdx);
extern unsigned int *hostBuffer;
extern void waitTagFlush(int reqs, int resps);
extern int maxTagUsed;
extern unsigned int pageReadTotal;
extern unsigned int pageWriteTotal;

class PlatformIndication : public PlatformIndicationWrapper 
{
	public:
	PlatformIndication(unsigned int id) : PlatformIndicationWrapper(id){}

	virtual void rawWordTest(uint64_t d) {
	}
};

PlatformIndication *platformIndication;
void platformIndicationSetup() {
	platformIndication = 0;
	platformIndication = new PlatformIndication(IfcNames_PlatformIndication);
}


double timespec_diff_sec( timespec start, timespec end ) {
	double t = end.tv_sec - start.tv_sec;
	t += ((double)(end.tv_nsec - start.tv_nsec)/1000000000L);
	return t;
}

void platform() {
	for ( int i = 0; i < 1024*2*64; i++ ) {
		hostBuffer[i] = i;
	}
	int writeReqSent = 0;
	for ( int i = 0; i < 1024; i++ ) {
		fflush(stdout);
		int widx = writePage(i);
		//int widx = writePage(i);
		writeReqSent++;
	}
	waitTagFlush(writeReqSent, pageWriteTotal);
	printf( "\t\t**Write done\n" );
	fflush(stdout);
	
	timespec start, now;
	clock_gettime(CLOCK_REALTIME, & start);
	
	int readReqSent = 0;
	//for ( int i = 0; i < 1024; i++ ) {
	for ( int i = 0; i < 1024*256; i++ ) {
	  readPage(i);
	  readReqSent ++;
	  //if ( i % 1024 == 0) 
	  //printf( "--%d\n", i); 
	  //fflush(stdout);
	}
	waitTagFlush(readReqSent, pageReadTotal);
	clock_gettime(CLOCK_REALTIME, & now);
	printf( "Total pages read: %d (%d)\n", pageReadTotal, maxTagUsed );
	printf( "elapsed : %f\n", timespec_diff_sec(start,now) );
	
	/*
	printf( "---\n\n" );
	for ( int i = 0; i < 64; i++ ) {
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
	*/
}
