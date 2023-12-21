/*
╔══════════════════════════════════════════════════
║                     系统功能
╚══════════════════════════════════════════════════
*/
; 锁屏+熄屏
#l::{
    SystemLockScreen()
    Sleep 300
    SystemCloseScreen()
}
; 锁屏+睡眠
#+l::{
    SystemLockScreen()
    SystemSleep()
}
; 关机
#Esc::SystemShutdown()
; 重启
#+Esc::SystemReboot()


/*
╔══════════════════════════════════════════════════
║                      AHK
╚══════════════════════════════════════════════════
*/
; 重载配置
#+r::Reload()
; 退出脚本
#+q::ExitApp()


/*
╔══════════════════════════════════════════════════
║                      应用
╚══════════════════════════════════════════════════
*/
; 关闭应用 (alt+f4)
#q::Send("!{F4}")
; 浏览器
BROSWER := Application("C:\Users\zhao\AppData\Local\Thorium\Application\thorium.exe", "ahk_exe thorium.exe", true)
#b::BROSWER.ActivateOrRun()
; Everything
EVERYTHING := Application("C:\Program Files\Everything\Everything.exe", "ahk_exe Everything.exe", true)
#f::EVERYTHING.ActivateOrRun()
; 编辑器
EDITER := Application("Code.exe", "ahk_exe Code.exe", true)
#c::EDITER.ActivateOrRun()
; 文件管理器
FILEBROWSER := Application("C:\Users\zhao\AppData\Local\TotalCMD64\TotalCMD64.exe", "ahk_exe TotalCMD64.exe", true)
#e::FILEBROWSER.ActivateOrRun()

