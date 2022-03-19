#define TESTNAME "FileBuildList1 Example"
#define TESTSRCDIR "D:\Proj\Inno\ExamplesSrcFileSets"

[Setup]
AppName={#TESTNAME}
AppVersion=0.1
DefaultDirName=D:\Proj\Inno\ExamplesSandbox\{#TESTNAME}
OutputDir=D:\Proj\Inno\ExamplesOut
OutputBaseFileName={#TESTNAME}
PrivilegesRequired=lowest
Uninstallable=no

[Files]
Source: "{#TESTSRCDIR}\Themes\*.*"; DestDir: "{app}\Themes"; Flags: recursesubdirs

[Code]
function FileBuildList1(Folder, FileMask: String; TrimFirstChars: Integer): String;
var
	FindRec: TFindRec;
	FilesList: String;
begin
	FilesList := Copy(Folder, TrimFirstChars + 1, 999) + #13#10; 
	if FindFirst(Folder + '\' + FileMask, FindRec) then begin
		try
			repeat
				if (FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY) = 16 then begin
					if Not ((FindRec.Name = '.') or (FindRec.Name = '..')) then begin
						//FilesList := FilesList + Copy(Folder + '\' + FindRec.Name, TrimFirstChars + 1, 999) + #13#10;
						FilesList := FilesList + FileBuildList1(Folder + '\' + FindRec.Name, '*', TrimFirstChars);
					end;
				end else begin
					FilesList := FilesList + Copy(Folder + '\' + FindRec.Name, TrimFirstChars + 1, 999) + #13#10;
				end;
			until not FindNext(FindRec);
		finally
			FindClose(FindRec);
		end;
	end;
	
	Result := FilesList;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
	FilesList: String;
begin
	if CurStep = ssPostInstall then	begin
		FilesList := #13#10 'rarreg.key' + #13#10 + 'version.dat' + #13#10#13#10;
		FilesList := FilesList + FileBuildList1(ExpandConstant('{app}\Themes'), '*', Length(ExpandConstant('{app}\')));
		SaveStringToFile(ExpandConstant('{app}\Uninstall.lst'), FilesList, True);
	end;
end;
