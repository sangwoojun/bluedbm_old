#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#include "InterfaceRequestProxy.h"
InterfaceRequestProxyStatus::InterfaceRequestProxyStatus(PortalInternal *p, PortalPoller *poller)
 : Portal(p, poller)
{}
InterfaceRequestProxyStatus::InterfaceRequestProxyStatus(int id, PortalPoller *poller)
 : Portal(id, poller)
{}

class InterfaceRequestProxyStatusputFailedMSG : public PortalMessage
{
public:
    struct {
        uint32_t v:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.v;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.v = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((InterfaceRequestProxyStatus *)ind)->putFailed(payload.v);
 }
};

void InterfaceRequestProxyStatus::putFailed(uint32_t v){
    const char* methodNameStrings[] = {"setDmaHandle", "readPage", "writePage", "readRawWord"};
    fprintf(stderr, "putFailed: %s\n", methodNameStrings[v]);
    //exit(1);
  }

int InterfaceRequestProxyStatus::handleMessage(unsigned int channel)
{    
    unsigned int buf[1024];
    static int runaway = 0;
    
    switch (channel) {

    case putFailed_CHAN_NUM: 
    { 
        InterfaceRequestProxyStatusputFailedMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + putFailed_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    default:
        printf("InterfaceRequestProxyStatus::handleMessage: unknown channel 0x%x\n", channel);
        if (runaway++ > 10) {
            printf("InterfaceRequestProxyStatus::handleMessage: too many bogus indications, exiting\n");
            exit(-1);
        }
        return 0;
    }
    return 0;
}

InterfaceRequestProxy::InterfaceRequestProxy(int id, PortalPoller *poller)
 : PortalInternal(id)
{
    proxyStatus = new InterfaceRequestProxyStatus(this, poller);

}

class InterfaceRequestProxysetDmaHandleMSG : public PortalMessage
{
public:
    struct {
        uint32_t hostHandle:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.hostHandle;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.hostHandle = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void InterfaceRequestProxy::setDmaHandle ( const uint32_t hostHandle )
{
    InterfaceRequestProxysetDmaHandleMSG msg;
    msg.channel = setDmaHandle_CHAN_NUM;
    msg.fifo_offset = setDmaHandle_FIFO_OFFSET;
    msg.payload.hostHandle = hostHandle;

    sendMessage(&msg);
};

class InterfaceRequestProxyreadPageMSG : public PortalMessage
{
public:
    struct {
        uint64_t pageIdx:64;
        uint32_t tag:32;

    } payload;
    size_t size(){return 12;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.tag;
        buff[i++] = payload.pageIdx;
        buff[i++] = (payload.pageIdx>>32);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.tag = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.pageIdx = (uint64_t)(buff[i]&0xfffffffffffffffful);
        i++;
        payload.pageIdx |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<32);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void InterfaceRequestProxy::readPage ( const uint64_t pageIdx, const uint32_t tag )
{
    InterfaceRequestProxyreadPageMSG msg;
    msg.channel = readPage_CHAN_NUM;
    msg.fifo_offset = readPage_FIFO_OFFSET;
    msg.payload.pageIdx = pageIdx;
    msg.payload.tag = tag;

    sendMessage(&msg);
};

class InterfaceRequestProxywritePageMSG : public PortalMessage
{
public:
    struct {
        uint64_t pageIdx:64;
        uint32_t tag:32;

    } payload;
    size_t size(){return 12;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.tag;
        buff[i++] = payload.pageIdx;
        buff[i++] = (payload.pageIdx>>32);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.tag = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.pageIdx = (uint64_t)(buff[i]&0xfffffffffffffffful);
        i++;
        payload.pageIdx |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<32);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void InterfaceRequestProxy::writePage ( const uint64_t pageIdx, const uint32_t tag )
{
    InterfaceRequestProxywritePageMSG msg;
    msg.channel = writePage_CHAN_NUM;
    msg.fifo_offset = writePage_FIFO_OFFSET;
    msg.payload.pageIdx = pageIdx;
    msg.payload.tag = tag;

    sendMessage(&msg);
};

class InterfaceRequestProxyreadRawWordMSG : public PortalMessage
{
public:
    struct {
        uint64_t data:64;

    } payload;
    size_t size(){return 8;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.data;
        buff[i++] = (payload.data>>32);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.data = (uint64_t)(buff[i]&0xfffffffffffffffful);
        i++;
        payload.data |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<32);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void InterfaceRequestProxy::readRawWord ( const uint64_t data )
{
    InterfaceRequestProxyreadRawWordMSG msg;
    msg.channel = readRawWord_CHAN_NUM;
    msg.fifo_offset = readRawWord_FIFO_OFFSET;
    msg.payload.data = data;

    sendMessage(&msg);
};
