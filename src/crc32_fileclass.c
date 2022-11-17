#include <windows.h>
#include <stdint.h>
#include "cnc95.h"
#include "patch.h"

uint32_t GetCRC32(char *fileName)
{
    uint32_t crc32 = 0;
    FileClass file;
    FileClass__FileClass(file, fileName);
    if (FileClass__Is_Available(file))
    {
        int size = FileClass__Size(file);
        if (size > 0)
        {
            void *buf = calloc(size, sizeof(char));
            if (buf)
            {
                FileClass__Read(file, buf, size);
                crc32 = Crc32_ComputeBuf(0, buf, size);
                free(buf);
            }
        }
    }
    FileClass__dtor(file, 0);
    
    return crc32;
}
