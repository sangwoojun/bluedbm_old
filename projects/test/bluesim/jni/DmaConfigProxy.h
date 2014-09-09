#include "GeneratedTypes.h"
#ifndef _DMACONFIG_H_
#define _DMACONFIG_H_
#include "portal.h"
class DmaConfigProxyStatus;

class DmaConfigProxy : public Portal {
//proxyClass
public:
    DmaConfigProxy(int id, PortalPoller *poller = 0) : Portal(id, poller) {
        pint.parent = static_cast<void *>(this);
    };
    void sglist ( const uint32_t pointer, const uint32_t pointerIndex, const uint64_t addr, const uint32_t len ) { DmaConfigProxy_sglist (&pint, pointer, pointerIndex, addr, len); };
    void region ( const uint32_t pointer, const uint64_t barr8, const uint32_t index8, const uint64_t barr4, const uint32_t index4, const uint64_t barr0, const uint32_t index0 ) { DmaConfigProxy_region (&pint, pointer, barr8, index8, barr4, index4, barr0, index0); };
    void addrRequest ( const uint32_t pointer, const uint32_t offset ) { DmaConfigProxy_addrRequest (&pint, pointer, offset); };
    void getStateDbg ( const ChannelType rc ) { DmaConfigProxy_getStateDbg (&pint, rc); };
    void getMemoryTraffic ( const ChannelType rc ) { DmaConfigProxy_getMemoryTraffic (&pint, rc); };

};
#endif // _DMACONFIG_H_
