#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#ifndef _PLATFORMINDICATION_H_
#define _PLATFORMINDICATION_H_

class PlatformIndicationWrapperStatus : public PortalInternal {
//proxyClass
    
public:
    PlatformIndicationWrapperStatus(int id, PortalPoller *poller = 0);
    void putFailed ( const uint32_t v );

    const static int putFailed_CHAN_NUM=0;

    const static int putFailed_FIFO_OFFSET= putFailed_CHAN_NUM * (256/4);

};

class PlatformIndicationWrapper : public Portal {
//wrapperClass
public:
    PlatformIndicationWrapper(PortalInternal *p, PortalPoller *poller = 0);
    PlatformIndicationWrapper(int id, PortalPoller *poller = 0);
    virtual void sendWord8 ( const uint64_t word )= 0;
    virtual void sendWord4 ( const uint32_t word )= 0;
    virtual void sendKey ( const uint64_t key )= 0;
    virtual void rawWordTest ( const uint64_t data )= 0;
    virtual void requestWords ( const uint32_t words )= 0;

protected:
    virtual int handleMessage(unsigned int channel);
public:
    const static int sendWord8_CHAN_NUM=0;
    const static int sendWord4_CHAN_NUM=1;
    const static int sendKey_CHAN_NUM=2;
    const static int rawWordTest_CHAN_NUM=3;
    const static int requestWords_CHAN_NUM=4;

    const static int sendWord8_FIFO_OFFSET= sendWord8_CHAN_NUM * 256;
    const static int sendWord4_FIFO_OFFSET= sendWord4_CHAN_NUM * 256;
    const static int sendKey_FIFO_OFFSET= sendKey_CHAN_NUM * 256;
    const static int rawWordTest_FIFO_OFFSET= rawWordTest_CHAN_NUM * 256;
    const static int requestWords_FIFO_OFFSET= requestWords_CHAN_NUM * 256;

};
#endif // _PLATFORMINDICATION_H_
