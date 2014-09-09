#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#include "InterfaceIndicationWrapper.h"
InterfaceIndicationWrapperStatus::InterfaceIndicationWrapperStatus(int id, PortalPoller *poller)
 : PortalInternal(id)
{
    
}

class InterfaceIndicationWrapperStatusputFailedMSG : public PortalMessage
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

void InterfaceIndicationWrapperStatus::putFailed ( const uint32_t v )
{
    InterfaceIndicationWrapperStatusputFailedMSG msg;
    msg.channel = putFailed_CHAN_NUM;
    msg.fifo_offset = putFailed_FIFO_OFFSET;
    msg.payload.v = v;

    sendMessage(&msg);
};

InterfaceIndicationWrapper::InterfaceIndicationWrapper(PortalInternal *p, PortalPoller *poller)
 : Portal(p, poller)
{}
InterfaceIndicationWrapper::InterfaceIndicationWrapper(int id, PortalPoller *poller)
 : Portal(id, poller)
{}

class InterfaceIndicationWrapperpageReadDoneMSG : public PortalMessage
{
public:
    struct {
        uint32_t tag:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.tag;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.tag = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((InterfaceIndicationWrapper *)ind)->pageReadDone(payload.tag);
 }
};

class InterfaceIndicationWrapperpageWriteDoneMSG : public PortalMessage
{
public:
    struct {
        uint32_t tag:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.tag;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.tag = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((InterfaceIndicationWrapper *)ind)->pageWriteDone(payload.tag);
 }
};

class InterfaceIndicationWrapperpageWriteFailMSG : public PortalMessage
{
public:
    struct {
        uint32_t tag:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.tag;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.tag = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((InterfaceIndicationWrapper *)ind)->pageWriteFail(payload.tag);
 }
};

class InterfaceIndicationWrapperhexdumpMSG : public PortalMessage
{
public:
    struct {
        uint32_t a:32;
        uint32_t b:32;

    } payload;
    size_t size(){return 8;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.b;
        buff[i++] = payload.a;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.b = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.a = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((InterfaceIndicationWrapper *)ind)->hexdump(payload.a, payload.b);
 }
};

class InterfaceIndicationWrapperwriteRawWordMSG : public PortalMessage
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
    void indicate(void *ind){ ((InterfaceIndicationWrapper *)ind)->writeRawWord(payload.data);
 }
};

int InterfaceIndicationWrapper::handleMessage(unsigned int channel)
{    
    unsigned int buf[1024];
    static int runaway = 0;
    
    switch (channel) {

    case pageReadDone_CHAN_NUM: 
    { 
        InterfaceIndicationWrapperpageReadDoneMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + pageReadDone_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case pageWriteDone_CHAN_NUM: 
    { 
        InterfaceIndicationWrapperpageWriteDoneMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + pageWriteDone_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case pageWriteFail_CHAN_NUM: 
    { 
        InterfaceIndicationWrapperpageWriteFailMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + pageWriteFail_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case hexdump_CHAN_NUM: 
    { 
        InterfaceIndicationWrapperhexdumpMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + hexdump_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case writeRawWord_CHAN_NUM: 
    { 
        InterfaceIndicationWrapperwriteRawWordMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + writeRawWord_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    default:
        printf("InterfaceIndicationWrapper::handleMessage: unknown channel 0x%x\n", channel);
        if (runaway++ > 10) {
            printf("InterfaceIndicationWrapper::handleMessage: too many bogus indications, exiting\n");
            exit(-1);
        }
        return 0;
    }
    return 0;
}
