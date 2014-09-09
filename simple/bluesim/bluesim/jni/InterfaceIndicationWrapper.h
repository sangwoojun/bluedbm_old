#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#ifndef _INTERFACEINDICATION_H_
#define _INTERFACEINDICATION_H_

class InterfaceIndicationWrapperStatus : public PortalInternal {
//proxyClass
    
public:
    InterfaceIndicationWrapperStatus(int id, PortalPoller *poller = 0);
    void putFailed ( const uint32_t v );

    const static int putFailed_CHAN_NUM=0;

    const static int putFailed_FIFO_OFFSET= putFailed_CHAN_NUM * (256/4);

};

class InterfaceIndicationWrapper : public Portal {
//wrapperClass
public:
    InterfaceIndicationWrapper(PortalInternal *p, PortalPoller *poller = 0);
    InterfaceIndicationWrapper(int id, PortalPoller *poller = 0);
    virtual void pageReadDone ( const uint32_t tag )= 0;
    virtual void pageWriteDone ( const uint32_t tag )= 0;
    virtual void pageWriteFail ( const uint32_t tag )= 0;
    virtual void hexdump ( const uint32_t a, const uint32_t b )= 0;
    virtual void writeRawWord ( const uint64_t data )= 0;

protected:
    virtual int handleMessage(unsigned int channel);
public:
    const static int pageReadDone_CHAN_NUM=0;
    const static int pageWriteDone_CHAN_NUM=1;
    const static int pageWriteFail_CHAN_NUM=2;
    const static int hexdump_CHAN_NUM=3;
    const static int writeRawWord_CHAN_NUM=4;

    const static int pageReadDone_FIFO_OFFSET= pageReadDone_CHAN_NUM * 256;
    const static int pageWriteDone_FIFO_OFFSET= pageWriteDone_CHAN_NUM * 256;
    const static int pageWriteFail_FIFO_OFFSET= pageWriteFail_CHAN_NUM * 256;
    const static int hexdump_FIFO_OFFSET= hexdump_CHAN_NUM * 256;
    const static int writeRawWord_FIFO_OFFSET= writeRawWord_CHAN_NUM * 256;

};
#endif // _INTERFACEINDICATION_H_
