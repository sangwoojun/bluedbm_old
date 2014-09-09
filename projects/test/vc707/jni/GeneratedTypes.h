#ifndef __GENERATED_TYPES__
#define __GENERATED_TYPES__
#include "portal.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef enum CmdType { CmdType_Read, CmdType_Write, CmdType_Erase } CmdType;
typedef struct FlashCmd {
    uint32_t channel : 5;
    uint32_t chip : 5;
    uint32_t block : 8;
    uint32_t page : 8;
    CmdType cmd;
    uint32_t tag : 8;
} FlashCmd;
typedef enum IfcNames { IfcNames_FlashIndication, IfcNames_FlashRequest, IfcNames_DmaIndication, IfcNames_DmaConfig } IfcNames;
typedef enum ChannelType { ChannelType_Read, ChannelType_Write } ChannelType;
typedef struct DmaDbgRec {
    uint32_t x : 32;
    uint32_t y : 32;
    uint32_t z : 32;
    uint32_t w : 32;
} DmaDbgRec;
typedef enum DmaErrorType { DmaErrorType_DmaErrorNone, DmaErrorType_DmaErrorBadPointer1, DmaErrorType_DmaErrorBadPointer2, DmaErrorType_DmaErrorBadPointer3, DmaErrorType_DmaErrorBadPointer4, DmaErrorType_DmaErrorBadPointer5, DmaErrorType_DmaErrorBadAddrTrans, DmaErrorType_DmaErrorBadPageSize, DmaErrorType_DmaErrorBadNumberEntries, DmaErrorType_DmaErrorBadAddr, DmaErrorType_DmaErrorTagMismatch } DmaErrorType;

enum { CHAN_NUM_FlashRequestProxy_startCopy,CHAN_NUM_FlashRequestProxy_readPage,CHAN_NUM_FlashRequestProxy_writePage,CHAN_NUM_FlashRequestProxy_sendTest,CHAN_NUM_FlashRequestProxy_addWriteHostBuffer,CHAN_NUM_FlashRequestProxy_addReadHostBuffer,CHAN_NUM_FlashRequestProxy_putFailed};

int FlashRequestProxy_handleMessage(struct PortalInternal *p, unsigned int channel);

void FlashRequestProxy_startCopy (struct PortalInternal *p , const uint32_t wrPointer, const uint32_t rdPointer, const uint32_t numWords, const uint32_t burstLen, const uint32_t iterCnt );

void FlashRequestProxy_readPage (struct PortalInternal *p , const uint32_t channel, const uint32_t chip, const uint32_t block, const uint32_t page, const uint32_t tag );

void FlashRequestProxy_writePage (struct PortalInternal *p , const uint32_t channel, const uint32_t chip, const uint32_t block, const uint32_t page, const uint32_t tag );

void FlashRequestProxy_sendTest (struct PortalInternal *p , const uint32_t data );

void FlashRequestProxy_addWriteHostBuffer (struct PortalInternal *p , const uint32_t pointer, const uint32_t idx );

void FlashRequestProxy_addReadHostBuffer (struct PortalInternal *p , const uint32_t pointer, const uint32_t idx );
enum { CHAN_NUM_DmaConfigProxy_sglist,CHAN_NUM_DmaConfigProxy_region,CHAN_NUM_DmaConfigProxy_addrRequest,CHAN_NUM_DmaConfigProxy_getStateDbg,CHAN_NUM_DmaConfigProxy_getMemoryTraffic,CHAN_NUM_DmaConfigProxy_putFailed};

int DmaConfigProxy_handleMessage(struct PortalInternal *p, unsigned int channel);

void DmaConfigProxy_sglist (struct PortalInternal *p , const uint32_t pointer, const uint32_t pointerIndex, const uint64_t addr, const uint32_t len );

void DmaConfigProxy_region (struct PortalInternal *p , const uint32_t pointer, const uint64_t barr8, const uint32_t index8, const uint64_t barr4, const uint32_t index4, const uint64_t barr0, const uint32_t index0 );

void DmaConfigProxy_addrRequest (struct PortalInternal *p , const uint32_t pointer, const uint32_t offset );

void DmaConfigProxy_getStateDbg (struct PortalInternal *p , const ChannelType rc );

void DmaConfigProxy_getMemoryTraffic (struct PortalInternal *p , const ChannelType rc );

int FlashIndicationWrapper_handleMessage(struct PortalInternal *p, unsigned int channel);
void FlashIndicationWrapperstarted_cb (  struct PortalInternal *p );
void FlashIndicationWrapperreadDone_cb (  struct PortalInternal *p, const uint32_t tag );
void FlashIndicationWrapperwriteDone_cb (  struct PortalInternal *p, const uint32_t tag );
void FlashIndicationWrapperhexDump_cb (  struct PortalInternal *p, const uint32_t data );
enum { CHAN_NUM_FlashIndicationWrapper_started,CHAN_NUM_FlashIndicationWrapper_readDone,CHAN_NUM_FlashIndicationWrapper_writeDone,CHAN_NUM_FlashIndicationWrapper_hexDump};

int DmaIndicationWrapper_handleMessage(struct PortalInternal *p, unsigned int channel);
void DmaIndicationWrapperconfigResp_cb (  struct PortalInternal *p, const uint32_t pointer );
void DmaIndicationWrapperaddrResponse_cb (  struct PortalInternal *p, const uint64_t physAddr );
void DmaIndicationWrapperreportStateDbg_cb (  struct PortalInternal *p, const DmaDbgRec rec );
void DmaIndicationWrapperreportMemoryTraffic_cb (  struct PortalInternal *p, const uint64_t words );
void DmaIndicationWrapperdmaError_cb (  struct PortalInternal *p, const uint32_t code, const uint32_t pointer, const uint64_t offset, const uint64_t extra );
enum { CHAN_NUM_DmaIndicationWrapper_configResp,CHAN_NUM_DmaIndicationWrapper_addrResponse,CHAN_NUM_DmaIndicationWrapper_reportStateDbg,CHAN_NUM_DmaIndicationWrapper_reportMemoryTraffic,CHAN_NUM_DmaIndicationWrapper_dmaError};
#ifdef __cplusplus
}
#endif
#endif //__GENERATED_TYPES__
