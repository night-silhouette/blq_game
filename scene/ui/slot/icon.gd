extends TextureRect

# 拖拽状态
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
@onready var parent_slot = get_parent()  # 关联所在容器Slot
@onready var left_grid: GridContainer  # 左侧铭文库GridContainer
@onready var bag_grid: GridContainer  # 右侧背包GridContainer
var item_resource: Item = null  # 存储当前图标对应的Item资源


const PERMANENT_LIGHT_SLOTS = [
	[3, 2],
	[3, 3],
	[3, 4]
]


# 图标-效果映射表（键：图标资源路径，值：效果类型）
var icon_effect_map: Dictionary = {
	"res://asset/image/白色药水.png": "light_right_2",
	"res://asset/image/红色小药水.png": "light_left_2",
	"res://asset/image/蓝色小药水.png":"light_up_2",
	"res://asset/image/紫水晶法杖.png":"light_down_2",
	"res://asset/image/蓝水晶法杖.png":"right_to_side_2",
	"res://asset/image/红色药水.png":"left_to_side_2",
	"res://asset/image/蓝色药水.png":"up_down_2"
}

# 记录当前物品产生的点亮效果
var affected_slots: Array = []


func _ready():
	# 初始化左侧铭文库GridContainer
	var mingwenku_node = get_node_or_null("/root/UI/铭文库")
	if mingwenku_node:
		left_grid = mingwenku_node.get_node_or_null("GridContainer")

	# 初始化右侧背包GridContainer
	var bag_node = get_node_or_null("/root/UI/铭文库/背包")
	if bag_node:
		bag_grid = bag_node.get_node_or_null("GridContainer")


# 输入事件处理（拖拽逻辑）
func _input(event: InputEvent):
	# 忽略空物品
	if not texture:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# 点击图标开始拖拽
			if get_global_rect().has_point(event.global_position):
				is_dragging = true
				drag_offset = event.global_position - global_position
				z_index = 100  # 拖拽时置顶
		else:
			# 释放鼠标结束拖拽
			if is_dragging:
				is_dragging = false
				z_index = 0
				# 判断物品来源，限制操作范围
				var is_from_mingwenku = parent_slot and parent_slot.is_in_group("mingwenku_slot")
				var is_from_bag = parent_slot and parent_slot.is_in_group("school_bag_slot")

				if is_from_mingwenku:
					_try_place_to_bag(event.global_position)
				elif is_from_bag:
					var placed_to_mingwenku = _try_place_to_mingwenku(event.global_position)
					if not placed_to_mingwenku:
						_try_swap_in_bag(event.global_position)


# 拖拽位置更新
func _process(delta: float):
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset


# 尝试将物品放置到铭文库
func _try_place_to_mingwenku(global_pos: Vector2) -> bool:
	if not left_grid:
		_return_to_origin()
		return false

	var found_target_slot = false
	for slot in get_tree().get_nodes_in_group("mingwenku_slot"):
		var is_mouse_over = slot.get_global_rect().has_point(global_pos)
		var slot_is_light = slot.is_light
		var target_icon = slot.get_node_or_null("Icon")
		var is_slot_occupied = target_icon and target_icon.texture != null
		
		if is_mouse_over and slot_is_light and not is_slot_occupied:
			found_target_slot = true
			if not target_icon:
				_return_to_origin()
				return false
			
			# 同步Item到目标Slot和Icon
			slot.item = parent_slot.item  # 同步Slot的item属性
			target_icon.item_resource = slot.item  # 同步Icon的item_resource
			
			target_icon.texture = texture
			var effect_type = icon_effect_map.get(texture.resource_path, "")
			
			if effect_type:
				var temp_affected = _trigger_effect(slot, effect_type)
				target_icon.affected_slots = temp_affected
			
			# 清空原Slot和Icon的Item
			texture = null
			parent_slot.item = null
			item_resource = null
			return true
	
	if not found_target_slot:
		_return_to_origin()
	return false


# 尝试将物品从铭文库移回背包
func _try_place_to_bag(global_pos: Vector2):
	var target_slot = null
	for slot in get_tree().get_nodes_in_group("school_bag_slot"):
		if slot.get_global_rect().has_point(global_pos):
			target_slot = slot
			break
	
	if target_slot:
		var target_icon = target_slot.get_node_or_null("Icon")
		if not target_icon:
			_return_to_origin()
			return
		
		if target_icon.texture == null:
			_reset_effects()
			# 同步Item到目标Slot和Icon
			target_slot.item = parent_slot.item  # 同步Slot的item属性
			target_icon.item_resource = target_slot.item  # 同步Icon的item_resource
			
			target_icon.texture = texture
			target_icon.affected_slots = affected_slots.duplicate()
			
			# 清空原Slot和Icon的Item
			texture = null
			parent_slot.item = null
			item_resource = null
			affected_slots.clear()
		else:
			_return_to_origin()
		return
	else:
		_return_to_origin()


# 尝试在背包内交换物品
func _try_swap_in_bag(global_pos: Vector2):
	if not bag_grid:
		return
	
	# 遍历背包槽位
	for slot in get_tree().get_nodes_in_group("school_bag_slot"):
		if slot != parent_slot and slot.get_global_rect().has_point(global_pos):
			_swap_items(slot)
			return


# 接收交换时传递的affected_slots
func _set_affected_slots(slots: Array):
	affected_slots = slots


# 交换两个槽位的物品
# 交换两个槽位的物品（仅移动位置，无复制）
func _swap_items(target_slot):
	var target_icon = target_slot.get_node_or_null("Icon")
	if not target_icon:
		return
	
	# 1. 暂存当前槽位和目标槽位的Item、纹理、资源
	var current_slot_item = parent_slot.item
	var current_texture = texture
	var current_item_resource = item_resource
	var current_affected = affected_slots

	var target_slot_item = target_slot.item
	var target_texture = target_icon.texture
	var target_item_resource = target_icon.item_resource
	var target_affected = target_icon.affected_slots

	# 2. 交换：当前槽位 ← 目标槽位的内容
	parent_slot.item = target_slot_item
	texture = target_texture
	item_resource = target_item_resource
	affected_slots = target_affected

	# 3. 交换：目标槽位 ← 原当前槽位的内容
	target_slot.item = current_slot_item
	target_icon.texture = current_texture
	target_icon.item_resource = current_item_resource
	target_icon.affected_slots = current_affected

	# 4. 更新父容器引用
	var old_parent = parent_slot
	parent_slot = target_slot
	var old_icon = old_parent.get_node_or_null("Icon")
	if old_icon:
		old_icon.parent_slot = old_parent


# 物品放回原槽位
func _return_to_origin():
	if parent_slot:
		var slot_center = parent_slot.global_position + parent_slot.size / 2
		global_position = slot_center - size / 2


# 触发槽位点亮效果并返回受影响的槽位
func _trigger_effect(target_slot, effect_type: String) -> Array:
	var affected = []
	var grid_container = target_slot.get_parent()
	if not grid_container or grid_container.get_class() != "GridContainer":
		return affected

	var slot_idx = grid_container.get_children().find(target_slot)
	if slot_idx == -1:
		return affected

	var columns = max(grid_container.columns, 1)
	var total_cells = grid_container.get_child_count()
	var row = slot_idx / columns
	var col = slot_idx % columns

	match effect_type:
		"light_right_2":
			for i in [1, 2]:
				var new_col = col + i
				var new_idx = row * columns + new_col
				if new_col >= 0 and new_col < columns and new_idx < total_cells:
					var target = grid_container.get_child(new_idx)
					if target and target.has_method("set_state"):
						target.set_state(true)
						affected.append(target)
						
		"light_left_2":
			for i in [1, 2]:
				var new_col = col - i
				var new_idx = row * columns + new_col
				if new_col >= 0 and new_col < columns and new_idx < total_cells:
					var target = grid_container.get_child(new_idx)
					if target and target.has_method("set_state"):
						target.set_state(true)
						affected.append(target)
						
		"light_up_2":
			for i in [1, 2]:
				var new_row = row - i
				var new_idx = new_row * columns + col
				if new_row >= 0 and new_idx < total_cells:
					var target = grid_container.get_child(new_idx)
					if target and target.has_method("set_state"):
						target.set_state(true)
						affected.append(target)
						
		"light_down_2":
			for i in [1, 2]:
				var new_row = row + i
				var new_idx = new_row * columns + col
				if new_idx < total_cells:
					var target = grid_container.get_child(new_idx)
					if target and target.has_method("set_state"):
						target.set_state(true)
						affected.append(target)
						
		"right_to_side_2":
			var up_right_idx = (row - 1) * columns + (col + 1)
			if up_right_idx >= 0 and up_right_idx < total_cells:
				var target = grid_container.get_child(up_right_idx)
				if target and target.has_method("set_state"):
					target.set_state(true)
					affected.append(target)
			var down_right_idx = (row + 1) * columns + (col - 1)
			if down_right_idx < total_cells:
				var target = grid_container.get_child(down_right_idx)
				if target and target.has_method("set_state"):
					target.set_state(true)
					affected.append(target)
						
		"left_to_side_2":
			var up_left_idx = (row - 1) * columns + (col - 1)
			if up_left_idx >= 0 and up_left_idx < total_cells:
				var target = grid_container.get_child(up_left_idx)
				if target and target.has_method("set_state"):
					target.set_state(true)
					affected.append(target)
			var down_left_idx = (row + 1) * columns + (col + 1)
			if down_left_idx < total_cells:
				var target = grid_container.get_child(down_left_idx)
				if target and target.has_method("set_state"):
					target.set_state(true)
					affected.append(target)
						
		"up_down_2":
			var up_idx = (row - 1) * columns + col
			if up_idx >= 0:
				var target = grid_container.get_child(up_idx)
				if target and target.has_method("set_state"):
					target.set_state(true)
					affected.append(target)
			var down_idx = (row + 1) * columns + col
			if down_idx < total_cells:
				var target = grid_container.get_child(down_idx)
				if target and target.has_method("set_state"):
					target.set_state(true)
					affected.append(target)
					
	return affected


# 重置效果（排除永久亮槽位和有物品的槽位）
func _reset_effects():
	for slot in affected_slots:
		if not is_instance_valid(slot) or not slot.has_method("set_state"):
			continue
		
		var slot_icon = slot.get_node_or_null("Icon")
		var has_item = slot_icon and slot_icon.texture != null
		if has_item:
			continue
		
		var grid_container = slot.get_parent()
		if not grid_container or grid_container.get_class() != "GridContainer":
			slot.set_state(false)
			continue
		
		var columns = max(grid_container.columns, 1)
		var slot_idx = grid_container.get_children().find(slot)
		var slot_row = slot_idx / columns
		var slot_col = slot_idx % columns
		
		var is_permanent_light = false
		for light_coord in PERMANENT_LIGHT_SLOTS:
			if light_coord[0] == slot_row and light_coord[1] == slot_col:
				is_permanent_light = true
				break
		
		if not is_permanent_light:
			slot.set_state(false)
	
	affected_slots.clear()


# 鼠标悬停显示描述
func _on_mouse_entered():
	if item_resource != null and owner.has_method("set_description"):
		owner.set_description(item_resource)


# 节点销毁时重置效果
func _exit_tree():
	_reset_effects()
