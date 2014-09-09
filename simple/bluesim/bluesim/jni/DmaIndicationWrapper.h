#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#ifndef _DMAINDICATION_H_
#define _DMAINDICATION_H_

class DmaIndicationWrapperStatus : public PortalInternal {
//proxyClass
    
public:
    DmaIndicationWrapperStatus(int id, PortalPoller *poller = 0);
    void putFailed ( const uint32_t v );

    const static int putFailed_CHAN_NUM=0;

    const static int putFailed_FIFO_OFFSET= putFailed_CHAN_NUM * (256/4);

};

class DmaIndicationWrapper : public Portal {
//wrapperClass
public:
    DmaIndicationWrapper(PortalInternal *p, PortalPoller *poller = 0);
    DmaIndicationWrapper(int id, PortalPoller *poller = 0);
    virtual void configResp ( const uint32_t pointer, const uint64_t msg )= 0;
    virtual void addrResponse ( const uint64_t physAddr )= 0;
    virtual void badPointer ( const uint32_t pointer )= 0;
    virtual void badAddrTrans ( const uint32_t pointer, const uint64_t offset, const uint64_t barrier )= 0;
    virtual void badPageSize ( const uint32_t pointer, const uint32_t sz )= 0;
    virtual void badNumberEntries ( const uint32_t pointer, const uint32_t sz )= 0;
    virtual void badAddr ( const uint32_t pointer, const uint64_t offset, const uint64_t physAddr )= 0;
    virtual void reportStateDbg ( const DmaDbgRec& rec )= 0;
    virtual void reportMemoryTraffic ( const uint64_t words )= 0;
    virtual void tagMismatch ( const ChannelType& x, const uint32_t a, const uint32_t b )= 0;

protected:
    virtual int handleMessage(unsigned int channel);
public:
    const static int configResp_CHAN_NUM=0;
    const static int addrResponse_CHAN_NUM=1;
    const static int badPointer_CHAN_NUM=2;
    const static int badAddrTrans_CHAN_NUM=3;
    const static int badPageSize_CHAN_NUM=4;
    const static int badNumberEntries_CHAN_NUM=5;
    const static int badAddr_CHAN_NUM=6;
    const static int reportStateDbg_CHAN_NUM=7;
    const static int reportMemoryTraffic_CHAN_NUM=8;
    const static int tagMismatch_CHAN_NUM=9;

    const static int configResp_FIFO_OFFSET= configResp_CHAN_NUM * 256;
    const static int addrResponse_FIFO_OFFSET= addrResponse_CHAN_NUM * 256;
    const static int badPointer_FIFO_OFFSET= badPointer_CHAN_NUM * 256;
    const static int badAddrTrans_FIFO_OFFSET= badAddrTrans_CHAN_NUM * 256;
    const static int badPageSize_FIFO_OFFSET= badPageSize_CHAN_NUM * 256;
    const static int badNumberEntries_FIFO_OFFSET= badNumberEntries_CHAN_NUM * 256;
    const static int badAddr_FIFO_OFFSET= badAddr_CHAN_NUM * 256;
    const static int reportStateDbg_FIFO_OFFSET= reportStateDbg_CHAN_NUM * 256;
    const static int reportMemoryTraffic_FIFO_OFFSET= reportMemoryTraffic_CHAN_NUM * 256;
    const static int tagMismatch_FIFO_OFFSET= tagMismatch_CHAN_NUM * 256;

};
#endif // _DMAINDICATION_H_
