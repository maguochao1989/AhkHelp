;说明
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
; https://www.autohotkey.com/docs/Hotkeys.htm 
; https://wyagd001.github.io/zh-cn/docs/KeyList.htm
; https://wyagd001.github.io/zh-cn/docs/commands/Gui.htm
; ! alt ; ^ ctrl ; # win ; ~ esc ; RButton mouse RB ;  +    Shift
;  环境配置 
#NoEnv
#Persistent
#SingleInstance, Force
; #HotkeyInterval 1000
#MaxHotkeysPerInterval 999900
#Include <PRINT>
#Include <common>
CoordMode, Mouse, Screen
SetBatchLines, 10ms
SetKeyDelay, -1


; 发送媒体按键 播放 暂停
+!j:: _playandpause()
_playandpause(){
  Send "{Media_Play_Pause}"
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; example
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; counter := new SecondCounter
; counter.Start()
; Sleep 5000
; ;counter.Stop()
; Sleep 2000

; ; An example class for counting the seconds...
; class SecondCounter {
;     __New() {
;         this.interval := 1000
;         this.count := 0
;         ; Tick() has an implicit parameter "this" which is a reference to
;         ; the object, so we need to create a function which encapsulates
;         ; "this" and the method to call:
;         this.timer := ObjBindMethod(this, "Tick")
;     }
;     Start() {
;         ; Known limitation: SetTimer requires a plain variable reference.
;         timer := this.timer
;         SetTimer % timer, % this.interval
;         ToolTip % "Counter started"
;     }
;     Stop() {
;         ; To turn off the timer, we must pass the same object as before:
;         timer := this.timer
;         SetTimer % timer, Off
;         ToolTip % "Counter stopped at " this.count
;     }
;     ; In this example, the timer calls this method:
;     Tick() {
;         ToolTip % ++this.count
;     }
; }




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  一键锁屏并让屏幕关闭，节约用电
;; 
;; Win + L: 锁屏并关闭屏幕
;;
;; gaochao.morgen@gmail.com
;; 2014/2/4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; https://www.autoahk.com/archives/18637
; #L:: _LockWindow() return
; _LockWindow(){
;     InputBox, UserInput, Phone Number, Please enter a phone number., , 640, 480
;     if ErrorLevel
;         MsgBox, CANCEL was pressed.
;     else
;         MsgBox, You entered "%UserInput%"
;    return
; }
; Win + L
; #l::
	; Lock Screen. 模拟Win+L没有成功，执行后Win似乎一直处于按下状态
	; Run, %A_WinDir%System32rundll32.exe user32.dll LockWorkStation 

	; Sleep, 500

	; Power off the screen
	; 0x112: WM_SYSCOMMAND
	; 0xF170: SC_MONITORPOWER
	; 2: the display is being shut off
	; SendMessage, 0x112, 0xF170, 2,, Program Manager
; Return





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 定时执行不让电脑黑屏
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Persistent
SetTimer, ForbidDeltaCloseWindow, 5000  ;;; 1000 = 1秒钟 
return

ForbidDeltaCloseWindow:
    _CommonGet()
    ; print( "oldPosX: " oldPosX " oldPosY: " oldPosY " forbidSleepCount:" forbidSleepCount)

    if(posX != oldPosX && posY != oldPosY){
        forbidSleepCount = 0
        oldPosX := posX, oldPosY := posY
    }Else
        forbidSleepCount ++ 


    if( forbidSleepCount >= 4 ){ ;; 移动鼠标;; 10 * 4 * 6000 ;; 4分钟
        ; print("move mouse")
        MouseMove, posX + 15, posY + 15, 0 ;
        MouseMove, oldPosX, oldPosY, 0 ;
        forbidSleepCount = 0
    }
return


















; global BrightnessIniPath :=  A_ScriptDir "\resources\Brightness.ini"
; _BrightnessInit()


;MouseMove, 50 , 0 , 10 , r return 


; win 按键 + 滚轮触发 切换虚拟桌面
; LWin & WheelUp::    ShiftAltTab
; LWin & WheelDown::  AltTab
; #1::^#left
; #2::^#right

; Re - override system shortcuts to add toggle desktop icon support
; 重新覆盖系统的快捷键 添加切换桌面图标支持
^#left::_CommonVirtualDesktopAction(true)
^#right::_CommonVirtualDesktopAction(false)

; Win + 1/2 switch to virtual desktop
; win + 1 / 2 切换虚拟桌面
;#1::_CommonVirtualDesktopAction(true)
;#2::_CommonVirtualDesktopAction(false)
LWin & WheelUp::_CommonVirtualDesktopAction(true)
LWin & WheelDown::_CommonVirtualDesktopAction(false)
; LWin & WheelUp::     ^#left
; LWin & WheelDown::   ^#right

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Ctrl + shift + 滚轮 调整窗口大小
;; Change window size 更改窗口大小 
;; 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ^+WheelUp::         _ReSizeWin(true)
; ^+WheelDown::       _ReSizeWin(false)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 退出 QQ 识别文字后的弹窗 alt w
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; !C:: ^+C
; !V:: ^+V
; !C:: _ExitButton()
; _ExitButton(){
;     if WinExist("屏幕识图"){
;         ;print("if")
;         WinClose
;         return 
;     } 
; }




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 一键锁屏并让屏幕关闭，节约用电
; 
; Win + L: 锁屏并关闭屏幕
;
; gaochao.morgen@gmail.com
; 2014/2/4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; #SingleInstance Force
; #NoTrayIcon
; #NoEnv

; ; Win + L
; #l::
;   ; Lock Screen. 模拟Win+L没有成功，执行后Win似乎一直处于按下状态
;   forbidSleepSum = 1
;   ;Run, %A_WinDir%System32rundll32.exe ; user32.dll LockWorkStation 

; ;   Sleep, 500

;   ; Power off the screen
;   ; 0x112: WM_SYSCOMMAND
;   ; 0xF170: SC_MONITORPOWER
;   ; 2: the display is being shut off
; ;   SendMessage, 0x112, 0xF170, 2,, Program Manager
; Return




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Chrome play
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+!Space:: _PauseChromePaly()
_PauseChromePaly(){
    _CommonGet()
    MouseMove, 700, 1600, 0 ;, R      ;DllCall("SetCursorPos", "int", 1200, "int", 2080)  ;
    Click
    MouseMove, posX, posY, 0 ;, R
    if (processName != "chrome.exe"){
        Click
        SendInput , {Esc} ;;;如果在idea alt+shift+click 会多处光标 , 发送esc 退出多处光标
    }
}
+!J::_SubChromePlay() ;; 播放 --
_SubChromePlay(){
    _CommonGet()
    MouseMove, 700, 1600,0 
    Click
    Send z
    MouseMove, posX, posY, 0 ;, R
}
+!K::_PlusChromePlay() ;; 播放 ++
_PlusChromePlay(){
    _CommonGet()
    MouseMove, 700, 1600,0 
    Click
    Send x
    MouseMove, posX, posY, 0 ;, R
}






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Scroll trigger method
;; 滚轮触发方法
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WheelUp::           _WheelAction(true)
WheelDown::         _WheelAction(false)
_WheelAction(flag) {
    _CommonGet()
    
    if (_IsHoverScreenParticularRect(posX, posY, 200 , A_ScreenHeight-30, A_ScreenWidth-200, A_ScreenHeight)){
        _CommonVirtualDesktopAction(flag) ;切换虚拟桌面
    } else if (_IsHoverScreenParticularRect(posX, posY, A_ScreenWidth-200, A_ScreenHeight-30, A_ScreenWidth, A_ScreenHeight)) { 
        return _CommonVolumeAction(flag)  ; 音量 屏幕右下角[200,200]
    }  else if (_IsHoverScreenParticularRect(posX, posY, 0, A_ScreenHeight-30, 200, A_ScreenHeight)) { 
        ; return _CommonVolumeAction(flag)  ;  屏幕左下角[200,200]
    } else if (_IsHoverWinTitleBar(relativeX, relativeY, winWidth, 80)){ ; 在标题栏上
        _SwitchTab(flag) 
    } else if (flag)
        SendInput, {WheelUp}
    else
        SendInput, {WheelDown}
    
    
    ; 屏幕亮度 屏幕左下角[200,200]
    ; else if (_IsHoverScreenParticularRect(posX, posY, 0, A_ScreenHeight-200, 200, A_ScreenHeight)) {
    ;    return _BrightnessAdjust(flag) 
    ; } 
    ; else if (processName == "explorer.exe" || processName == "Explorer.EXE") {
    ;    if (className == "Shell_TrayWnd") { ;任务栏
    ;        _CommonVirtualDesktopAction(flag) ;切换虚拟桌面
    ;    } else { }
}







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Alt + scroll to and from the label
;; Alt + 滚轮 切换标签
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!WheelUp::         _SwitchTab(true)
!WheelDown::       _SwitchTab(false)
+![::              _SwitchTab(true)
+!]::              _SwitchTab(false)
_SwitchTab(flag){
    _CommonGet()
    ; print(processName)
    if (processName == "Code.exe"){ ;; vsCode的切换标签快捷键不通用 
        return _CommonPGTabAction(flag) 
    }else if(processName == "idea.exe" || processName == "idea64.exe" || processName == "sublime_text.exe"){
        if (flag) 
            SendInput, !{left}
        else 
            SendInput, !{right}
    }else if (processName == "explorer.exe" || processName == "Explorer.EXE") { ;;; exporer 切换目录
        if (flag) 
            SendInput !{Up}
        else 
            SendInput {BackSpace}
    }else
        _CommonTabAction(flag)
}
_CommonTabAction(flag) {  ;;; 通用的切换标签 ;ctrl + tab / ctrl + shift + tab; Universal switch TAB;  CTRL + TAB/CTRL + Shift + TAB
    if (flag)
        SendInput, ^+{tab}
    else
        SendInput, ^{tab}
}
_CommonPGTabAction(flag) {  ;;; 需要 Ctrl + PgUp / Ctrl + PgDn 切换标签; Need Ctrl + PgUp/Ctrl + PgDn toggle label
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
        SendInput, {Volume_Up 2}
    else
        SendInput, {Volume_Down 2}
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
;https://tool.lu/favicon/
_CommonVirtualDesktopAction(flag) {
    if (flag){
        SendInput, #^{Left}     ;Win+Ctrl+左
        ;desktopNum:=desktopNum+1
        ;print(desktopNum)
        ; Menu Tray, Icon, HBITMAP:*%handle%
        Menu, TRAY, Icon,  ico\Number_001.ico
        ;Menu, Tray, Icon, Shell32.dll, 174
        ;Menu, Tray, Icon,,, 1
        ;Menu, TRAY, Icon,  ico/d1.ico
        return
    } else {
        SendInput, #^{Right}	;Win+Ctrl+右
        Menu, TRAY, Icon,  ico\Number_002.ico
        return
    }
}




; _BrightnessInit() {
;     global BrightnessProgress, BrightnessProgressText
;     Gui, -caption +alwaysontop +owner +HwndBrightnessGuiId 	;去标题栏
;     Gui, Margin, 0, 0 					                    ;去边距
;     Gui, Color, 3F3F3F 					                    ;随便设置一个背景色,以备后面设置透明用
;     Gui, Font, cWhite s8, Arial  
;     Gui, Add, Text, vBrightnessProgressText x6 y154 w20
;     Gui, Add, progress, x5 y5 w15 h145 background3F3F3F Vertical vBrightnessProgress, %brightness%
;     WinSet, TransColor, black 180, BrightnessGui
; }
; _BrightnessAdjust(flag) {
;     ; ddm := "C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe"
; 	IniRead, brightness, %BrightnessIniPath%, Settings, brightness, 30
;     brightness := (flag ? brightness+5 : brightness-5)
; 	if (brightness > 100)  
; 		brightness := 100  
; 	else if (brightness < 0)  
; 		brightness := 0
    
; 	GuiControl, , BrightnessProgress, %brightness%
; 	GuiControl, , BrightnessProgressText, %brightness%
; 	Gui, Show
; 	; RunWait, %ddm% SetBrightnessLevel %brightness%
; 	IniWrite, %brightness%, %BrightnessIniPath%, Settings, brightness
; 	SetTimer, _BrightnessGuiAnimate, 1000
; }
_BrightnessGuiColor() {
    ; color1 := "6BD536", color2 := "FFFFFF", color3 := "94632D", color4 := "FFCD00", color5 := "AA55AA", color6 := "FF5555"
    ; Random, randomColor, 1, 6
    ; return color%randomColor%
    return color1
}
; _BrightnessGuiAnimate:
; 	ROLL_LEFT_TO_RIGHT_IN = 0x20001 ;自左滚动向右显示 →
; 	ROLL_RIGHT_TO_LEFT_IN = 0x20002 ;自右滚动向左显示 ←
; 	ROLL_TOP_TO_BOTTOM_IN = 0x20004 ;自上滚动向下显示 ↓
; 	ROLL_BOTTOM_TO_TOP_IN = 0x20008 ;自下滚动向上显示 ↑
; 	ROLL_DIAG_TL_TO_BR_IN = 0x20005 ;从左上角滚动到右下角显示 ↓→
; 	ROLL_DIAG_TR_TO_BL_IN = 0x20006 ;从右上角滚动到左下角显示 ←↓
; 	ROLL_DIAG_BL_TO_TR_IN = 0x20009 ;从左下角滚动到右上角显示 ↑→
; 	ROLL_DIAG_BR_TO_TL_IN = 0x2000a ;从右下角滚动到左上角显示 ←↑
    
; 	ROLL_LEFT_TO_RIGHT_OUT = 0x30001 ;自左滚动向右退出 →
; 	ROLL_RIGHT_TO_LEFT_OUT = 0x30002 ;自右滚动向左退出 ←
; 	ROLL_TOP_TO_BOTTOM_OUT = 0x30004 ;自上滚动向下退出 ↓
; 	ROLL_BOTTOM_TO_TOP_OUT = 0x30008 ;自下滚动向上退出 ↑
; 	ROLL_DIAG_TL_TO_BR_OUT = 0x30005 ;从左上角滚动到右下角退出 ↓→
; 	ROLL_DIAG_TR_TO_BL_OUT = 0x30006 ;从右上角滚动到左下角退出 ←↓
; 	ROLL_DIAG_BL_TO_TR_OUT = 0x30009 ;从左下角滚动到右上角退出 ↑→
; 	ROLL_DIAG_BR_TO_TL_OUT = 0x3000a ;从右下角滚动到左上角退出 ←↑
    
; 	SLIDE_LEFT_TO_RIGHT_IN = 0x40001 ;自左滑动向右显示 →
; 	SLIDE_RIGHT_TO_LEFT_IN = 0x40002 ;自右滑动向左显示 ←
; 	SLIDE_TOP_TO_BOTTOM_IN= 0x40004  ;自上滑动向下显示 ↓
; 	SLIDE_BOTTOM_TO_TOP_IN= 0x40008  ;自下滑动向上显示 ↑
; 	SLIDE_DIAG_TL_TO_BR_IN = 0x40005 ;从左上角滑动到右下角显示 ↓→
; 	SLIDE_DIAG_TR_TO_BL_IN = 0x40006 ;从右上角滑动到左下角显示 ←↓
; 	SLIDE_DIAG_BL_TO_TR_IN = 0x40009 ;从左下角滑动到右上角显示 ↑→
; 	SLIDE_DIAG_BR_TO_TL_IN = 0x40010 ;从右下角滑动到左上角显示 ←↑
    
; 	SLIDE_LEFT_TO_RIGHT_OUT = 0x50001 ;自左滑动向右退出 →
; 	SLIDE_RIGHT_TO_LEFT_OUT = 0x50002 ;自右滑动向左退出 ←
; 	SLIDE_TOP_TO_BOTTOM_OUT = 0x50004 ;自上滑动向下退出 ↓
; 	SLIDE_BOTTOM_TO_TOP_OUT = 0x50008 ;自下滑动向上退出 ↑
; 	SLIDE_DIAG_TL_TO_BR_OUT = 0x50005 ;从左上角滑动到右下角退出 ↓→
; 	SLIDE_DIAG_TR_TO_BL_OUT = 0x50006 ;从右上角滑动到左下角退出 ←↓
; 	SLIDE_DIAG_BL_TO_TR_OUT = 0x50009 ;从左下角滑动到右上角退出 ↑→
; 	SLIDE_DIAG_BR_TO_TL_OUT = 0x50010 ;从右下角滑动到左上角退出 ←↑
    
; 	ZOOM_IN = 0x16      ;放大进入
; 	ZOOM_OUT = 0x10010  ;缩小退出
; 	FADE_IN = 0xa0000   ;淡化进入
; 	FADE_OUT = 0x90000  ;淡化退出
; 	;注意：以上效果分为窗口显示和窗口退出的两类，使用时请加以区分
; 	DllCall("AnimateWindow", "UInt", BrightnessGuiId, "Int", 400, "UInt", FADE_OUT)  ;以淡出的方式退出
; 	SetTimer, _BrightnessGuiAnimate, off
;     guiColor := _BrightnessGuiColor()
;     GuiControl, +c%guiColor%, BrightnessProgress
; return

; 公共函数 
_IsHoverScreenParticularRect(posX, posY, minX, minY, maxX, maxY) {
    return (posX>=minX && posX<=maxX && posY>=minY && posY<=maxY)
}
_IsHoverWinTitleBar(relativeX, relativeY, barWidth, barHeight) {
    return (relativeX>=0 && relativeX<=barWidth && relativeY>=0 && relativeY<=barHeight)
}
_IsHoverWinParticularRect(relativeX, relativeY, minX, maxX, minY, maxY) {
    return (relativeX>=minX && relativeX<=maxX && relativeY>=minY && relativeY<=maxY)
}

;; alt LButton 
;!LButton::
;MouseGetPos,KDE_X1,KDE_Y1,KDE_id
;WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
;If KDE_Win
;    return
;; Get the initial window position.
;WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
;Loop
;{
;    GetKeyState,KDE_Button,LButton,P ; Break if button has been released.
;    If KDE_Button = U
;        break
;    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
;    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
;    KDE_Y2 -= KDE_Y1
;    KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
;    KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
;    WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.
;}
;return

!RButton::
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
If KDE_Win
    return
WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
   KDE_WinLeft := 1
Else
   KDE_WinLeft := -1
If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
   KDE_WinUp := 1
Else
   KDE_WinUp := -1
Loop
{
    GetKeyState,KDE_Button,RButton,P ; Break if button has been released.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
    ; Get the current window position and size.
    WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
    KDE_Y2 -= KDE_Y1
    ; Then, act according to the defined region.
    WinMove,ahk_id %KDE_id%,, KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
                            , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
                            , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
                            , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
    KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
    KDE_Y1 := (KDE_Y2 + KDE_Y1)
}
return