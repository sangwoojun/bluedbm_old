#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#include "PlatformRequestProxy.h"
PlatformRequestProxyStatus::PlatformRequestProxyStatus(PortalInternal *p, PortalPoller *poller)
 : Portal(p, poller)
{}
PlatformRequestProxyStatus::PlatformRequestProxyStatus(int id, PortalPoller *poller)
 : Portal(id, poller)
{}

class PlatformRequestProxyStatusputFailedMSG : public PortalMessage
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
    void indicate(void *ind){ ((PlatformRequestProxyStatus *)ind)->putFailed(payload.v);
 }
};

void PlatformRequestProxyStatus::putFailed(uint32_t v){
    const char* methodNameStrings[] = {"sendWord8", "sendWord4", "sendKey", "finalize", "start", "rawWordRequest"};
    fprintf(stderr, "putFailed: %s\n", methodNameStrings[v]);
    //exit(1);
  }

int PlatformRequestProxyStatus::handleMessage(unsigned int channel)
{    
    unsigned int buf[1024];
    static int runaway = 0;
    
    switch (channel) {

    case putFailed_CHAN_NUM: 
    { 
        PlatformRequestProxyStatusputFailedMSG msg;
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
        printf("PlatformRequestProxyStatus::handleMessage: unknown channel 0x%x\n", channel);
        if (runaway++ > 10) {
            printf("PlatformRequestProxyStatus::handleMessage: too many bogus indications, exiting\n");
            exit(-1);
        }
        return 0;
    }
    return 0;
}

PlatformRequestProxy::PlatformRequestProxy(int id, PortalPoller *poller)
 : PortalInternal(id)
{
    proxyStatus = new PlatformRequestProxyStatus(this, poller);

}

class PlatformRequestProxysendWord8MSG : public PortalMessage
{
public:
    struct {
        uint64_t word:64;

    } payload;
    size_t size(){return 8;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.word;
        buff[i++] = (payload.word>>32);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.word = (uint64_t)(buff[i]&0xfffffffffffffffful);
        i++;
        payload.word |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<32);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void PlatformRequestProxy::sendWord8 ( const uint64_t word )
{
    PlatformRequestProxysendWord8MSG msg;
    msg.channel = sendWord8_CHAN_NUM;
    msg.fifo_offset = sendWord8_FIFO_OFFSET;
    msg.payload.word = word;

    sendMessage(&msg);
};

class PlatformRequestProxysendWord4MSG : public PortalMessage
{
public:
    struct {
        uint32_t word:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.word;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.word = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void PlatformRequestProxy::sendWord4 ( const uint32_t word )
{
    PlatformRequestProxysendWord4MSG msg;
    msg.channel = sendWord4_CHAN_NUM;
    msg.fifo_offset = sendWord4_FIFO_OFFSET;
    msg.payload.word = word;

    sendMessage(&msg);
};

class PlatformRequestProxysendKeyMSG : public PortalMessage
{
public:
    struct {
        uint64_t key:64;

    } payload;
    size_t size(){return 8;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.key;
        buff[i++] = (payload.key>>32);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.key = (uint64_t)(buff[i]&0xfffffffffffffffful);
        i++;
        payload.key |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<32);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void PlatformRequestProxy::sendKey ( const uint64_t key )
{
    PlatformRequestProxysendKeyMSG msg;
    msg.channel = sendKey_CHAN_NUM;
    msg.fifo_offset = sendKey_FIFO_OFFSET;
    msg.payload.key = key;

    sendMessage(&msg);
};

class PlatformRequestProxyfinalizeMSG : public PortalMessage
{
public:
    struct {
        uint32_t dummy:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.dummy;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.dummy = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void PlatformRequestProxy::finalize ( const uint32_t dummy )
{
    PlatformRequestProxyfinalizeMSG msg;
    msg.channel = finalize_CHAN_NUM;
    msg.fifo_offset = finalize_FIFO_OFFSET;
    msg.payload.dummy = dummy;

    sendMessage(&msg);
};

class PlatformRequestProxystartMSG : public PortalMessage
{
public:
    struct {
        uint32_t dummy:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.dummy;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.dummy = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ assert(false); }
};

void PlatformRequestProxy::start ( const uint32_t dummy )
{
    PlatformRequestProxystartMSG msg;
    msg.channel = start_CHAN_NUM;
    msg.fifo_offset = start_FIFO_OFFSET;
    msg.payload.dummy = dummy;

    sendMessage(&msg);
};

class PlatformRequestProxyrawWordRequestMSG : public PortalMessage
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

void PlatformRequestProxy::rawWordRequest ( const uint64_t data )
{
    PlatformRequestProxyrawWordRequestMSG msg;
    msg.channel = rawWordRequest_CHAN_NUM;
    msg.fifo_offset = rawWordRequest_FIFO_OFFSET;
    msg.payload.data = data;

    sendMessage(&msg);
};
