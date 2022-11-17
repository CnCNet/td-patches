#include <stdbool.h>

// This header is used for patches
// This header will be split up as it becomes larger

// ### Variables ###

extern bool UseBalancePatch;


// ### Functions ###

unsigned long Crc32_ComputeBuf( unsigned long inCrc32, const void *buf, size_t bufLen );

