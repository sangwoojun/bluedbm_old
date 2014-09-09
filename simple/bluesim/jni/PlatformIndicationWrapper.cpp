#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#include "PlatformIndicationWrapper.h"
PlatformIndicationWrapperStatus::PlatformIndicationWrapperStatus(int id, PortalPoller *poller)
 : PortalInternal(id)
{
    
}

class PlatformIndicationWrapperStatusputFailedMSG : public PortalMessage
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
    void indicate(void *ind){ assert(false); }
};

void PlatformIndicationWrapperStatus::putFailed ( const uint32_t v )
{
    PlatformIndicationWrapperStatusputFailedMSG msg;
    msg.channel = putFailed_CHAN_NUM;
    msg.fifo_offset = putFailed_FIFO_OFFSET;
    msg.payload.v = v;

    sendMessage(&msg);
};

PlatformIndicationWrapper::PlatformIndicationWrapper(PortalInternal *p, PortalPoller *poller)
 : Portal(p, poller)
{}
PlatformIndicationWrapper::PlatformIndicationWrapper(int id, PortalPoller *poller)
 : Portal(id, poller)
{}

class PlatformIndicationWrappersendWord8MSG : public PortalMessage
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
    void indicate(void *ind){ ((PlatformIndicationWrapper *)ind)->sendWord8(payload.word);
 }
};

class PlatformIndicationWrappersendWord4MSG : public PortalMessage
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
    void indicate(void *ind){ ((PlatformIndicationWrapper *)ind)->sendWord4(payload.word);
 }
};

class PlatformIndicationWrappersendKeyMSG : public PortalMessage
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
    void indicate(void *ind){ ((PlatformIndicationWrapper *)ind)->sendKey(payload.key);
 }
};

class PlatformIndicationWrapperrawWordTestMSG : public PortalMessage
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
    void indicate(void *ind){ ((PlatformIndicationWrapper *)ind)->rawWordTest(payload.data);
 }
};

class PlatformIndicationWrapperrequestWordsMSG : public PortalMessage
{
public:
    struct {
        uint32_t words:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.words;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.words = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((PlatformIndicationWrapper *)ind)->requestWords(payload.words);
 }
};

int PlatformIndicationWrapper::handleMessage(unsigned int channel)
{    
    unsigned int buf[1024];
    static int runaway = 0;
    
    switch (channel) {

    case sendWord8_CHAN_NUM: 
    { 
        PlatformIndicationWrappersendWord8MSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + sendWord8_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case sendWord4_CHAN_NUM: 
    { 
        PlatformIndicationWrappersendWord4MSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + sendWord4_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case sendKey_CHAN_NUM: 
    { 
        PlatformIndicationWrappersendKeyMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + sendKey_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case rawWordTest_CHAN_NUM: 
    { 
        PlatformIndicationWrapperrawWordTestMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + rawWordTest_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case requestWords_CHAN_NUM: 
    { 
        PlatformIndicationWrapperrequestWordsMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + requestWords_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    default:
        printf("PlatformIndicationWrapper::handleMessage: unknown channel 0x%x\n", channel);
        if (runaway++ > 10) {
            printf("PlatformIndicationWrapper::handleMessage: too many bogus indications, exiting\n");
            exit(-1);
        }
        return 0;
    }
    return 0;
}
