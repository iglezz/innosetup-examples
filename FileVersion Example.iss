#define TESTNAME "FileVersions Example"
[Setup]
AppName={#TESTNAME}
AppVersion=0.1
DefaultDirName={tmp}\{#TESTNAME}
OutputDir=.
OutputBaseFileName={#TESTNAME}
PrivilegesRequired=lowest
CreateAppDir=no
Uninstallable=no

#include "FileVersion.iss"

[Code]

function InitializeSetup(): Boolean;
var
	FileName: String;
	CurrentVersion, MinVersion: TFileVersion; // îáúÿâëÿåì ïåðåìåííûå
begin
	// Çàäà¸ì òðåáóåìóþ âåðñèþ:
	FileVersionSetI(MinVersion, 5, 80, 0, 0);
	// èëè òàê:
	//FileVersionSetS(MinVersion, '5.80.0.10');
	
	// Èìÿ ôàéëà:
	FileName := ExpandConstant('{src}') + '\test.exe';
	
	if Not FileExists(FileName) then begin
		MsgBox('Óñòàíîâêà Ïðåêðàùåíà:'#13#13 + 'Ôàéë `' + ExtractFileName(FileName) + '` íå íàéäåí', mbCriticalError, MB_OK);
		Result := False;
		Exit;
	end;
	
	// Ôàéë ñóùåñòâóåò, ñ÷èòûâàåì âåðñèþ:
	FileVersionSetF(CurrentVersion, FileName);
	
	// Ñðàâíèâàåì è ðåøàåì ÷òî äåëàòü:
	if FileVersionCompare(CurrentVersion, MinVersion) > -1 then
		Result := True
	else begin
		MsgBox('Óñòàíîâêà Ïðåêðàùåíà:' \
		+ #13#13'Âåðñèÿ ôàéëà `' + ExtractFileName(FileName) + '`: ' + FileVersionToStr(CurrentVersion) \
		+ #13#13'Òðåáóåòñÿ âåðñèÿ êàê ìèíèìóì: ' + FileVersionToStr(MinVersion) \
		, mbCriticalError, MB_OK);
		Result := False;
	end;
end;
