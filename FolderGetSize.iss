; Function FolderGetSize
; version 0.1 
;
; Returns folder size in bytes
;
; Usage:
;
; #include "FolderGetSize.iss"
; #define YOURVARIABLE FolderGetSize(FOLDERPATH)
;
;
; Solution source:
; https://stackoverflow.com/questions/36742636/inno-setup-recurse-sub-directories-without-creating-those-same-sub-directories
;

#define FindHandle
#define FindResult
#dim InnerMask[65536]
#define InnerMask[0] ""

#sub ProcessFoundFile
    #define InnerFileName FindGetFileName(FindHandle)
    #define FileName InnerMask[InnerMaskWorkPosition] + InnerFileName

    #if InnerFileName != "." && InnerFileName != ".."
        #if DirExists(FileName)
            #define Public InnerMask[InnerMaskPosition] FileName + "\"
            #define Public InnerMaskPosition InnerMaskPosition + 1
        #else
            #expr CalculatedSize = CalculatedSize + FileSize(FileName)
        #endif
    #endif
#endsub

#sub ProcessInnerMaskPosition
    #for { FindHandle = FindResult = FindFirst(InnerMask[InnerMaskWorkPosition] + "*", faAnyFile); \
           FindResult; \
           FindResult = FindNext(FindHandle) \
         } \
         ProcessFoundFile

    #if FindHandle
        #expr FindClose(FindHandle)
    #endif
#endsub

#sub CollectFiles
    #if DirExists(InnerMask[0]) == 0
        #pragma message "Folder not found: """ + InnerMask[0] + """"
        #pragma error "Folder not found"
    #endif

    #ifdef CalculatedSize
        #undef CalculatedSize
    #endif

    #define Public CalculatedSize 0
    #if Copy(InnerMask[0], Len(InnerMask[0])) != "\"
        #expr InnerMask[0] = InnerMask[0] + "\"
    #endif

    #define Public InnerMaskPosition 1
    #define Public InnerMaskWorkPosition 0

    #for { InnerMaskWorkPosition = 0; \
           InnerMaskWorkPosition < InnerMaskPosition; \
           InnerMaskWorkPosition++ 
         } \
		 ProcessInnerMaskPosition

    #undef Public InnerMaskPosition
    #undef Public InnerMaskWorkPosition
#endsub

#define FolderGetSize(str S) InnerMask[0] = S, CollectFiles, CalculatedSize