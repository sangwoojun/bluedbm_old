#include "GeneratedTypes.h"
#ifndef _FLASHREQUEST_H_
#define _FLASHREQUEST_H_
#include "portal.h"
class FlashRequestProxyStatus;

class FlashRequestProxy : public Portal {
//proxyClass
public:
    FlashRequestProxy(int id, PortalPoller *poller = 0) : Portal(id, poller) {
        pint.parent = static_cast<void *>(this);
    };
    void startCopy ( const uint32_t wrPointer, const uint32_t rdPointer, const uint32_t numWords, const uint32_t burstLen, const uint32_t iterCnt ) { FlashRequestProxy_startCopy (&pint, wrPointer, rdPointer, numWords, burstLen, iterCnt); };
    void readPage ( const uint32_t channel, const uint32_t chip, const uint32_t block, const uint32_t page, const uint32_t tag ) { FlashRequestProxy_readPage (&pint, channel, chip, block, page, tag); };
    void writePage ( const uint32_t channel, const uint32_t chip, const uint32_t block, const uint32_t page, const uint32_t tag ) { FlashRequestProxy_writePage (&pint, channel, chip, block, page, tag); };
    void sendTest ( const uint32_t data ) { FlashRequestProxy_sendTest (&pint, data); };
    void addWriteHostBuffer ( const uint32_t pointer, const uint32_t idx ) { FlashRequestProxy_addWriteHostBuffer (&pint, pointer, idx); };
    void addReadHostBuffer ( const uint32_t pointer, const uint32_t idx ) { FlashRequestProxy_addReadHostBuffer (&pint, pointer, idx); };

};
#endif // _FLASHREQUEST_H_
