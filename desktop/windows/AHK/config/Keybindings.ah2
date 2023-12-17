/*
╔══════════════════════════════════════════════════
║                     系统功能
╚══════════════════════════════════════════════════
*/
; 锁屏+熄屏
#l::{
    SystemLockScreen()
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

