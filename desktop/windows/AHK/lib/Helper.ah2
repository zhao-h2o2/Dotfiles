/**
 * 自动关闭的提示窗口 
 * @param message 要提示的文本
 * @param {number} time 超时后关闭
 */
Tip(message, time := -1500) {
  ToolTip(message)
  SetTimer(() => ToolTip(), time)
}

/**
 * 提取Map对象的所有key，输出到一个List
 * @param map_to_convert 需要转化为List的Map对象
 */
MapToList(map_to_convert) {
  newlist := []
  for key in map_to_convert {
    newlist.push(key)
  }
  return newlist
}
