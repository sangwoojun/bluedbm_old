#include "GeneratedTypes.h"
#ifndef _FLASHINDICATION_H_
#define _FLASHINDICATION_H_

class FlashIndicationWrapper : public Portal {
//wrapperClass
public:
    FlashIndicationWrapper(int id, PortalPoller *poller = 0) : Portal(id, poller) {
        pint.handler = FlashIndicationWrapper_handleMessage;
        pint.parent = static_cast<void *>(this);
    };
    virtual void started (  ) = 0;
    virtual void readDone ( const uint32_t tag ) = 0;
    virtual void writeDone ( const uint32_t tag ) = 0;
    virtual void hexDump ( const uint32_t data ) = 0;

};
#endif // _FLASHINDICATION_H_
