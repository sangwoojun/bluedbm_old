#include "GeneratedTypes.h"

#ifndef NO_CPP_PORTAL_CODE



/************** Start of FlashIndicationWrapper CPP ***********/
#include "FlashIndicationWrapper.h"
void FlashIndicationWrapperstarted_cb (  struct PortalInternal *p ) {
    (static_cast<FlashIndicationWrapper *>(p->parent))->started ( );
};

void FlashIndicationWrapperreadDone_cb (  struct PortalInternal *p, const uint32_t tag ) {
    (static_cast<FlashIndicationWrapper *>(p->parent))->readDone ( tag);
};

void FlashIndicationWrapperwriteDone_cb (  struct PortalInternal *p, const uint32_t tag ) {
    (static_cast<FlashIndicationWrapper *>(p->parent))->writeDone ( tag);
};

void FlashIndicationWrapperhexDump_cb (  struct PortalInternal *p, const uint32_t data ) {
    (static_cast<FlashIndicationWrapper *>(p->parent))->hexDump ( data);
};


/************** Start of DmaIndicationWrapper CPP ***********/
#include "DmaIndicationWrapper.h"
void DmaIndicationWrapperconfigResp_cb (  struct PortalInternal *p, const uint32_t pointer ) {
    (static_cast<DmaIndicationWrapper *>(p->parent))->configResp ( pointer);
};

void DmaIndicationWrapperaddrResponse_cb (  struct PortalInternal *p, const uint64_t physAddr ) {
    (static_cast<DmaIndicationWrapper *>(p->parent))->addrResponse ( physAddr);
};

void DmaIndicationWrapperreportStateDbg_cb (  struct PortalInternal *p, const DmaDbgRec rec ) {
    (static_cast<DmaIndicationWrapper *>(p->parent))->reportStateDbg ( rec);
};

void DmaIndicationWrapperreportMemoryTraffic_cb (  struct PortalInternal *p, const uint64_t words ) {
    (static_cast<DmaIndicationWrapper *>(p->parent))->reportMemoryTraffic ( words);
};

void DmaIndicationWrapperdmaError_cb (  struct PortalInternal *p, const uint32_t code, const uint32_t pointer, const uint64_t offset, const uint64_t extra ) {
    (static_cast<DmaIndicationWrapper *>(p->parent))->dmaError ( code, pointer, offset, extra);
};

#endif //NO_CPP_PORTAL_CODE
