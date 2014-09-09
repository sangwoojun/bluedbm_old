#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#include "DmaConfigProxy.h"
DmaConfigProxyStatus::DmaConfigProxyStatus(PortalInternal *p, PortalPoller *poller)
 : Portal(p, poller)
{}
DmaConfigProxyStatus::DmaConfigProxyStatus(int id, PortalPoller *poller)
 : Portal(id, poller)
{}

class DmaConfigProxyStatusputFailedMSG : public PortalMessage
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
    void indicate(void *ind){ ((DmaConfigProxyStatus *)ind)->putFailed(payload.v);
 }
};

void DmaConfigProxyStatus::putFailed(uint32_t v){
    const char* methodNameStrings[] = {"sglist", "region", "addrRequest", "getStateDbg", "getMemoryTraffic"};
    fprintf(stderr, "putFailed: %s\n", methodNameStrings[v]);
    //exit(1);
  }

int DmaConfigProxyStatus::handleMessage(unsigned int channel)
{    
    unsigned int buf[1024];
    static int runaway = 0;
    
    switch (channel) {

    case putFailed_CHAN_NUM: 
    { 
        DmaConfigProxyStatusputFailedMSG msg;
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
        printf("DmaConfigProxyStatus::handleMessage: unknown channel 0x%x\n", channel);
        if (runaway++ > 10) {
            printf("DmaConfigProxyStatus::handleMessage: too many bogus indications, exiting\n");
            exit(-1);
        }
        return 0;
    }
    return 0;
}

DmaConfigProxy::DmaConfigProxy(int id, PortalPoller *poller)
 : PortalMemory(id)
{
    proxyStatus = new DmaConfigProxyStatus(this, poller);

}

class DmaConfigProxysglistMSG : public PortalMessage
{
public:
    struct {
        uint32_t pointer:32;
        uint64_t addr:40;
        uint32_t len:32;

    } payload;
    size_t size(){return 16;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.len;
        buff[i++] = payload.addr;
        buff[i++] = (payload.addr>>32)|(payload.pointer<<8);
        buff[i++] = (payload.pointer>>24);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.len = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.addr = (uint64_t)(buff[i]&0xfffffffffful);
        i++;
        payload.addr |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffful)<<32);
        payload.pointer = (uint32_t)((buff[i]>>8)&0xfffffffful);
        i++;
        payload.pointer |= (uint32_t)((uint32_t)(buff[i]&0xfffffffful)<<24);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void DmaConfigProxy::sglist ( const uint32_t pointer, const uint64_t addr, const uint32_t len )
{
    DmaConfigProxysglistMSG msg;
    msg.channel = sglist_CHAN_NUM;
    msg.fifo_offset = sglist_FIFO_OFFSET;
    msg.payload.pointer = pointer;
    msg.payload.addr = addr;
    msg.payload.len = len;

    sendMessage(&msg);
};

class DmaConfigProxyregionMSG : public PortalMessage
{
public:
    struct {
        uint32_t pointer:32;
        uint64_t barr8:40;
        uint32_t off8:8;
        uint64_t barr4:40;
        uint32_t off4:8;
        uint64_t barr0:40;
        uint32_t off0:8;

    } payload;
    size_t size(){return 24;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.off0|(payload.barr0<<8);
        buff[i++] = (payload.barr0>>24)|(payload.off4<<16)|(payload.barr4<<24);
        buff[i++] = (payload.barr4>>8);
        buff[i++] = payload.off8|(payload.barr8<<8);
        buff[i++] = (payload.barr8>>24)|(payload.pointer<<16);
        buff[i++] = (payload.pointer>>16);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.off0 = (uint32_t)(buff[i]&0xfful);
        payload.barr0 = (uint64_t)((buff[i]>>8)&0xfffffffffful);
        i++;
        payload.barr0 |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffful)<<24);
        payload.off4 = (uint32_t)((buff[i]>>16)&0xfful);
        payload.barr4 = (uint64_t)((buff[i]>>24)&0xfffffffffful);
        i++;
        payload.barr4 |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffful)<<8);
        i++;
        payload.off8 = (uint32_t)(buff[i]&0xfful);
        payload.barr8 = (uint64_t)((buff[i]>>8)&0xfffffffffful);
        i++;
        payload.barr8 |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffful)<<24);
        payload.pointer = (uint32_t)((buff[i]>>16)&0xfffffffful);
        i++;
        payload.pointer |= (uint32_t)((uint32_t)(buff[i]&0xfffffffful)<<16);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void DmaConfigProxy::region ( const uint32_t pointer, const uint64_t barr8, const uint32_t off8, const uint64_t barr4, const uint32_t off4, const uint64_t barr0, const uint32_t off0 )
{
    DmaConfigProxyregionMSG msg;
    msg.channel = region_CHAN_NUM;
    msg.fifo_offset = region_FIFO_OFFSET;
    msg.payload.pointer = pointer;
    msg.payload.barr8 = barr8;
    msg.payload.off8 = off8;
    msg.payload.barr4 = barr4;
    msg.payload.off4 = off4;
    msg.payload.barr0 = barr0;
    msg.payload.off0 = off0;

    sendMessage(&msg);
};

class DmaConfigProxyaddrRequestMSG : public PortalMessage
{
public:
    struct {
        uint32_t pointer:32;
        uint32_t offset:32;

    } payload;
    size_t size(){return 8;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.offset;
        buff[i++] = payload.pointer;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.offset = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.pointer = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void DmaConfigProxy::addrRequest ( const uint32_t pointer, const uint32_t offset )
{
    DmaConfigProxyaddrRequestMSG msg;
    msg.channel = addrRequest_CHAN_NUM;
    msg.fifo_offset = addrRequest_FIFO_OFFSET;
    msg.payload.pointer = pointer;
    msg.payload.offset = offset;

    sendMessage(&msg);
};

class DmaConfigProxygetStateDbgMSG : public PortalMessage
{
public:
    struct {
        ChannelType rc;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.rc;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.rc = (ChannelType)(buff[i]&0x1ul);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void DmaConfigProxy::getStateDbg ( const ChannelType& rc )
{
    DmaConfigProxygetStateDbgMSG msg;
    msg.channel = getStateDbg_CHAN_NUM;
    msg.fifo_offset = getStateDbg_FIFO_OFFSET;
    msg.payload.rc = rc;

    sendMessage(&msg);
};

class DmaConfigProxygetMemoryTrafficMSG : public PortalMessage
{
public:
    struct {
        ChannelType rc;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.rc;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.rc = (ChannelType)(buff[i]&0x1ul);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void DmaConfigProxy::getMemoryTraffic ( const ChannelType& rc )
{
    DmaConfigProxygetMemoryTrafficMSG msg;
    msg.channel = getMemoryTraffic_CHAN_NUM;
    msg.fifo_offset = getMemoryTraffic_FIFO_OFFSET;
    msg.payload.rc = rc;

    sendMessage(&msg);
};
