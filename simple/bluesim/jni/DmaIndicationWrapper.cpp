#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#include "DmaIndicationWrapper.h"
DmaIndicationWrapperStatus::DmaIndicationWrapperStatus(int id, PortalPoller *poller)
 : PortalInternal(id)
{
    
}

class DmaIndicationWrapperStatusputFailedMSG : public PortalMessage
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

void DmaIndicationWrapperStatus::putFailed ( const uint32_t v )
{
    DmaIndicationWrapperStatusputFailedMSG msg;
    msg.channel = putFailed_CHAN_NUM;
    msg.fifo_offset = putFailed_FIFO_OFFSET;
    msg.payload.v = v;

    sendMessage(&msg);
};

DmaIndicationWrapper::DmaIndicationWrapper(PortalInternal *p, PortalPoller *poller)
 : Portal(p, poller)
{}
DmaIndicationWrapper::DmaIndicationWrapper(int id, PortalPoller *poller)
 : Portal(id, poller)
{}

class DmaIndicationWrapperconfigRespMSG : public PortalMessage
{
public:
    struct {
        uint32_t pointer:32;
        uint64_t msg:40;

    } payload;
    size_t size(){return 12;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.msg;
        buff[i++] = (payload.msg>>32)|(payload.pointer<<8);
        buff[i++] = (payload.pointer>>24);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.msg = (uint64_t)(buff[i]&0xfffffffffful);
        i++;
        payload.msg |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffful)<<32);
        payload.pointer = (uint32_t)((buff[i]>>8)&0xfffffffful);
        i++;
        payload.pointer |= (uint32_t)((uint32_t)(buff[i]&0xfffffffful)<<24);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->configResp(payload.pointer, payload.msg);
 }
};

class DmaIndicationWrapperaddrResponseMSG : public PortalMessage
{
public:
    struct {
        uint64_t physAddr:64;

    } payload;
    size_t size(){return 8;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.physAddr;
        buff[i++] = (payload.physAddr>>32);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.physAddr = (uint64_t)(buff[i]&0xfffffffffffffffful);
        i++;
        payload.physAddr |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<32);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->addrResponse(payload.physAddr);
 }
};

class DmaIndicationWrapperbadPointerMSG : public PortalMessage
{
public:
    struct {
        uint32_t pointer:32;

    } payload;
    size_t size(){return 4;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.pointer;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.pointer = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->badPointer(payload.pointer);
 }
};

class DmaIndicationWrapperbadAddrTransMSG : public PortalMessage
{
public:
    struct {
        uint32_t pointer:32;
        uint64_t offset:64;
        uint64_t barrier:40;

    } payload;
    size_t size(){return 20;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.barrier;
        buff[i++] = (payload.barrier>>32)|(payload.offset<<8);
        buff[i++] = (payload.offset>>24);
        buff[i++] = (payload.offset>>56)|(payload.pointer<<8);
        buff[i++] = (payload.pointer>>24);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.barrier = (uint64_t)(buff[i]&0xfffffffffful);
        i++;
        payload.barrier |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffful)<<32);
        payload.offset = (uint64_t)((buff[i]>>8)&0xfffffffffffffffful);
        i++;
        payload.offset |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<24);
        i++;
        payload.offset |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<56);
        payload.pointer = (uint32_t)((buff[i]>>8)&0xfffffffful);
        i++;
        payload.pointer |= (uint32_t)((uint32_t)(buff[i]&0xfffffffful)<<24);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->badAddrTrans(payload.pointer, payload.offset, payload.barrier);
 }
};

class DmaIndicationWrapperbadPageSizeMSG : public PortalMessage
{
public:
    struct {
        uint32_t pointer:32;
        uint32_t sz:32;

    } payload;
    size_t size(){return 8;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.sz;
        buff[i++] = payload.pointer;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.sz = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.pointer = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->badPageSize(payload.pointer, payload.sz);
 }
};

class DmaIndicationWrapperbadNumberEntriesMSG : public PortalMessage
{
public:
    struct {
        uint32_t pointer:32;
        uint32_t sz:32;

    } payload;
    size_t size(){return 8;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.sz;
        buff[i++] = payload.pointer;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.sz = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.pointer = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->badNumberEntries(payload.pointer, payload.sz);
 }
};

class DmaIndicationWrapperbadAddrMSG : public PortalMessage
{
public:
    struct {
        uint32_t pointer:32;
        uint64_t offset:40;
        uint64_t physAddr:64;

    } payload;
    size_t size(){return 20;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.physAddr;
        buff[i++] = (payload.physAddr>>32);
        buff[i++] = payload.offset;
        buff[i++] = (payload.offset>>32)|(payload.pointer<<8);
        buff[i++] = (payload.pointer>>24);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.physAddr = (uint64_t)(buff[i]&0xfffffffffffffffful);
        i++;
        payload.physAddr |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<32);
        i++;
        payload.offset = (uint64_t)(buff[i]&0xfffffffffful);
        i++;
        payload.offset |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffful)<<32);
        payload.pointer = (uint32_t)((buff[i]>>8)&0xfffffffful);
        i++;
        payload.pointer |= (uint32_t)((uint32_t)(buff[i]&0xfffffffful)<<24);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->badAddr(payload.pointer, payload.offset, payload.physAddr);
 }
};

class DmaIndicationWrapperreportStateDbgMSG : public PortalMessage
{
public:
    struct {
        DmaDbgRec rec;

    } payload;
    size_t size(){return 16;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.rec.w;
        buff[i++] = payload.rec.z;
        buff[i++] = payload.rec.y;
        buff[i++] = payload.rec.x;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.rec.w = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.rec.z = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.rec.y = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.rec.x = (uint32_t)(buff[i]&0xfffffffful);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->reportStateDbg(payload.rec);
 }
};

class DmaIndicationWrapperreportMemoryTrafficMSG : public PortalMessage
{
public:
    struct {
        uint64_t words:64;

    } payload;
    size_t size(){return 8;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.words;
        buff[i++] = (payload.words>>32);

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.words = (uint64_t)(buff[i]&0xfffffffffffffffful);
        i++;
        payload.words |= (uint64_t)((uint64_t)(buff[i]&0xfffffffffffffffful)<<32);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->reportMemoryTraffic(payload.words);
 }
};

class DmaIndicationWrappertagMismatchMSG : public PortalMessage
{
public:
    struct {
        ChannelType x;
        uint32_t a:32;
        uint32_t b:32;

    } payload;
    size_t size(){return 12;}
    void marshall(unsigned int *buff) {
        int i = 0;
        buff[i++] = payload.b;
        buff[i++] = payload.a;
        buff[i++] = payload.x;

    }
    void demarshall(unsigned int *buff){
        int i = 0;
        payload.b = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.a = (uint32_t)(buff[i]&0xfffffffful);
        i++;
        payload.x = (ChannelType)(buff[i]&0x1ul);
        i++;

    }
    void indicate(void *ind){ ((DmaIndicationWrapper *)ind)->tagMismatch(payload.x, payload.a, payload.b);
 }
};

int DmaIndicationWrapper::handleMessage(unsigned int channel)
{    
    unsigned int buf[1024];
    static int runaway = 0;
    
    switch (channel) {

    case configResp_CHAN_NUM: 
    { 
        DmaIndicationWrapperconfigRespMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + configResp_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case addrResponse_CHAN_NUM: 
    { 
        DmaIndicationWrapperaddrResponseMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + addrResponse_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case badPointer_CHAN_NUM: 
    { 
        DmaIndicationWrapperbadPointerMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + badPointer_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case badAddrTrans_CHAN_NUM: 
    { 
        DmaIndicationWrapperbadAddrTransMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + badAddrTrans_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case badPageSize_CHAN_NUM: 
    { 
        DmaIndicationWrapperbadPageSizeMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + badPageSize_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case badNumberEntries_CHAN_NUM: 
    { 
        DmaIndicationWrapperbadNumberEntriesMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + badNumberEntries_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case badAddr_CHAN_NUM: 
    { 
        DmaIndicationWrapperbadAddrMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + badAddr_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case reportStateDbg_CHAN_NUM: 
    { 
        DmaIndicationWrapperreportStateDbgMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + reportStateDbg_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case reportMemoryTraffic_CHAN_NUM: 
    { 
        DmaIndicationWrapperreportMemoryTrafficMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + reportMemoryTraffic_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    case tagMismatch_CHAN_NUM: 
    { 
        DmaIndicationWrappertagMismatchMSG msg;
        for (int i = (msg.size()/4)-1; i >= 0; i--) {
            volatile unsigned int *ptr = (volatile unsigned int*)(((long)ind_fifo_base) + tagMismatch_FIFO_OFFSET);
            unsigned int val = READL(this, ptr);
            buf[i] = val;
        }
        msg.demarshall(buf);
        msg.indicate(this);
        break;
    }

    default:
        printf("DmaIndicationWrapper::handleMessage: unknown channel 0x%x\n", channel);
        if (runaway++ > 10) {
            printf("DmaIndicationWrapper::handleMessage: too many bogus indications, exiting\n");
            exit(-1);
        }
        return 0;
    }
    return 0;
}
