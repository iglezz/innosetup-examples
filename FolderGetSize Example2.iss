#include "FolderGetSize.iss"

#define SizeExamples FolderGetSize("D:\Proj\Inno\ExamplesSrcFileSets\Examples\")
#define SizeThemes FolderGetSize("D:\Proj\Inno\ExamplesSrcFileSets\Themes\")
#define SizeSum SizeExamples + SizeThemes

[Setup]
AppName=FolderSizeCalcTest
OutputBaseFileName=FolderSizeCalcTest ({#SizeExamples}) ({#SizeThemes}) ({#SizeSum})
AppVersion=0.1
DefaultDirName={tmp}\FolderSizeCalcTest
OutputDir=.
PrivilegesRequired=lowest
