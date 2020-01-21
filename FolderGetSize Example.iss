#include "FolderGetSize.iss"

#define SizeExamples FolderGetSize(SourcePath + "my examples")
#define SizeThemes FolderGetSize(SourcePath + "Themes\")

[Setup]
AppName=FolderSizeCalcTest
OutputBaseFileName=FolderSizeCalcTest ({#SizeExamples}) ({#SizeThemes})
AppVersion=0.1
DefaultDirName={tmp}\FolderSizeCalcTest
OutputDir=.
PrivilegesRequired=lowest
