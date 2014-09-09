#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#ifndef _DMACONFIG_H_
#define _DMACONFIG_H_
#include "PortalMemory.h"
class DmaConfigProxyStatus : public Portal {
//wrapperClass
public:
    DmaConfigProxyStatus(PortalInternal *p, PortalPoller *poller = 0);
    DmaConfigProxyStatus(int id, PortalPoller *poller = 0);
    virtual void putFailed ( const uint32_t v );

protected:
    virtual int handleMessage(unsigned int channel);
public:
    const static int putFailed_CHAN_NUM=0;

    const static int putFailed_FIFO_OFFSET= putFailed_CHAN_NUM * 256;

};

class DmaConfigProxy : public PortalMemory {
//proxyClass
    DmaConfigProxyStatus *proxyStatus;
public:
    DmaConfigProxy(int id, PortalPoller *poller = 0);
    void sglist ( const uint32_t pointer, const uint64_t addr, const uint32_t len );
    void region ( const uint32_t pointer, const uint64_t barr8, const uint32_t off8, const uint64_t barr4, const uint32_t off4, const uint64_t barr0, const uint32_t off0 );
    void addrRequest ( const uint32_t pointer, const uint32_t offset );
    void getStateDbg ( const ChannelType& rc );
    void getMemoryTraffic ( const ChannelType& rc );

    const static int sglist_CHAN_NUM=0;
    const static int region_CHAN_NUM=1;
    const static int addrRequest_CHAN_NUM=2;
    const static int getStateDbg_CHAN_NUM=3;
    const static int getMemoryTraffic_CHAN_NUM=4;

    const static int sglist_FIFO_OFFSET= sglist_CHAN_NUM * (256/4);
    const static int region_FIFO_OFFSET= region_CHAN_NUM * (256/4);
    const static int addrRequest_FIFO_OFFSET= addrRequest_CHAN_NUM * (256/4);
    const static int getStateDbg_FIFO_OFFSET= getStateDbg_CHAN_NUM * (256/4);
    const static int getMemoryTraffic_FIFO_OFFSET= getMemoryTraffic_CHAN_NUM * (256/4);

};
#endif // _DMACONFIG_H_
