#ifndef WinAPILoader__pas
#define WinAPILoader__pas


#include 'WinAPI.pas'

const
    LOAD_LIBRARY_AS_IMAGE_RESOURCE = $20;
    LOAD_LIBRARY_AS_DATAFILE = $2;

// https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibraryexw
function _WinAPI_LoadLibraryEx(const lpLibFileName: String; const Zero: Integer; const dwFlags: DWORD): HINST; external 'LoadLibraryExW@Kernel32.dll stdcall';

// https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-freelibrary
function _WinAPI_FreeLibrary(const hLibModule: HINST): Boolean; external 'FreeLibrary@Kernel32.dll stdcall';

// https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulehandlew
function _WinAPI_GetModuleHandle(const ModuleName: String): HINST; external 'GetModuleHandleW@Kernel32.dll stdcall';


#endif