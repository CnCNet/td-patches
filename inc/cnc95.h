#include <stdbool.h>

// This header is used for patches
// This header will be split up as it becomes larger

// ### Variables ###

// ### types ###

typedef char INIClass[4048];
typedef char FileClass[128];

// ### Functions ###

bool INIClass_ReadBool(char *section, char *key, bool defaultValue, INIClass iniClass);
int INIClass__Get_Int(char *section, char *key, int defaultValue, INIClass iniClass);
void INIClass__Get_String(char *section, char *key, char *defaultValue, char *returnedString, int size, INIClass iniClass);

void FileClass__FileClass(FileClass fileClass, char *fileName);
bool FileClass__Is_Available(FileClass fileClass);
int FileClass__Size(FileClass fileClass);
void FileClass__Read(FileClass fileClass, void *buf, size_t len);
void FileClass__dtor(FileClass fileClass, int flags);

unsigned long Crc32_ComputeBuf( unsigned long inCrc32, const void *buf, size_t bufLen );
