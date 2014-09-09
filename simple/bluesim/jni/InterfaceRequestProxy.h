#include "portal.h"
#include "GeneratedTypes.h"
#include <stdio.h>
#include <stdlib.h>
#ifndef _INTERFACEREQUEST_H_
#define _INTERFACEREQUEST_H_
#include "portal.h"
class InterfaceRequestProxyStatus : public Portal {
//wrapperClass
public:
    InterfaceRequestProxyStatus(PortalInternal *p, PortalPoller *poller = 0);
    InterfaceRequestProxyStatus(int id, PortalPoller *poller = 0);
    virtual void putFailed ( const uint32_t v );

protected:
    virtual int handleMessage(unsigned int channel);
public:
    const static int putFailed_CHAN_NUM=0;

    const static int putFailed_FIFO_OFFSET= putFailed_CHAN_NUM * 256;

};

class InterfaceRequestProxy : public PortalInternal {
//proxyClass
    InterfaceRequestProxyStatus *proxyStatus;
public:
    InterfaceRequestProxy(int id, PortalPoller *poller = 0);
    void setDmaHandle ( const uint32_t hostHandle );
    void readPage ( const uint64_t pageIdx, const uint32_t tag );
    void writePage ( const uint64_t pageIdx, const uint32_t tag );
    void readRawWord ( const uint64_t data );

    const static int setDmaHandle_CHAN_NUM=0;
    const static int readPage_CHAN_NUM=1;
    const static int writePage_CHAN_NUM=2;
    const static int readRawWord_CHAN_NUM=3;

    const static int setDmaHandle_FIFO_OFFSET= setDmaHandle_CHAN_NUM * (256/4);
    const static int readPage_FIFO_OFFSET= readPage_CHAN_NUM * (256/4);
    const static int writePage_FIFO_OFFSET= writePage_CHAN_NUM * (256/4);
    const static int readRawWord_FIFO_OFFSET= readRawWord_CHAN_NUM * (256/4);

};
#endif // _INTERFACEREQUEST_H_
