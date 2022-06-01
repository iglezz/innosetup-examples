#ifndef WinAPIError__pas
#define WinAPIError__pas


// https://docs.microsoft.com/en-us/windows/win32/api/errhandlingapi/nf-errhandlingapi-getlasterror
// System error codes:
// https://docs.microsoft.com/en-us/windows/win32/debug/system-error-codes
function _WinAPI_GetLastError(): DWORD; external 'GetLastError@Kernel32.dll stdcall';


#endif