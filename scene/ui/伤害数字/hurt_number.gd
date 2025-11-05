extends Node2D

@onready var label: Label = $Label

# 动画参数
const FLOAT_DISTANCE: float = 60.0 # 向上浮动的总距离
const DURATION: float = 0.8        # 动画持续时间

# 公开函数：由外部调用来设置伤害值并开始动画
func setup_and_play(damage_amount: int, is_crit: bool = false):
	# 动态创建 Tween 实例
	# 这样可以确保 damage_tween 是正确的 Tween 类型，而不是 Node 类型
	var damage_tween: Tween = create_tween()
	
	# 1. 设置文本内容和样式
	var text_color = Color.WHITE
	
	if is_crit:
		# 暴击效果：更醒目的颜色和更大的字体
		text_color = Color("#FFFF00") # 亮黄色
		label.add_theme_font_size_override("font_size", 32)
		label.text = str(damage_amount) + "!!"
	else:
		# 普通伤害
		label.add_theme_font_size_override("font_size", 24)
		label.text = str(damage_amount)
		
	label.modulate = text_color # 设置颜色

	# 2. 计算动画目标位置
	var end_position = position - Vector2(0, FLOAT_DISTANCE)
	
	# 3. 配置 Tween 动画

	# --- 动画 A: 向上移动 (上浮) ---
	damage_tween.set_trans(Tween.TRANS_QUAD)
	damage_tween.set_ease(Tween.EASE_OUT)
	damage_tween.tween_property(self, "position", end_position, DURATION)
	
	# --- 动画 B: 渐隐 (透明度变化) ---
	damage_tween.set_parallel(true)
	
	damage_tween.set_trans(Tween.TRANS_SINE)
	damage_tween.set_ease(Tween.EASE_IN)
	damage_tween.tween_property(label, "modulate:a", 0.0, DURATION)
	
	# 4. 动画结束后自动清理
	await damage_tween.finished

	queue_free()
