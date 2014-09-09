#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#ifndef _PLATFORMREQUEST_H_
#define _PLATFORMREQUEST_H_
#include "portal.h"
class PlatformRequestProxyStatus : public Portal {
//wrapperClass
public:
    PlatformRequestProxyStatus(PortalInternal *p, PortalPoller *poller = 0);
    PlatformRequestProxyStatus(int id, PortalPoller *poller = 0);
    virtual void putFailed ( const uint32_t v );

protected:
    virtual int handleMessage(unsigned int channel);
public:
    const static int putFailed_CHAN_NUM=0;

    const static int putFailed_FIFO_OFFSET= putFailed_CHAN_NUM * 256;

};

class PlatformRequestProxy : public PortalInternal {
//proxyClass
    PlatformRequestProxyStatus *proxyStatus;
public:
    PlatformRequestProxy(int id, PortalPoller *poller = 0);
    void sendWord8 ( const uint64_t word );
    void sendWord4 ( const uint32_t word );
    void sendKey ( const uint64_t key );
    void finalize ( const uint32_t dummy );
    void start ( const uint32_t dummy );
    void rawWordRequest ( const uint64_t data );

    const static int sendWord8_CHAN_NUM=0;
    const static int sendWord4_CHAN_NUM=1;
    const static int sendKey_CHAN_NUM=2;
    const static int finalize_CHAN_NUM=3;
    const static int start_CHAN_NUM=4;
    const static int rawWordRequest_CHAN_NUM=5;

    const static int sendWord8_FIFO_OFFSET= sendWord8_CHAN_NUM * (256/4);
    const static int sendWord4_FIFO_OFFSET= sendWord4_CHAN_NUM * (256/4);
    const static int sendKey_FIFO_OFFSET= sendKey_CHAN_NUM * (256/4);
    const static int finalize_FIFO_OFFSET= finalize_CHAN_NUM * (256/4);
    const static int start_FIFO_OFFSET= start_CHAN_NUM * (256/4);
    const static int rawWordRequest_FIFO_OFFSET= rawWordRequest_CHAN_NUM * (256/4);

};
#endif // _PLATFORMREQUEST_H_
