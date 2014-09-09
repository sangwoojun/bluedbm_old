#include "GeneratedTypes.h"

void FlashIndicationWrapperstarted_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_FlashIndicationWrapper_started)]);
        int padding;

        tmp = READL(p, temp_working_addr);

    FlashIndicationWrapperstarted_cb(p);

}

void FlashIndicationWrapperreadDone_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_FlashIndicationWrapper_readDone)]);
        uint32_t tag;

        tmp = READL(p, temp_working_addr);
        tag = (uint32_t)(((tmp)&0xfffffffful));

    FlashIndicationWrapperreadDone_cb(p, tag);

}

void FlashIndicationWrapperwriteDone_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_FlashIndicationWrapper_writeDone)]);
        uint32_t tag;

        tmp = READL(p, temp_working_addr);
        tag = (uint32_t)(((tmp)&0xfffffffful));

    FlashIndicationWrapperwriteDone_cb(p, tag);

}

void FlashIndicationWrapperhexDump_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_FlashIndicationWrapper_hexDump)]);
        uint32_t data;

        tmp = READL(p, temp_working_addr);
        data = (uint32_t)(((tmp)&0xfffffffful));

    FlashIndicationWrapperhexDump_cb(p, data);

}

int FlashIndicationWrapper_handleMessage(PortalInternal *p, unsigned int channel)
{    
    static int runaway = 0;
    
    switch (channel) {

    case CHAN_NUM_FlashIndicationWrapper_started: 
        FlashIndicationWrapperstarted_demarshall(p);
        break;

    case CHAN_NUM_FlashIndicationWrapper_readDone: 
        FlashIndicationWrapperreadDone_demarshall(p);
        break;

    case CHAN_NUM_FlashIndicationWrapper_writeDone: 
        FlashIndicationWrapperwriteDone_demarshall(p);
        break;

    case CHAN_NUM_FlashIndicationWrapper_hexDump: 
        FlashIndicationWrapperhexDump_demarshall(p);
        break;

    default:
        PORTAL_PRINTF("FlashIndicationWrapper_handleMessage: unknown channel 0x%x\n", channel);
        if (runaway++ > 10) {
            PORTAL_PRINTF("FlashIndicationWrapper_handleMessage: too many bogus indications, exiting\n");
#ifndef __KERNEL__
            exit(-1);
#endif
        }
        return 0;
    }
    return 0;
}
