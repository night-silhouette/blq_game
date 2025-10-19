extends TextureRect

# 拖拽状态
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
@onready var parent_slot = get_parent()  # 关联所在背包Slot
@onready var left_grid: GridContainer  # 左侧铭文库GridContainer

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


func _ready():
	# 初始化左侧铭文库GridContainer（适配场景节点路径）
	var mingwenku_node = get_node_or_null("/root/UI/铭文库")
	if not mingwenku_node:
		mingwenku_node = get_node_or_null("/root/UI/铭文库") 
	
	if mingwenku_node:
		left_grid = mingwenku_node.get_node_or_null("GridContainer")
		if not left_grid:
			print("错误：铭文库下未找到GridContainer节点")
	else:
		print("错误：未找到铭文库节点")


# 输入事件处理（拖拽逻辑）
func _input(event: InputEvent):
	# 仅处理背包槽内的物品
	if not parent_slot or !parent_slot.is_in_group("school_bag_slot"):
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
				_try_place_to_mingwenku(event.global_position)


# 拖拽位置更新
func _process(delta: float):
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset


# 尝试将物品放置到铭文库
func _try_place_to_mingwenku(global_pos: Vector2):
	if not left_grid:
		_return_to_origin()
		return
	
	# 遍历铭文库槽位，检查是否可放置（仅亮态槽位允许）
	for slot in get_tree().get_nodes_in_group("mingwenku_slot"):
		if slot.get_global_rect().has_point(global_pos) and slot.is_light:
			# 替换目标槽位的图标
			var target_icon = slot.get_node_or_null("Icon")
			if target_icon:
				target_icon.texture = texture
			
			# 获取当前图标的效果类型
			var effect_type = icon_effect_map.get(texture.resource_path, "")
			if effect_type:
				_trigger_effect(slot, effect_type)
			
			# 清空原背包槽的图标
			texture = null
			return
	
	# 无法放置时返回原背包槽
	_return_to_origin()


# 物品放回原背包槽
func _return_to_origin():
	if parent_slot:
		var slot_center = parent_slot.global_position + parent_slot.size / 2
		global_position = slot_center - size / 2


# 触发槽位点亮效果
func _trigger_effect(target_slot, effect_type: String):
	# 获取目标槽位所在的GridContainer
	var grid_container = target_slot.get_parent()
	if not grid_container or grid_container.get_class() != "GridContainer":
		print("错误：目标槽位的父节点不是GridContainer")
		return

	# 计算目标槽位的行列索引
	var slot_idx = grid_container.get_children().find(target_slot)
	if slot_idx == -1:
		print("错误：目标槽位不在GridContainer子节点中")
		return

	var columns = max(grid_container.columns, 1)  # 避免列数为0
	var total_cells = grid_container.get_child_count()
	var row = slot_idx /columns  # 整数除法计算行
	var col = slot_idx % columns   # 取余计算列

	# 执行对应效果
	match effect_type:
		"light_right_2":
			# 向右点亮2格
			for i in [1, 2]:
				var new_col = col + i
				var new_idx = row * columns + new_col
				# 边界检查
				if new_col >= 0 and new_col < columns and new_idx < total_cells:
					var target = grid_container.get_child(new_idx)
					if target and target.has_method("set_state"):
						target.set_state(true)
						
		"light_left_2":
			# 向右点亮2格
			for i in [1, 2]:
				var new_col = col - i
				var new_idx = row * columns + new_col
				# 边界检查
				if new_col >= 0 and new_col < columns and new_idx < total_cells:
					var target = grid_container.get_child(new_idx)
					if target and target.has_method("set_state"):
						target.set_state(true)
		"light_up_2":
			# 向右点亮2格
			for i in [1, 2]:
				var new_row = row - i  # 向上移动：行索引递减（-1是上1格，-2是上2格）
				var new_idx = new_row * columns + col  # 列不变，行变化
				if new_row >= 0 and col >= 0 and col < columns and new_idx < total_cells:
					var target = grid_container.get_child(new_idx)
					if target and target.has_method("set_state"):
						target.set_state(true)		
		
		"light_down_2":
			# 向右点亮2格
			for i in [1, 2]:
				var new_row = row + i  # 向上移动：行索引递减（-1是上1格，-2是上2格）
				var new_idx = new_row * columns + col  # 列不变，行变化
				if new_row >= 0 and col >= 0 and col < columns and new_idx < total_cells:
					var target = grid_container.get_child(new_idx)
					if target and target.has_method("set_state"):
						target.set_state(true)
						
		"up_to_side_2":
			# 向右点亮2格
			for i in [1, 2]:
				var new_row = row - i # 向上移动：行索引递减（-1是上1格，-2是上2格）
				var new_col = col + i 
				var new_idx = new_row * columns + col  # 列不变，行变化
				if new_row >= 0 and col >= 0 and col < columns and new_idx < total_cells:
					var target = grid_container.get_child(new_idx)
					if target and target.has_method("set_state"):
						target.set_state(true)		
						
		"right_to_side_2":
			var up_right_row = row - 1
			var up_right_col = col + 1
			var up_right_idx = up_right_row * columns + up_right_col
			var down_right_row = row + 1
			var down_right_col = col -1
			var down_right_idx = down_right_row * columns + down_right_col
			
			if up_right_row >= 0 and up_right_col < columns and up_right_idx < total_cells:
				var up_right_target = grid_container.get_child(up_right_idx)
				if up_right_target and up_right_target.has_method("set_state"):
					up_right_target.set_state(true)
					
			if down_right_row < (total_cells / columns) and down_right_col < columns and down_right_idx < total_cells:
				var down_right_target = grid_container.get_child(down_right_idx)
				if down_right_target and down_right_target.has_method("set_state"):
					down_right_target.set_state(true)		
						
		"left_to_side_2":
			# 向右点亮2格
			var up_right_row = row - 1
			var up_right_col = col - 1
			var up_right_idx = up_right_row * columns + up_right_col
			var down_right_row = row + 1
			var down_right_col = col + 1
			var down_right_idx = down_right_row * columns + down_right_col
			
			if up_right_row >= 0 and up_right_col < columns and up_right_idx < total_cells:
				var up_right_target = grid_container.get_child(up_right_idx)
				if up_right_target and up_right_target.has_method("set_state"):
					up_right_target.set_state(true)
					
			if down_right_row < (total_cells / columns) and down_right_col < columns and down_right_idx < total_cells:
				var down_right_target = grid_container.get_child(down_right_idx)
				if down_right_target and down_right_target.has_method("set_state"):
					down_right_target.set_state(true)	
					
		"up_down_2":
			# 向右点亮2格
			var up_row = row - 1
			var up_col = col  # 列索引不变
			var up_idx = up_row * columns + up_col
			var down_row = row + 1
			var down_col = col  # 列索引不变
			var down_idx = down_row * columns + down_col
			
			if up_row >= 0 and up_idx < total_cells:
				var up_target = grid_container.get_child(up_idx)
				if up_target and up_target.has_method("set_state"):
					up_target.set_state(true)
			if down_row < (total_cells / columns) and down_idx < total_cells:
				var down_target = grid_container.get_child(down_idx)
				if down_target and down_target.has_method("set_state"):
					down_target.set_state(true)			
					
					
						
		
	
