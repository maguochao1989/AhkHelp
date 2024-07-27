#Include <common>
#Include <PRINT>

#Persistent
SetTimer, CloseMailWarnings, 6000 ;;; 秒钟 
return

CloseMailWarnings:
    _CommonGet()
    ;print( "oldPosX: " oldPosX " oldPosY: " oldPosY " forbidSleepCount:" forbidSleepCount)
    if(posX != oldPosX && posY != oldPosY){
        forbidSleepCount = 0
        oldPosX := posX, oldPosY := posY
    }Else
        forbidSleepCount ++ 

    if( forbidSleepCount >= 40 ){ ;; 移动鼠标;; 10 * 4 * 6000 ;; 4分钟
        print("move mouse")
        MouseMove, 0, 0, 0 ;
        MouseMove, posX, posY, 0 ;
        forbidSleepCount = 0
    }
return