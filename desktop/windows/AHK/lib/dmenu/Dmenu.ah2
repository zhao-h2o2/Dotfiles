#include FuzzySearch.ah2

class Dmenu {
    ; 初始化gui
    __New(options, placeholder := "Hi, Zhaohui!") {
        ; 创建gui
        this.gui := Gui("Owner AlwaysOnTop -Resize -Caption", "Starter")
        this.gui.BackColor := "FFFFFF"
        this.gui.SetFont("s20 q5 c333333", "NSimSun")
        this.gui.SetFont(, "霞鹜尚智黑")    ;优先使用更好看的字体
        this.gui.MarginY := 10

        ; 初始化搜索框
        this.edit := this.gui.AddEdit("x10 y10 h30 w495 -E0x200")
        this.edit.OnEvent("ContextMenu", (*) => 0)
        search(edit, info) {    ;防抖
            static f := (*) => this.searchText := this.edit.Value
            SetTimer(f, 0)
            SetTimer(f, -50)
        }
        this.edit.OnEvent("Change", search)    ; 文本变动事件
        this.placeholder := placeholder
        this.gui.AddPicture("x510 y10 w30 h30", "hBitmap:*" LoadPicture("Starter.ico", "w64"))

        ; 初始化搜索结果
        this.listView := this.gui.Add("ListView", "x10 y50 w560 r7 -Multi -hdr -E0x200 Count" 3, [""])
        this.listView.SetFont("s14 w700 c444444")
        this.options := options
        this.searchResults := options
        this.resetList(this.searchResults)

        ; 热键设置
        this.hotkeyInit()
    }

    ;#region 设置搜索框占位符
    static _placeholder := ""
    static placeholder {
        get => this._placeholder
        set {
            if (this._placeholder != Value) {
                this._placeholder := Value
                DllCall("User32.dll\SendMessageW", "Ptr", this.edit.Hwnd, "Uint", (0x1500 + 1), "Ptr", True, "WStr", Value)
            }
        }
    }
    ;#endregion

    ;#region 搜索内容
    static _searchText := ""
    static searchText {
        get => this._searchText
        set {
            this._searchText := Value
            if (Value == "") {
                this.searchResults := this.options
            }
            else if (this.options.Length > 0) {
                this.searchResults := FuzzySearch(this.options, Value)
            }
            this.resetList(this.searchResults)
        }
    }
    ;#endregion

    ; 搜索结果列表
    static rowHeight := 0

    ;重置listView和gui高度
    static resizeGui() {
        len := this.searchResults.Length
        if (len && this.rowHeight == 0) {
            LV_XYstruct := Buffer(16, 0)
            SendMessage(0x1038, 1, LV_XYstruct.Ptr, , this.listView)
            if (rowH := NumGet(LV_XYstruct, 12, "UInt") - NumGet(LV_XYstruct, 4, "UInt"))
                this.rowHeight := rowH
        }

        if (!this.rowHeight)
            LVHeight := len * Ceil(26.4 * (A_ScreenDPI / 96))
        else
            LVHeight := len > 0 ? Ceil((len >= 10 ? 10 : len) * this.rowHeight) : 0
        ControlMove(, , , LVHeight, this.listView) ; 使用ControlMove避免DPI 缩放
        this.listView.ModifyCol(1, "530")
        this.focusedRow := 1    ;聚焦第一行
        this.listView.Opt("Redraw")
        WinMove(, , 550 * (A_ScreenDPI / 96), LVHeight + Ceil(55 * (A_ScreenDPI / 96)), this.gui)
    }

    ;#region 重设list内容
    static resetList(results) {
        ;重置列表
        this.listView.Opt("-Redraw")    ;禁用重绘
        this.listView.Delete()
        if (results.Length > 0){
            for item in results {
                this.listView.Add("", item)
            }
        }
        this.resizeGui()
    }
    ;#endregion

    ;#region 聚焦行
    static focusedRow
    {
        get => this.listView.GetNext()
        set {
            if (this.searchResults.Length) { ; 有内容才可修改
                if (Value > this.searchResults.Length)
                    Value := 1
                else if (Value == 0)
                    Value := this.searchResults.Length
                this.listView.Modify(Value, "Select Focus Vis")
            }
        }
    }
    ;#endregion

    ;#region 热键设置
    static hotkeyInit()
    {
        HotIfWinActive("ahk_id " this.gui.Hwnd)
        Hotkey("Up", key => this.focusedRow--)
        Hotkey("Down", key => this.focusedRow++)
        Hotkey("Enter", key => this.confirmHandler())
        ; 鼠标双击运行
        this.listView.OnEvent("DoubleClick", (_lv, rowNum) => this.confirmHandler(rowNum))
        HotIf()
    }
    ;#endregion

    ;#region 确认功能
    static confirmHandler(rowNum?)
    {
        if (!IsSet(rowNum))
            if (this.searchResults.Length > 0)
                A_Clipboard := this.searchResults[this.focusedRow]
            else
                A_Clipboard := this.searchText
        else
            A_Clipboard := this.searchResults[rowNum]
        this.gui.Destroy()
    }
    ;#endregion

    ;#region 等待结果
    static run(timeout := 120)
    {
        ; 显示界面
        this.gui.Show("w550 y" Ceil(A_ScreenHeight / 5))
        clipboard_saved := A_Clipboard
        A_Clipboard := ""
        if ClipWait(timeout) {
            result := A_Clipboard
        } else {
            result := false
        }
        A_Clipboard := clipboard_saved
        return result
    }
    ;#endregion
}

options := ["a","b","c","d","e","f","g","h","i"]
dmenu := Dmenu(options).run()