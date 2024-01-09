Create() {
    action_map := Map(
        "Project | 新建一个项目文件夹", CreateProject,
        "Resource | 新建一个资源文件夹", CreateResource,
        "Excel | 新建一个Excel文件(.xlsx)", CreateNewFile,
        "Word | 新建一个Word文件(.docx)", CreateNewFile,
        "PPT | 新建一个PPT文件(.ppt)", CreateNewFile,
        "Markdown | 新建一个卡片笔记(.md)", CreateNewFile,
    )

    options := MapToList(action_map)

    selected := Dmenu(options, "What to Create?")

    ToolTip(selected)
}

CreateProject() {

}

CreateResource() {

}

CreateNewFile() {

}
