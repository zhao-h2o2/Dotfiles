/**
* 锁屏
*/
SystemLockScreen() {
    Sleep 300
    DllCall("LockWorkStation")
}
  
/**
* 关机
*/
SystemShutdown() {
    Run("SlideToShutDown.exe")
}

/**
* 重启
*/
SystemReboot() {
    Shutdown(2)
}

/**
* 睡眠
*/
SystemSleep() {
    DllCall("PowrProf\SetSuspendState")
}

/**
* 熄屏
*/
SystemCloseScreen() {
    SendMessage(0x0112, 0xF170, 2,, "Program Manager")
}

/**
* 重启资源管理器
*/
SystemRestartExplorer() {
    Run("tools\Rexplorer_x64.exe /I /R")
}
  