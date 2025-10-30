extends GridContainer

@onready var description_label = $Description  # 物品描述面板（可选）

# 定义永远保持亮态的槽位坐标（行索引3，列索引2、3、4）
const PERMANENT_LIGHT_SLOTS = [
	[3, 2],
	[3, 3],
	[3, 4]
]


func _ready():
	# 1. 所有槽位初始设为暗态
	for slot in get_children():
		if slot.has_method("set_state"):
			slot.set_state(false)
	
	# 2. 初始化永久亮槽位（即使上面循环设为暗，这里也会强制设亮）
	for slot_coord in PERMANENT_LIGHT_SLOTS:
		set_slot_state(slot_coord[0], slot_coord[1], true)


# 设置指定行列槽位的亮暗状态（永久亮槽位强制锁定为true）
func set_slot_state(row: int, col: int, is_light: bool):
	# 关键逻辑：检查当前槽位是否在永久亮列表中，是则强制设为亮
	for light_coord in PERMANENT_LIGHT_SLOTS:
		if light_coord[0] == row and light_coord[1] == col:
			is_light = true  # 无视外部传入的状态，强制亮
			break  # 匹配到后无需继续循环
	
	# 原有计算索引和设置状态的逻辑
	var slot_idx = row * columns + col  # 计算槽位索引
	# 边界检查
	if slot_idx >= 0 and slot_idx < get_child_count():
		var target_slot = get_child(slot_idx)
		if target_slot and target_slot.has_method("set_state"):
			target_slot.set_state(is_light)
