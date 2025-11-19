extends PanelContainer

@export var item : Item:
	set(value):
		item = value
		if item != null:  # 增加空值判断
			$Icon.texture = item.icon


# 引用BG节点（TextureRect）
@onready var bg = $BG

# 预加载亮/暗图片（替换为你的资源路径）
const LIGHT_TEXTURE = preload("res://asset/image/bag/tile_0013.png")
const DARK_TEXTURE = preload("res://asset/image/bag/tile_0014.png")


var is_light: bool = false  # 记录当前状态（亮/暗）


@onready var icon = $Icon  # 关联物品图标节点
var current_item: Item = null



# 检查Slot是否为空
func is_empty() -> bool:
	return current_item == null
# 在slot.gd中添加set_item函数

func set_item(item: Item):
	current_item = item
	if current_item:
		icon.texture = current_item.icon
		icon.item_resource = current_item  # 关键：将Item传递给Icon
		icon.visible = true
	else:
		icon.texture = null
		icon.item_resource = null  # 清空Icon的Item引用
		icon.visible = false

# 尝试放置物品（拖拽松开后执行）
func try_place_item(global_pos: Vector2):
	for target_slot in get_tree().get_nodes_in_group("left_slot"):
		if target_slot.is_light and target_slot.get_global_rect().has_point(global_pos):
			var temp_item = target_slot.current_item
			target_slot.set_item(current_item)
			set_item(temp_item)
			if target_slot.get_parent().has_method("on_item_placed"):
				var slot_index = target_slot.get_parent().get_child_index(target_slot)
				target_slot.get_parent().on_item_placed(slot_index, current_item)
			return
			
	icon.position = Vector2.ZERO

func set_state(is_light_state: bool):
	is_light = is_light_state
	bg.texture = LIGHT_TEXTURE if is_light else DARK_TEXTURE
		
			
func _on_mouse_entered():
	if item !=null:
		owner.set_description(item)
		
		




		
	
	
	
	
	
	
