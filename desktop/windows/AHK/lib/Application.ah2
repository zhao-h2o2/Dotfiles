/**
 *  将程序路径或参数中的{selected} 替换为选中的文字
 * @param target 程序路径的引用
 * @param args 参数的引用
 * @returns {void|number} 
 */
ReplaceSelectedText(target, args) {
  text := GetSelectedText()
  if not (text) {
    text := ""
  }

  if InStr(args, "://") || InStr(target, "://") {
    text := URIEncode(text)
  }
  args := strReplace(args, "{selected}", text)
  target := strReplace(target, "{selected}", text)

  return 1
}


class Application {
    __New(target, winTitle, isHide := false) {
        this.target := target
        this.winTitle := winTitle
        this.isHide := isHide
    }

    /**
    * 启动程序或切换到程序
    * @param {string} args 参数
    * @param {string} workingDir 工作文件夹
    * @param {bool} admin 是否为管理员启动
    * @param {bool} isHide 窗口是否为隐藏窗口
    * @returns {void} 
    */
    ActivateOrRun(args := "", workingDir := "", admin := false, runInBackground := false) {
      ; 如果是程序或参数中带有“选中的文件” 则通过该程序打开该连接
      if (InStr(this.target, "{selected}") || InStr(args, "{selected}")) {
        ; 没有获取到文字直接返回
        if not (ReplaceSelectedText(this.target, args))
          return
      }

      ; 切换程序
      this.winTitle := Trim(this.winTitle)
      if (this.winTitle && activateWindow(this.winTitle, this.isHide))
        return

      ; 程序没有运行，运行程序
      workingDir := workingDir ? workingDir : A_WorkingDir
      RunPrograms(this.target, args, workingDir, admin, runInBackground)
    }
}