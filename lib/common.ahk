

; Gets some parameters for the mouse form
; 获得鼠标窗体的一些参数
global posX , posY , processName , className , relativeX, relativeY, winWidth , forbidSleepSum := 40
_CommonGet(){
    MouseGetPos, posX, posY, id
    WinGet, processName, ProcessName, ahk_id %id%
    WinGetClass, className, ahk_id %id%
    WinGetPos, winX, winY, winWidth, winHeight, ahk_id %id%
    relativeX := posX-winX, relativeY := posY-winY
    ; print(processName "|posX " posX "|posY " posY "|winX " winX  "|winY " winY  "|winWidth " winWidth  "|relativeX "  relativeX "|relativeY " relativeY)
}