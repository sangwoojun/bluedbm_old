#include "GeneratedTypes.h"

void DmaIndicationWrapperconfigResp_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_DmaIndicationWrapper_configResp)]);
        uint32_t pointer;

        tmp = READL(p, temp_working_addr);
        pointer = (uint32_t)(((tmp)&0xfffffffful));

    DmaIndicationWrapperconfigResp_cb(p, pointer);

}

void DmaIndicationWrapperaddrResponse_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_DmaIndicationWrapper_addrResponse)]);
        uint64_t physAddr;

        tmp = READL(p, temp_working_addr);
        physAddr = (uint64_t)(((uint64_t)(((tmp)&0xfffffffful))<<32));
        tmp = READL(p, temp_working_addr);
        physAddr |= (uint64_t)(((tmp)&0xfffffffffffffffful));

    DmaIndicationWrapperaddrResponse_cb(p, physAddr);

}

void DmaIndicationWrapperreportStateDbg_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_DmaIndicationWrapper_reportStateDbg)]);
        DmaDbgRec rec;

        tmp = READL(p, temp_working_addr);
        rec.x = (uint32_t)(((tmp)&0xfffffffful));
        tmp = READL(p, temp_working_addr);
        rec.y = (uint32_t)(((tmp)&0xfffffffful));
        tmp = READL(p, temp_working_addr);
        rec.z = (uint32_t)(((tmp)&0xfffffffful));
        tmp = READL(p, temp_working_addr);
        rec.w = (uint32_t)(((tmp)&0xfffffffful));

    DmaIndicationWrapperreportStateDbg_cb(p, rec);

}

void DmaIndicationWrapperreportMemoryTraffic_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_DmaIndicationWrapper_reportMemoryTraffic)]);
        uint64_t words;

        tmp = READL(p, temp_working_addr);
        words = (uint64_t)(((uint64_t)(((tmp)&0xfffffffful))<<32));
        tmp = READL(p, temp_working_addr);
        words |= (uint64_t)(((tmp)&0xfffffffffffffffful));

    DmaIndicationWrapperreportMemoryTraffic_cb(p, words);

}

void DmaIndicationWrapperdmaError_demarshall(PortalInternal *p){
    unsigned int tmp;
    volatile unsigned int* temp_working_addr = &(p->map_base[PORTAL_IND_FIFO(CHAN_NUM_DmaIndicationWrapper_dmaError)]);
        uint32_t code;
        uint32_t pointer;
        uint64_t offset;
        uint64_t extra;

        tmp = READL(p, temp_working_addr);
        code = (uint32_t)(((tmp)&0xfffffffful));
        tmp = READL(p, temp_working_addr);
        pointer = (uint32_t)(((tmp)&0xfffffffful));
        tmp = READL(p, temp_working_addr);
        offset = (uint64_t)(((uint64_t)(((tmp)&0xfffffffful))<<32));
        tmp = READL(p, temp_working_addr);
        offset |= (uint64_t)(((tmp)&0xfffffffffffffffful));
        tmp = READL(p, temp_working_addr);
        extra = (uint64_t)(((uint64_t)(((tmp)&0xfffffffful))<<32));
        tmp = READL(p, temp_working_addr);
        extra |= (uint64_t)(((tmp)&0xfffffffffffffffful));

    DmaIndicationWrapperdmaError_cb(p, code, pointer, offset, extra);

}

int DmaIndicationWrapper_handleMessage(PortalInternal *p, unsigned int channel)
{    
    static int runaway = 0;
    
    switch (channel) {

    case CHAN_NUM_DmaIndicationWrapper_configResp: 
        DmaIndicationWrapperconfigResp_demarshall(p);
        break;

    case CHAN_NUM_DmaIndicationWrapper_addrResponse: 
        DmaIndicationWrapperaddrResponse_demarshall(p);
        break;

    case CHAN_NUM_DmaIndicationWrapper_reportStateDbg: 
        DmaIndicationWrapperreportStateDbg_demarshall(p);
        break;

    case CHAN_NUM_DmaIndicationWrapper_reportMemoryTraffic: 
        DmaIndicationWrapperreportMemoryTraffic_demarshall(p);
        break;

    case CHAN_NUM_DmaIndicationWrapper_dmaError: 
        DmaIndicationWrapperdmaError_demarshall(p);
        break;

    default:
        PORTAL_PRINTF("DmaIndicationWrapper_handleMessage: unknown channel 0x%x\n", channel);
        if (runaway++ > 10) {
            PORTAL_PRINTF("DmaIndicationWrapper_handleMessage: too many bogus indications, exiting\n");
#ifndef __KERNEL__
            exit(-1);
#endif
        }
        return 0;
    }
    return 0;
}
