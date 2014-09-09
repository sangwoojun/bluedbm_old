#include "GeneratedTypes.h"

void FlashRequestProxyputFailed_cb(struct PortalInternal *p, const uint32_t v)
{
    const char* methodNameStrings[] = {"startCopy", "readPage", "writePage", "sendTest", "addWriteHostBuffer", "addReadHostBuffer"};
    PORTAL_PRINTF("putFailed: %s\n", methodNameStrings[v]);
    //exit(1);
}

void FlashRequestProxyputFailed_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_FlashRequestProxy_putFailed)]);
        uint32_t v;

        tmp = READL(p, temp_working_addr);
        v = (uint32_t)(((tmp)&0xfffffffful));

    FlashRequestProxyputFailed_cb(p, v);

}

int FlashRequestProxy_handleMessage(PortalInternal *p, unsigned int channel)
{    
    static int runaway = 0;
    
    switch (channel) {

    case CHAN_NUM_FlashRequestProxy_putFailed: 
        FlashRequestProxyputFailed_demarshall(p);
        break;

    default:
        PORTAL_PRINTF("FlashRequestProxy_handleMessage: unknown channel 0x%x\n", channel);
        if (runaway++ > 10) {
            PORTAL_PRINTF("FlashRequestProxy_handleMessage: too many bogus indications, exiting\n");
#ifndef __KERNEL__
            exit(-1);
#endif
        }
        return 0;
    }
    return 0;
}

void FlashRequestProxy_startCopy (PortalInternal *p , const uint32_t wrPointer, const uint32_t rdPointer, const uint32_t numWords, const uint32_t burstLen, const uint32_t iterCnt )
{
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_REQ_FIFO(CHAN_NUM_FlashRequestProxy_startCopy)]);
    int i = 50;
    while (!READL(p, temp_working_addr + 1) && i-- > 0)
        ; /* busy wait a bit on 'fifo not full' */
        WRITEL(p, temp_working_addr, wrPointer);
        WRITEL(p, temp_working_addr, rdPointer);
        WRITEL(p, temp_working_addr, numWords);
        WRITEL(p, temp_working_addr, burstLen);
        WRITEL(p, temp_working_addr, iterCnt);

};

void FlashRequestProxy_readPage (PortalInternal *p , const uint32_t channel, const uint32_t chip, const uint32_t block, const uint32_t page, const uint32_t tag )
{
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_REQ_FIFO(CHAN_NUM_FlashRequestProxy_readPage)]);
    int i = 50;
    while (!READL(p, temp_working_addr + 1) && i-- > 0)
        ; /* busy wait a bit on 'fifo not full' */
        WRITEL(p, temp_working_addr, channel);
        WRITEL(p, temp_working_addr, chip);
        WRITEL(p, temp_working_addr, block);
        WRITEL(p, temp_working_addr, page);
        WRITEL(p, temp_working_addr, tag);

};

void FlashRequestProxy_writePage (PortalInternal *p , const uint32_t channel, const uint32_t chip, const uint32_t block, const uint32_t page, const uint32_t tag )
{
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_REQ_FIFO(CHAN_NUM_FlashRequestProxy_writePage)]);
    int i = 50;
    while (!READL(p, temp_working_addr + 1) && i-- > 0)
        ; /* busy wait a bit on 'fifo not full' */
        WRITEL(p, temp_working_addr, channel);
        WRITEL(p, temp_working_addr, chip);
        WRITEL(p, temp_working_addr, block);
        WRITEL(p, temp_working_addr, page);
        WRITEL(p, temp_working_addr, tag);

};

void FlashRequestProxy_sendTest (PortalInternal *p , const uint32_t data )
{
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_REQ_FIFO(CHAN_NUM_FlashRequestProxy_sendTest)]);
    int i = 50;
    while (!READL(p, temp_working_addr + 1) && i-- > 0)
        ; /* busy wait a bit on 'fifo not full' */
        WRITEL(p, temp_working_addr, data);

};

void FlashRequestProxy_addWriteHostBuffer (PortalInternal *p , const uint32_t pointer, const uint32_t idx )
{
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_REQ_FIFO(CHAN_NUM_FlashRequestProxy_addWriteHostBuffer)]);
    int i = 50;
    while (!READL(p, temp_working_addr + 1) && i-- > 0)
        ; /* busy wait a bit on 'fifo not full' */
        WRITEL(p, temp_working_addr, pointer);
        WRITEL(p, temp_working_addr, idx);

};

void FlashRequestProxy_addReadHostBuffer (PortalInternal *p , const uint32_t pointer, const uint32_t idx )
{
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_REQ_FIFO(CHAN_NUM_FlashRequestProxy_addReadHostBuffer)]);
    int i = 50;
    while (!READL(p, temp_working_addr + 1) && i-- > 0)
        ; /* busy wait a bit on 'fifo not full' */
        WRITEL(p, temp_working_addr, pointer);
        WRITEL(p, temp_working_addr, idx);

};
