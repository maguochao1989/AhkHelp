﻿;说明
;  效率工具，使用鼠标滚轮执行窗口切换、窗口标签切换、页面翻页、文件选择、窗口缩放动作
;备注
;  使用快捷键切换虚拟桌面会有动画效果, 如果要消除动画效果, 查看"C:\path\AHK\ahkLearn\wait\win-10-virtual-desktop-enhancer-bjc\a.ahk"
;  窗口标题栏的尺寸信息时通过WinSpy获取
;  当前使用的屏幕分辨率是2560x1440
;external
;  date       2019-08-12 14:55:48
;  face       -_-#
;  weather    Shanghai Overcast 35℃
;TODO
;  数值300等数值转为百分率，防止在不同分辨率下数值不一样
;  不管在哪个界面，右下角都可以音量调节
;========================= 环境配置 =========================
#NoEnv
#Persistent
#SingleInstance, Force
#HotkeyInterval 1000
#Include <PRINT>
CoordMode, Mouse, Screen
SetBatchLines, 10ms
SetKeyDelay, -1
; global BrightnessIniPath :=  A_ScriptDir "\resources\Brightness.ini"
; _BrightnessInit()


; 滚轮触发方法
WheelUp::           _WheelAction(true)
WheelDown::         _WheelAction(false)

; win 按键 + 滚轮触发 切换虚拟桌面
; LWin & WheelUp::    ShiftAltTab
; LWin & WheelDown::  AltTab
; #1::^#left
; #2::^#right

; Re - override system shortcuts to add toggle desktop icon support
; 重新覆盖系统的快捷键 添加切换桌面图标支持
^#left::_CommonVirtualDesktopAction(true)
^#right::_CommonVirtualDesktopAction(false)
#1::_CommonVirtualDesktopAction(true)
#2::_CommonVirtualDesktopAction(false)
LWin & WheelUp::_CommonVirtualDesktopAction(true)
LWin & WheelDown::_CommonVirtualDesktopAction(false)
; LWin & WheelUp::     ^#left
; LWin & WheelDown::   ^#right

; ctrl + 滚轮 调整窗口大小
^+WheelUp::         _ReSizeWin(true)
^+WheelDown::       _ReSizeWin(false)
;========================= 环境配置 =========================




;========================= 滚轮触发方法 =========================
_WheelAction(flag) {
    MouseGetPos, posX, posY, id
    WinGet, processName, ProcessName, ahk_id %id%
    WinGetClass, className, ahk_id %id%
    WinGetPos, winX, winY, winWidth, winHeight, ahk_id %id%
    relativeX := posX-winX, relativeY := posY-winY
    ;print(processName "|posX" posX "|posY" posY "----winX" winX  "|winY" winY  "|winWidth" winWidth  "|----relativeX"  relativeX "|relativeY" relativeY)
    
    ; 音量
    ;屏幕右下角[200,200]
    if (_IsHoverScreenParticularRect(posX, posY, A_ScreenWidth-200, A_ScreenHeight-200, A_ScreenWidth, A_ScreenHeight)) { 
        return _CommonVolumeAction(flag)
    }  
    ; 屏幕亮度
    ;屏幕左下角[200,200]
    ;else if (_IsHoverScreenParticularRect(posX, posY, 0, A_ScreenHeight-200, 200, A_ScreenHeight)) {
    ;    return _BrightnessAdjust(flag) 
    ;} 
    else if (processName == "explorer.exe" || processName == "Explorer.EXE") {
        if (className == "Shell_TrayWnd") { ;任务栏
            _CommonVirtualDesktopAction(flag) ;切换虚拟桌面
        } 
    }else if (_IsHoverWinTitleBar(relativeX, relativeY, winWidth, 80)){
        if (processName == "Code.exe"){ ;; vsCode的切换标签快捷键不通用 
            return _CommonPGTabAction(flag) 
        }
        _CommonTabAction(flag)
    }
    
    if (flag)
        SendInput, {WheelUp}
    else
        SendInput, {WheelDown}
}

_ReSizeWin(flag) {
    resizeVal := 60
    MouseGetPos, posX, posY, id
    WinGetPos, , , width, height, ahk_id %id%
    if (flag)
        width :=width+resizeVal, height := height+resizeVal    
    else
        width :=width-resizeVal, height := height-resizeVal
    WinMove, ahk_id %id%,,,,%width%, %height%
}
;========================= 业务逻辑 =========================








;========================= 公共函数 =========================
_IsHoverScreenParticularRect(posX, posY, minX, minY, maxX, maxY) {
    return (posX>=minX && posX<=maxX && posY>=minY && posY<=maxY)
}
_IsHoverWinTitleBar(relativeX, relativeY, barWidth, barHeight) {
    return (relativeX>=0 && relativeX<=barWidth && relativeY>=0 && relativeY<=barHeight)
}
_IsHoverWinParticularRect(relativeX, relativeY, minX, maxX, minY, maxY) {
    return (relativeX>=minX && relativeX<=maxX && relativeY>=minY && relativeY<=maxY)
}
; Universal switch TAB;CTRL + TAB/CTRL + shift + TAB
; 通用的切换标签 ;ctrl + tab / ctrl + shift + tab
_CommonTabAction(flag) {
    print(flag)
    if (flag)
        SendInput, ^+{tab}
    else
        SendInput, ^{tab}
}
; Need Ctrl + PgUp/Ctrl + PgDn toggle label
; 需要 Ctrl + PgUp / Ctrl + PgDn 切换标签
_CommonPGTabAction(flag) {
    if (flag)
        SendInput, ^{PgUp}
    else
        SendInput, ^{PgDn}
}
_CommonScrollbarAction(flag) {
    if (flag)
        SendInput, {PgUp}
    else
        SendInput, {PgDn}
}
_CommonVolumeAction(flag) {
    if (flag)
        SendInput, {Volume_Up 5}
    else
        SendInput, {Volume_Down 5}
}
_CommonMusicAction(flag) {
    if (flag)
        SendInput, ^{Left}
    else
        SendInput, ^{Right}
}
_CommonHorizontalDirectionAction(flag) {
    if (flag)
        SendInput, {Left}
    else
        SendInput, {Right}
}
_CommonVerticalDirectionAction(flag) {
    if (flag)
        SendInput, {Up}
    else
        SendInput, {Down}
}
;Currently only supports 2 virtual desktops
;目前只支持 2 个虚拟桌面
_CommonVirtualDesktopAction(flag) {
    if (flag){
        SendInput, #^{Left}     ;Win+Ctrl+左
        Menu, TRAY, Icon,  ico/d1.ico
        return
    }
    else{
        SendInput, #^{Right}	;Win+Ctrl+右
        Menu, TRAY, Icon,  ico/d2.ico
        return
    }
}




_BrightnessInit() {
    global BrightnessProgress, BrightnessProgressText
    Gui, -caption +alwaysontop +owner +HwndBrightnessGuiId 	;去标题栏
    Gui, Margin, 0, 0 					                    ;去边距
    Gui, Color, 3F3F3F 					                    ;随便设置一个背景色,以备后面设置透明用
    Gui, Font, cWhite s8, Arial  
    Gui, Add, Text, vBrightnessProgressText x6 y154 w20
    Gui, Add, progress, x5 y5 w15 h145 background3F3F3F Vertical vBrightnessProgress, %brightness%
    WinSet, TransColor, black 180, BrightnessGui
}
_BrightnessAdjust(flag) {
    ddm := "C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe"
	IniRead, brightness, %BrightnessIniPath%, Settings, brightness, 30
    brightness := (flag ? brightness+5 : brightness-5)
	if (brightness > 100)  
		brightness := 100  
	else if (brightness < 0)  
		brightness := 0
    
	GuiControl, , BrightnessProgress, %brightness%
	GuiControl, , BrightnessProgressText, %brightness%
	Gui, Show
	RunWait, %ddm% SetBrightnessLevel %brightness%
	IniWrite, %brightness%, %BrightnessIniPath%, Settings, brightness
	SetTimer, _BrightnessGuiAnimate, 400
}
_BrightnessGuiColor() {
    color1 := "6BD536", color2 := "FFFFFF", color3 := "94632D", color4 := "FFCD00", color5 := "AA55AA", color6 := "FF5555"
    Random, randomColor, 1, 6
    return color%randomColor%
}
_BrightnessGuiAnimate:
	ROLL_LEFT_TO_RIGHT_IN = 0x20001 ;自左滚动向右显示 →
	ROLL_RIGHT_TO_LEFT_IN = 0x20002 ;自右滚动向左显示 ←
	ROLL_TOP_TO_BOTTOM_IN = 0x20004 ;自上滚动向下显示 ↓
	ROLL_BOTTOM_TO_TOP_IN = 0x20008 ;自下滚动向上显示 ↑
	ROLL_DIAG_TL_TO_BR_IN = 0x20005 ;从左上角滚动到右下角显示 ↓→
	ROLL_DIAG_TR_TO_BL_IN = 0x20006 ;从右上角滚动到左下角显示 ←↓
	ROLL_DIAG_BL_TO_TR_IN = 0x20009 ;从左下角滚动到右上角显示 ↑→
	ROLL_DIAG_BR_TO_TL_IN = 0x2000a ;从右下角滚动到左上角显示 ←↑
	; =============================================================
	ROLL_LEFT_TO_RIGHT_OUT = 0x30001 ;自左滚动向右退出 →
	ROLL_RIGHT_TO_LEFT_OUT = 0x30002 ;自右滚动向左退出 ←
	ROLL_TOP_TO_BOTTOM_OUT = 0x30004 ;自上滚动向下退出 ↓
	ROLL_BOTTOM_TO_TOP_OUT = 0x30008 ;自下滚动向上退出 ↑
	ROLL_DIAG_TL_TO_BR_OUT = 0x30005 ;从左上角滚动到右下角退出 ↓→
	ROLL_DIAG_TR_TO_BL_OUT = 0x30006 ;从右上角滚动到左下角退出 ←↓
	ROLL_DIAG_BL_TO_TR_OUT = 0x30009 ;从左下角滚动到右上角退出 ↑→
	ROLL_DIAG_BR_TO_TL_OUT = 0x3000a ;从右下角滚动到左上角退出 ←↑
	; =============================================================
	SLIDE_LEFT_TO_RIGHT_IN = 0x40001 ;自左滑动向右显示 →
	SLIDE_RIGHT_TO_LEFT_IN = 0x40002 ;自右滑动向左显示 ←
	SLIDE_TOP_TO_BOTTOM_IN= 0x40004  ;自上滑动向下显示 ↓
	SLIDE_BOTTOM_TO_TOP_IN= 0x40008  ;自下滑动向上显示 ↑
	SLIDE_DIAG_TL_TO_BR_IN = 0x40005 ;从左上角滑动到右下角显示 ↓→
	SLIDE_DIAG_TR_TO_BL_IN = 0x40006 ;从右上角滑动到左下角显示 ←↓
	SLIDE_DIAG_BL_TO_TR_IN = 0x40009 ;从左下角滑动到右上角显示 ↑→
	SLIDE_DIAG_BR_TO_TL_IN = 0x40010 ;从右下角滑动到左上角显示 ←↑
	; =============================================================
	SLIDE_LEFT_TO_RIGHT_OUT = 0x50001 ;自左滑动向右退出 →
	SLIDE_RIGHT_TO_LEFT_OUT = 0x50002 ;自右滑动向左退出 ←
	SLIDE_TOP_TO_BOTTOM_OUT = 0x50004 ;自上滑动向下退出 ↓
	SLIDE_BOTTOM_TO_TOP_OUT = 0x50008 ;自下滑动向上退出 ↑
	SLIDE_DIAG_TL_TO_BR_OUT = 0x50005 ;从左上角滑动到右下角退出 ↓→
	SLIDE_DIAG_TR_TO_BL_OUT = 0x50006 ;从右上角滑动到左下角退出 ←↓
	SLIDE_DIAG_BL_TO_TR_OUT = 0x50009 ;从左下角滑动到右上角退出 ↑→
	SLIDE_DIAG_BR_TO_TL_OUT = 0x50010 ;从右下角滑动到左上角退出 ←↑
	; =============================================================
	ZOOM_IN = 0x16      ;放大进入
	ZOOM_OUT = 0x10010  ;缩小退出
	FADE_IN = 0xa0000   ;淡化进入
	FADE_OUT = 0x90000  ;淡化退出
	;注意：以上效果分为窗口显示和窗口退出的两类，使用时请加以区分
	DllCall("AnimateWindow", "UInt", BrightnessGuiId, "Int", 400, "UInt", FADE_OUT)  ;以淡出的方式退出
	SetTimer, _BrightnessGuiAnimate, off
    guiColor := _BrightnessGuiColor()
    GuiControl, +c%guiColor%, BrightnessProgress
return
;========================= 公共函数 =========================