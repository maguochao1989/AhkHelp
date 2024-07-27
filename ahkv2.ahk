#Requires AutoHotkey v2.0
; shift alt j发送媒体按键 播放 暂停
+!j::_Media_Play_Pause()
_Media_Play_Pause(){
  Send "{Media_Play_Pause}"
}