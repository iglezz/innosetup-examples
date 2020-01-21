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
	CurrentVersion, MinVersion: TFileVersion; // объявляем переменные
begin
	// Задаём требуемую версию:
	FileVersionSetI(MinVersion, 5, 80, 0, 0);
	// или так:
	//FileVersionSetS(MinVersion, '5.80.0.10');
	
	// Имя файла:
	FileName := ExpandConstant('{src}') + '\test.exe';
	
	if Not FileExists(FileName) then begin
		MsgBox('Установка Прекращена:'#13#13 + 'Файл `' + ExtractFileName(FileName) + '` не найден', mbCriticalError, MB_OK);
		Result := False;
		Exit;
	end;
	
	// Файл существует, считываем версию:
	FileVersionSetF(CurrentVersion, FileName);
	
	// Сравниваем и решаем что делать:
	if FileVersionCompare(CurrentVersion, MinVersion) > -1 then
		Result := True
	else begin
		MsgBox('Установка Прекращена:' \
		+ #13#13'Версия файла `' + ExtractFileName(FileName) + '`: ' + FileVersionToStr(CurrentVersion) \
		+ #13#13'Требуется версия как минимум: ' + FileVersionToStr(MinVersion) \
		, mbCriticalError, MB_OK);
		Result := False;
	end;
end;
