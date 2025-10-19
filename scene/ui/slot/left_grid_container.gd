extends GridContainer

@onready var description_label = $Description  # 物品描述面板（可选）


func _ready():
	# 1. 所有槽位初始设为暗态
	for slot in get_children():
		if slot.has_method("set_state"):
			slot.set_state(false)
	
	# 2. 初始化第4行（索引3）的第3、4、5列（索引2、3、4）为亮态（初始可放置区）
	set_slot_state(3, 2, true)
	set_slot_state(3, 3, true)
	set_slot_state(3, 4, true)


# 设置指定行列槽位的亮暗状态
func set_slot_state(row: int, col: int, is_light: bool):
	var slot_idx = row * columns + col  # 计算槽位索引
	# 边界检查
	if slot_idx >= 0 and slot_idx < get_child_count():
		var target_slot = get_child(slot_idx)
		if target_slot and target_slot.has_method("set_state"):
			target_slot.set_state(is_light)
