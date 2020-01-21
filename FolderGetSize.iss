; Function FolderGetSize
; version 0.2
;
; Returns folder size in bytes
;
; Usage:
;
; #include "FolderGetSize.iss"
; #define YOURVARIABLE FolderGetSize(FOLDERPATH)
;
;
; Example:
;
; #define SizeThemes FolderGetSize(SourcePath + "Themes\")
;
;
; Solution source:
; https://stackoverflow.com/questions/36742636/inno-setup-recurse-sub-directories-without-creating-those-same-sub-directories
;

#dim FW_Array[65536]
#define FW_Array[0] ""

#sub ProcessFoundFile
    #define InnerFileName FindGetFileName(FW_Handle)
    #define FileName FW_Array[FW_Current] + InnerFileName

    #if InnerFileName != "." && InnerFileName != ".."
        #if DirExists(FileName)
            #define Public FW_Array[FW_Size] FileName + "\"
            #define Public FW_Size FW_Size + 1
        #else
            #expr FW_FilesSize = FW_FilesSize + FileSize(FileName)
        #endif
    #endif
#endsub

#sub ProcessFolders
    #for { FW_Handle = FW_Result = FindFirst(FW_Array[FW_Current] + "*", faAnyFile); FW_Result; FW_Result = FindNext(FW_Handle) } ProcessFoundFile

    #if FW_Handle
        #expr FindClose(FW_Handle)
    #endif
#endsub

#sub FolderWalker
    #if DirExists(FW_Array[0]) == 0
        #pragma message "Folder not found: """ + FW_Array[0] + """"
        #pragma error "Folder not found"
    #endif

    #undef Public FW_FilesSize
    #define Public FW_FilesSize 0

    #define Public FW_Handle
    #define Public FW_Result
    #define Public FW_Size 1
    #define Public FW_Current 0

    #for { FW_Current = 0; FW_Current < FW_Size; FW_Current++ } ProcessFolders

    #undef Public FW_Handle
    #undef Public FW_Result
    #undef Public FW_Size
    #undef Public FW_Current
#endsub

#define FolderGetSize(str S) FW_Array[0] = AddBackslash(S), FolderWalker, FW_FilesSize