extends Control

# 图标映射表：通过图标纹理路径识别物品
var ICON_MAP = {
	"res://asset/image/bag/白色药水.png": {"name": "白色药水", "pinyin": "baiseyaoshui"},
	"res://asset/image/bag/紫水晶法杖.png": {"name": "紫水晶法杖", "pinyin": "zishuijingfazhang"},
	"res://asset/image/bag/红色小药水.png": {"name": "红色小药水", "pinyin": "hongsexiaoyaoshui"},
	"res://asset/image/bag/红色药水.png": {"name": "红色药水", "pinyin": "hongseyaoshui"},
	"res://asset/image/bag/蓝水晶法杖.png": {"name": "蓝水晶法杖", "pinyin": "lanshuijingfazhang"},
	"res://asset/image/bag/蓝色小药水.png": {"name": "蓝色小药水", "pinyin": "lansexiaoyaoshui"},
	"res://asset/image/bag/蓝色药水.png": {"name": "蓝色药水", "pinyin": "lanseyaoshui"},
}

var PERMANENT_LIGHT_SLOTS: Array = [[3, 2], [3, 3], [3, 4]]
# 面板切换相关导出变量
@export var equipment_panel: Control
@export var weapon_panel: Control

@export var equipment_description : Control
@export var weapon_description : Control
@export var schoolbag_description : Control

@export var equipment_library: Control
@export var weapon_library: Control

# 撤回功能：记录操作历史栈（存储每次操作的状态快照）
var undo_stack: Array = []
# 操作类型枚举（标记每次操作是移动还是交换）
enum OperationType { MOVE_FROM_MINGWENKU, MOVE_TO_MINGWENKU, SWAP_IN_BAG }

# 操作快照类（存储单次操作的关键数据）
class OperationSnapshot:
	var type: OperationType  # 操作类型
	var source_slot: Node  # 源槽位
	var target_slot: Node  # 目标槽位（交换/放置目标）
	var source_icon_data: Dictionary  # 源图标数据（纹理、item、受影响槽位）
	var target_icon_data: Dictionary  # 目标图标数据（交换时用）

	# 初始化快照（移动操作：源→目标）
	func _init_move(type: OperationType, source_slot: Node, target_slot: Node, source_icon: TextureRect):
		self.type = type
		self.source_slot = source_slot
		self.target_slot = target_slot
		# 存储源图标数据
		self.source_icon_data = {
			"texture": source_icon.texture,
			"item_resource": source_icon.item_resource,
			"affected_slots": source_icon.affected_slots.duplicate()
		}
		# 存储目标图标原始数据（防止覆盖后无法恢复）
		var target_icon = target_slot.get_node_or_null("Icon")
		if target_icon:
			self.target_icon_data = {
				"texture": target_icon.texture,
				"item_resource": target_icon.item_resource,
				"affected_slots": target_icon.affected_slots.duplicate()
			}
		else:
			self.target_icon_data = {}

	# 初始化快照（交换操作：两个槽位互换）
	func _init_swap(source_slot: Node, target_slot: Node, source_icon: TextureRect, target_icon: TextureRect):
		self.type = OperationType.SWAP_IN_BAG
		self.source_slot = source_slot
		self.target_slot = target_slot
		# 存储两个图标数据
		self.source_icon_data = {
			"texture": source_icon.texture,
			"item_resource": source_icon.item_resource,
			"affected_slots": source_icon.affected_slots.duplicate()
		}
		self.target_icon_data = {
			"texture": target_icon.texture,
			"item_resource": target_icon.item_resource,
			"affected_slots": target_icon.affected_slots.duplicate()
		}


func _ready():
	# 初始化面板显示状态
	equipment_library.visible = true  # 初始显示装备库
	weapon_library.visible = false    # 初始隐藏武器库


# 面板切换逻辑
func switch_to_weapon_panel():
	if equipment_library:  # 校验节点是否存在
		equipment_library.visible = false
	if weapon_library:
		weapon_library.visible = true

func switch_to_equipment_panel():
	if weapon_library:
		weapon_library.visible = false
	if equipment_library:
		equipment_library.visible = true


# 物品描述显示逻辑
func set_description(item: Item):
	# 装备描述更新
	var equip_name = equipment_description.find_child("Name")
	if equip_name:
		equip_name.text = item.title
	var equip_icon = equipment_description.find_child("Icon")
	if equip_icon:
		equip_icon.texture = item.icon
	var equip_desc = equipment_description.find_child("Description")
	if equip_desc:
		equip_desc.text = item.description

	# 武器描述更新
	var weapon_name = weapon_description.find_child("Name")
	if weapon_name:
		weapon_name.text = item.title
	var weapon_icon = weapon_description.find_child("Icon")
	if weapon_icon:
		weapon_icon.texture = item.icon
	var weapon_desc = weapon_description.find_child("Description")
	if weapon_desc:
		weapon_desc.text = item.description

	# 背包描述更新
	var schoolbag_name = schoolbag_description.find_child("Name")
	if schoolbag_name:
		schoolbag_name.text = item.title
	var schoolbag_icon = schoolbag_description.find_child("Icon")
	if schoolbag_icon:
		schoolbag_icon.texture = item.icon
	var schoolbag_desc = schoolbag_description.find_child("Description")
	if schoolbag_desc:
		schoolbag_desc.text = item.description


# 撤回按钮点击事件
func _on_btn_undo_pressed():
	if undo_stack.is_empty():
		return

	var snapshot = undo_stack.pop_back()
	var source_icon = snapshot.source_slot.get_node_or_null("Icon")
	var target_icon = snapshot.target_slot.get_node_or_null("Icon")

	if not source_icon or not target_icon:
		return

	# 步骤1：强制隐藏双方当前的警告（避免残留）
	source_icon.force_hide_warning()
	target_icon.force_hide_warning()

	# 步骤2：清除当前效果（关键：先熄灭所有非永久槽位）
	source_icon._reset_effects()
	target_icon._reset_effects()

	# 步骤3：恢复图标状态（包括受影响槽位）
	match snapshot.type:
		OperationType.MOVE_FROM_MINGWENKU:
			# 恢复源图标（铭文库）
			source_icon.texture = snapshot.source_icon_data.texture
			source_icon.item_resource = snapshot.source_icon_data.item_resource
			source_icon.set_affected_slots(snapshot.source_icon_data.affected_slots)  # 触发警告更新
			snapshot.source_slot.item = source_icon.item_resource

			# 恢复目标图标（背包）
			target_icon.texture = snapshot.target_icon_data.texture
			target_icon.item_resource = snapshot.target_icon_data.item_resource
			target_icon.set_affected_slots(snapshot.target_icon_data.affected_slots)  # 触发警告更新
			snapshot.target_slot.item = target_icon.item_resource

			# 恢复源图标历史效果
			for slot in source_icon.affected_slots:
				if is_instance_valid(slot) and slot.has_method("set_state"):
					slot.set_state(true)

		OperationType.MOVE_TO_MINGWENKU:
			# 恢复源图标（背包）
			source_icon.texture = snapshot.source_icon_data.texture
			source_icon.item_resource = snapshot.source_icon_data.item_resource
			source_icon.set_affected_slots(snapshot.source_icon_data.affected_slots)
			snapshot.source_slot.item = source_icon.item_resource

			# 恢复目标图标（铭文库）
			target_icon.texture = snapshot.target_icon_data.texture
			target_icon.item_resource = snapshot.target_icon_data.item_resource
			target_icon.set_affected_slots(snapshot.target_icon_data.affected_slots)  # 触发警告更新
			snapshot.target_slot.item = target_icon.item_resource

			# 恢复目标图标历史效果
			for slot in target_icon.affected_slots:
				if is_instance_valid(slot) and slot.has_method("set_state"):
					slot.set_state(true)

		OperationType.SWAP_IN_BAG:
			# 恢复源图标
			source_icon.texture = snapshot.source_icon_data.texture
			source_icon.item_resource = snapshot.source_icon_data.item_resource
			source_icon.set_affected_slots(snapshot.source_icon_data.affected_slots)  # 触发警告更新
			snapshot.source_slot.item = source_icon.item_resource

			# 恢复目标图标
			target_icon.texture = snapshot.target_icon_data.texture
			target_icon.item_resource = snapshot.target_icon_data.item_resource
			target_icon.set_affected_slots(snapshot.target_icon_data.affected_slots)  # 触发警告更新
			snapshot.target_slot.item = target_icon.item_resource

			# 恢复铭文库图标效果
			if source_icon.parent_slot and source_icon.parent_slot.is_in_group("mingwenku_slot"):
				for slot in source_icon.affected_slots:
					if is_instance_valid(slot) and slot.has_method("set_state"):
						slot.set_state(true)
			if target_icon.parent_slot and target_icon.parent_slot.is_in_group("mingwenku_slot"):
				for slot in target_icon.affected_slots:
					if is_instance_valid(slot) and slot.has_method("set_state"):
						slot.set_state(true)
						
	if is_instance_valid(source_icon):
		source_icon.update_all_mingwenku_warnings()
				



# 重置按钮点击事件（保留重复物品，按拼音排序）
func _on_btn_reset_pressed():
	# 1. 收集所有物品（保留重复，不做去重）
	var all_items: Array = []
	var all_slots = get_tree().get_nodes_in_group("school_bag_slot") + get_tree().get_nodes_in_group("mingwenku_slot")
	
	for slot in all_slots:
		var icon = slot.get_node_or_null("Icon")
		if not icon or not icon.texture:
			continue  # 跳过无图标或图标为空的槽位
		
		# 获取图标纹理路径（用于识别物品）
		var texture_path = icon.texture.resource_path
		
		# 通过图标路径匹配名称和拼音
		var item_info = ICON_MAP.get(texture_path, {
			"name": "未知物品（图标未映射）",
			"pinyin": "weizhiwupin"
		})
		
		# 保留物品资源
		var item_resource = icon.item_resource
		
		all_items.append({
			"texture": icon.texture,
			"item_resource": item_resource,
			"name": item_info.name,
			"pinyin": item_info.pinyin
		})


	# 2. 清除铭文库动态效果，保留永久点亮
	for mingwenku_slot in get_tree().get_nodes_in_group("mingwenku_slot"):
		var icon = mingwenku_slot.get_node_or_null("Icon")
		if icon:
			icon._reset_effects()
			icon.force_hide_warning()
			icon.texture = null
			icon.item_resource = null
			icon.affected_slots.clear()
		mingwenku_slot.item = null

	# 3. 保持永久点亮槽位
	var mingwenku_grid = get_tree().get_nodes_in_group("mingwenku_slot")[0].get_parent()
	if mingwenku_grid and mingwenku_grid.get_class() == "GridContainer":
		var columns = mingwenku_grid.columns
		for coord in PERMANENT_LIGHT_SLOTS:
			var row = coord[0]
			var col = coord[1]
			var slot_idx = row * columns + col
			if slot_idx >= 0 and slot_idx < mingwenku_grid.get_child_count():
				var permanent_slot = mingwenku_grid.get_child(slot_idx)
				if permanent_slot and permanent_slot.has_method("set_state"):
					permanent_slot.set_state(true)

	# 4. 按拼音排序（包含重复物品）
	all_items.sort_custom(func(a, b):
		return a.pinyin < b.pinyin
	)


	# 5. 清空背包
	for bag_slot in get_tree().get_nodes_in_group("school_bag_slot"):
		var icon = bag_slot.get_node_or_null("Icon")
		if icon:
			icon.texture = null
			icon.item_resource = null
			icon.affected_slots.clear()
		bag_slot.item = null

	# 6. 背包槽位排序（左→右、上→下）
	var bag_slots = get_tree().get_nodes_in_group("school_bag_slot")
	bag_slots.sort_custom(func(a, b):
		var parent = a.get_parent()
		return parent.get_children().find(a) < parent.get_children().find(b)
	)

	# 7. 按排序结果填充背包（含重复物品）
	for i in range(all_items.size()):
		if i >= bag_slots.size():
			break
		var item_data = all_items[i]
		var target_slot = bag_slots[i]
		var target_icon = target_slot.get_node_or_null("Icon")
		if target_icon:
			target_icon.texture = item_data.texture
			target_icon.item_resource = item_data.item_resource
			target_slot.item = item_data.item_resource

	# 8. 清空撤回历史
	undo_stack.clear()
