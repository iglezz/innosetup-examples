#ifndef WinAPI_MessageBoxIndirect__pas
#define WinAPI_MessageBoxIndirect__pas


#include 'WinAPI.pas'
#include 'WinAPILoader.pas'

const
    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebox
    MB_CANCELTRYCONTINUE = $00000006;

    MB_ICONERROR = $00000010;
    MB_ICONSTOP = MB_ICONERROR;
    MB_ICONHAND = MB_ICONERROR;
    MB_ICONQUESTION = $00000020;
    MB_ICONWARNING = $00000030;
    MB_ICONEXCLAMATION = MB_ICONWARNING;
    MB_ICONINFORMATION = $00000040;
    MB_ICONASTERISK = MB_ICONINFORMATION;
    MB_USERICON = $00000080;

    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-loadiconw
    IDI_APPLICATION = 32512;
    IDI_INFORMATION = 32516;
    IDI_ASTERISK = IDI_INFORMATION;
    IDI_ERROR = 32513;
    IDI_HAND = IDI_ERROR;
    IDI_WARNING = 32515;
    IDI_EXCLAMATION = IDI_WARNING;
    IDI_QUESTION = 32514;
    IDI_SHIELD = 32518;

    IDTRYAGAIN = 10;
    IDCONTINUE = 11;

type
    
    // MSGBOXPARAMSW structure
    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-msgboxparamsw
    // lpszIcon - string type
    _WinAPI_tagMSGBOXPARAMS_S = record
        cbSize: UINT;
        hwndOwner: HWND;
        hInstance: HINST;
        lpszText: String;
        lpszCaption: String;
        dwStyle: DWORD;
        lpszIcon: String;
        dwContextHelpId: DWORD_PTR;
        lpfnMsgBoxCallback: Pointer;
        dwLanguageId: DWORD;
    end;
    // lpszIcon - numeric type
    _WinAPI_tagMSGBOXPARAMS_N = record
        cbSize: UINT;
        hwndOwner: HWND;
        hInstance: HINST;
        lpszText: String;
        lpszCaption: String;
        dwStyle: DWORD;
        lpszIcon: DWORD;
        dwContextHelpId: DWORD_PTR;
        lpfnMsgBoxCallback: Pointer;
        dwLanguageId: DWORD;
    end;


//  https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messageboxindirectw
function _WinAPI_MessageBoxIndirect_S(const MsgBoxParams: _WinAPI_tagMSGBOXPARAMS_S): Integer; external 'MessageBoxIndirectW@user32.dll stdcall';

function _WinAPI_MessageBoxIndirect_N(const MsgBoxParams: _WinAPI_tagMSGBOXPARAMS_N): Integer; external 'MessageBoxIndirectW@user32.dll stdcall';




function MsgBoxExNI(
                    const Text: String;
                    const Caption: String;
                    const hInstance: HINST;
                    const IconNumber: DWORD;
                    const Flags: DWORD
                    ): Integer;
var
    mp: _WinAPI_tagMSGBOXPARAMS_N;
begin
    mp.cbSize := SizeOf(mp);
    mp.hInstance := hInstance;
    mp.lpszText := Text;
    mp.lpszCaption := Caption;

    if (IconNumber < IDI_APPLICATION) and (hInstance = 0) then
        mp.dwStyle := Flags or IconNumber
    else
    begin
        mp.dwStyle := Flags or MB_USERICON;
        mp.lpszIcon := IconNumber;
    end;

    Result := _WinAPI_MessageBoxIndirect_N(mp);
end;


function MsgBoxExSI(
                    const Text: String;
                    const Caption: String;
                    const hInstance: HINST;
                    const IconName: String;
                    const Flags: DWORD
                    ): Integer;
var
    mp: _WinAPI_tagMSGBOXPARAMS_S;
begin
    mp.cbSize := SizeOf(mp);
    mp.hInstance := hInstance;
    mp.lpszText := Text;
    mp.lpszCaption := Caption;
    mp.dwStyle := Flags or MB_USERICON;
    mp.lpszIcon := IconName;

    Result := _WinAPI_MessageBoxIndirect_S(mp);
end;

(* function MsgBoxEx


    Text: `Messagebox text`

    Caption: `Messagebox caption`

    IconSource: 0      -- standard icons: MB_ICON*, IDI_*
              : ''     -- load icon from INSTALLER_EXE
              : 'FILE' -- load icon from FILE

    IconID: MB_ICON*, IDI_* -- if IconSource = 0
          : <icon name/number> if IconSource = '*'

    Flags:  MB_OK, MB_OKCANCEL, MB_ABORTRETRYIGNORE, MB_YESNOCANCEL, MB_YESNO,
            MB_RETRYCANCEL, MB_CANCELTRYCONTINUE,
            MB_DEFBUTTON1, MB_DEFBUTTON2, MB_DEFBUTTON3, MB_SETFOREGROUND


    Return: IDOK, IDCANCEL, IDABORT, IDRETRY, IDIGNORE, IDYES, IDNO, IDTRYAGAIN, IDCONTINUE
*)
function MsgBoxEx(
                  const Text: String;
                  const Caption: String;
                  const IconSource: Variant;
                  const IconID: Variant;
                  const Flags: DWORD
                ): Integer;
var
    hInstance: HINST;
    UsedIconID: Variant;
begin
    hInstance := 0;
    UsedIconID := IconID;

    if VarType(IconSource) <> varInteger then
    begin
        if IconSource = '' then
            hInstance := _WinAPI_GetModuleHandle('')
        else
            hInstance := _WinAPI_LoadLibraryEx(IconSource, 0, LOAD_LIBRARY_AS_IMAGE_RESOURCE);

        if hInstance = 0 then
            UsedIconID := IDI_APPLICATION // fallback to 'defaulticon'
    end;

    if VarType(UsedIconID) = varInteger then
        Result := MsgBoxExNI(Text, Caption, hInstance, UsedIconID, Flags)
    else
        Result := MsgBoxExSI(Text, Caption, hInstance, UsedIconID, Flags);

    if (hInstance > 0) and (IconSource <> '') then _WinAPI_FreeLibrary(hInstance);
end;


#endif