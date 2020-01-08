; FileVersion library version 0.1
; 
; 
; Usage:
; // Outside [Code] section of .iss:
; #include "FileVersion.iss"            // add this library to your .iss
; 
; // Under `var` variable declaration block on [Code] section of .iss:
; Version: TFileVersion;                    // declare variable `Version`
; 
; // Set Version:
; FileVersionSetS(Version, STRING)          // set Version from string STRING ('1.2.3.4')
; FileVersionSetI(Version, N1, N2, N3, N4)  // set Version from numbers N1, N2, N3, N4 (N1.N2.N3.N4)
; FileVersionSetS(Version, FILE)            // set Version from file FILE
; 
; // Use Version:
; FileVersionToStr(Version)                 // return 'x.x.x.x' string representation of Version
; FileVersionCompare(Version1, Version2)    // return:
;                                           // -1 if (Version1 < Version2)
;                                           //  0 if (Version1 = Version2)
;                                           //  1 if (Version1 > Version2)
; 

[Code]
type
	TFileVersion = array[1..4] of Integer;


// Internal function
procedure FileVersionExtractNumber(var VersionString: String; var VersionNumber: Integer);
var
	DotPosition: Integer;
begin
	DotPosition := Pos('.', VersionString);
	if DotPosition > 0 then begin
		VersionNumber := StrToInt(Copy(VersionString, 1, DotPosition - 1));
		VersionString := Copy(VersionString, DotPosition + 1, 99);
	end	
	else begin
		VersionNumber := StrToInt(VersionString);
		VersionString := '';
	end;
end;


// Set TFileVersion from integers
procedure FileVersionSetI(var Version: TFileVersion; v1, v2, v3, v4: Integer);
begin
	Version[1] := v1;
	Version[2] := v2;
	Version[3] := v3;
	Version[4] := v4;
end;


// Set TFileVersion from string
procedure FileVersionSetS(var Version: TFileVersion; VersionString: String);
var
	i: Integer;
begin
	for i := 1 to 4 do
		FileVersionExtractNumber(VersionString, Version[i]);
end;


// Set TFileVersion from file
procedure FileVersionSetF(var Version: TFileVersion; FileName: String);
var
	VersionString: String;
begin
	GetVersionNumbersString(FileName, VersionString);
	FileVersionSetS(Version, VersionString);
end;


// Compare TFileVersions
// Return -1 if (CurrentVersion < CompareVersion)
// Return  0 if (CurrentVersion = CompareVersion)
// Return  1 if (CurrentVersion > CompareVersion)
function FileVersionCompare(CurrentVersion, CompareVersion: TFileVersion): Integer;
var
	i: Integer;
begin
	for i := 1 to 4 do
		if CurrentVersion[i] < CompareVersion[i] then begin
			Result := -1;
			Exit;
		end
		else if CurrentVersion[i] > CompareVersion[i] then begin
			Result := 1;
			Exit;
		end;
		
	Result := 0;
end;

// Return "x.x.x.x" string representation of TFileVersion
function FileVersionToStr(Version: TFileVersion): String;
var
	i: Integer;
begin
	Result := IntToStr(Version[1]);
	
	for i := 2 to 4 do
		Result := Result + '.' + IntToStr(Version[i]);
end;

// Test procedure
procedure FileVersionTestFileAgainstString(FileName, Version: String);
var
	CurrentVersion, MinVersion: TFileVersion;
	CompareResult: Integer;
begin
	FileVersionSetF(CurrentVersion, FileName);
	FileVersionSetS(MinVersion, Version);

	MsgBox('Тест файла: `' + ExtractFileName(FileName) + '`: ' \
	+ #13#13'Версия файла: '#9 + FileVersionToStr(CurrentVersion) \
	+ #13#13'Сравнить с: '#9 + FileVersionToStr(MinVersion) \
	+ #13#13'Результат: '#9 + IntToStr(FileVersionCompare(CurrentVersion, MinVersion)) \
	, mbInformation, MB_OK);
end;
