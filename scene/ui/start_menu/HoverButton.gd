extends Button

# 存储按钮的原始文本（如“开始”）
var original_text: String

func _ready():
	# 记录原始文本
	original_text = text
	# Godot 4的信号连接方式：用方法名（不加引号）
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("pressed", _on_button_pressed)

# 鼠标悬停时：文本前后加尖括号（如“<开始>”）
func _on_mouse_entered():
	# 仅当当前文本是原始文本时才修改（避免重复添加）
	if text == original_text:
		text = "<    " + original_text + "    >"

# 鼠标离开时：恢复原始文本（若未被点击选中）
func _on_mouse_exited():
	# 仅当文本是“<原始文本>”时才恢复
	if text == "<    " + original_text + "    >":
		text = original_text

# 点击按钮时：保持尖括号样式
func _on_button_pressed():
	text = "<    " + original_text + "    >"
