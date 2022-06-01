#define APPNAME "MessageBoxIndirect test"

[Setup]
AppName={#APPNAME}
AppVersion=0.1
DisableWelcomePage=yes
DefaultDirName={tmp}\{#APPNAME}
OutputDir=.
OutputBaseFilename={#APPNAME}
PrivilegesRequired=lowest


[code]
#include 'WinAPI_MessageBoxIndirect.pas'

procedure initializeWizard();
var
    dllname: String;
    ret: Integer;
begin
    // Standard icons:
    MsgBox('std mbInformation', mbInformation, MB_OK);
    MsgBoxEx('ex MB_ICONINFORMATION', '{#APPNAME}', 0, IDI_INFORMATION, MB_OK);
    MsgBoxEx('ex IDI_INFORMATION', '{#APPNAME}', 0, IDI_INFORMATION, MB_OK);
    MsgBox('std mbConfirmation', mbConfirmation, MB_OK);
    MsgBoxEx('ex IDI_QUESTION', '{#APPNAME}', 0, IDI_QUESTION, MB_OK);
    MsgBox('std mbError', mbError, MB_OK);
    MsgBoxEx('ex IDI_EXCLAMATION', '{#APPNAME}', 0, IDI_EXCLAMATION, MB_OK);
    MsgBox('std mbCriticalError', mbCriticalError, MB_OK);
    MsgBoxEx('ex IDI_ERROR', '{#APPNAME}', 0, IDI_ERROR, MB_OK);
    MsgBoxEx('ex IDI_SHIELD', '{#APPNAME}', 0, IDI_SHIELD, MB_OK);
    MsgBoxEx('ex IDI_APPLICATION', '{#APPNAME}', 0, IDI_APPLICATION, MB_OK);

    // Icon from installer
    MsgBoxEx('Installer icon', '{#APPNAME}', '', 'MAINICON', MB_OK)

    // Icon from exe/dll file
    dllname := 'C:\Program Files\Totalcmd\TOTALCMD.EXE'
    MsgBoxEx('app icon (text)'#10'from'#10+dllname, '{#APPNAME}', dllname, 'MAINICON', MB_OK)
    MsgBoxEx('app icon (num)'#10'from'#10+dllname, '{#APPNAME}', dllname, 6, MB_OK)

    // Icon from exe/dll file. failed to load.
    MsgBoxEx('LoadLibrary error', '{#APPNAME}', 'x:\notexist', 'MAINICON', MB_OK)

    // Return code test loop
    dllname := 'C:\Windows\SysWOW64\shell32.dll'
    while true do
    begin
        ret := MsgBoxEx('icon from'#10+dllname, '{#APPNAME}', dllname, 337, MB_YESNOCANCEL or MB_DEFBUTTON2);

        case ret of
            IDYES:
                ret := MsgBoxEx('YES'#10#10'Continue?', '{#APPNAME}', dllname, 16802, MB_YESNO);
            IDNO:
                ret := MsgBoxEx('NO'#10#10'Continue?', '{#APPNAME}', dllname, 240, MB_YESNO);
            IDCANCEL:
                ret := MsgBoxEx('CANCEL'#10#10'Continue?', '{#APPNAME}', dllname, 142, MB_YESNO);
        end;
        if ret = IDNO then break;
    end;


    Abort;
end;