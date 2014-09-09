#include "GeneratedTypes.h"
#ifndef _DMAINDICATION_H_
#define _DMAINDICATION_H_

class DmaIndicationWrapper : public Portal {
//wrapperClass
public:
    DmaIndicationWrapper(int id, PortalPoller *poller = 0) : Portal(id, poller) {
        pint.handler = DmaIndicationWrapper_handleMessage;
        pint.parent = static_cast<void *>(this);
    };
    virtual void configResp ( const uint32_t pointer ) = 0;
    virtual void addrResponse ( const uint64_t physAddr ) = 0;
    virtual void reportStateDbg ( const DmaDbgRec rec ) = 0;
    virtual void reportMemoryTraffic ( const uint64_t words ) = 0;
    virtual void dmaError ( const uint32_t code, const uint32_t pointer, const uint64_t offset, const uint64_t extra ) = 0;

};
#endif // _DMAINDICATION_H_
