#ifndef __GENERATED_TYPES__
#define __GENERATED_TYPES__
typedef enum BlueDBMCmdType { BlueDBMCmdType_Cmd_ReadPage, BlueDBMCmdType_Cmd_WritePage, BlueDBMCmdType_Cmd_EraseBlock } BlueDBMCmdType;
typedef struct BlueDBMCommand {
    uint64_t pageIdx : 64;
    BlueDBMCmdType cmd;
    uint32_t tag : 8;
} BlueDBMCommand;
typedef enum IfcNames { IfcNames_InterfaceIndication, IfcNames_InterfaceRequest, IfcNames_DmaIndication, IfcNames_DmaConfig, IfcNames_PlatformIndication, IfcNames_PlatformRequest } IfcNames;
typedef enum ChannelType { ChannelType_Read, ChannelType_Write } ChannelType;
typedef struct DmaDbgRec {
    uint32_t x : 32;
    uint32_t y : 32;
    uint32_t z : 32;
    uint32_t w : 32;
} DmaDbgRec;
#endif //__GENERATED_TYPES__
