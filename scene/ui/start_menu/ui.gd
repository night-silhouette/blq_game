extends Control

@export var equipment_panel: Control
@export var weapon_panel: Control

@export var equipment_description : Control
@export var weapon_description : Control
@export var schoolbag_description : Control

@export var equipment_library:Control
@export var weapon_library:Control

func _ready():
	equipment_library.visible = true  # 初始显示装备库
	weapon_library.visible = false    # 初始隐藏武器库
		
func switch_to_weapon_panel():
	if equipment_panel:  # 简化空值判断	
		equipment_library.visible = false

	if weapon_panel:
		weapon_library.visible=true

func switch_to_equipment_panel():
	if weapon_panel:
		weapon_library.visible = false

	if equipment_panel:
		equipment_library.visible = true

func set_description(item:Item):
	# 装备描述节点校验
	var equip_name = equipment_description.find_child("Name")
	if equip_name: equip_name.text = item.title
	var equip_icon = equipment_description.find_child("Icon")
	if equip_icon: equip_icon.texture = item.icon
	var equip_desc = equipment_description.find_child("Description")
	if equip_desc: equip_desc.text = item.description

	# 武器描述节点校验
	var weapon_name = weapon_description.find_child("Name")
	if weapon_name: weapon_name.text = item.title
	var weapon_icon = weapon_description.find_child("Icon")
	if weapon_icon: weapon_icon.texture = item.icon
	var weapon_desc = weapon_description.find_child("Description")
	if weapon_desc: weapon_desc.text = item.description

	var schoolbag_name = schoolbag_description.find_child("Name")
	if schoolbag_name: schoolbag_name.text = item.title
	var schoolbag_icon = schoolbag_description.find_child("Icon")
	if schoolbag_icon: schoolbag_icon.texture = item.icon
	var schoolbag_desc = schoolbag_description.find_child("Description")
	if schoolbag_desc: schoolbag_desc.text = item.description

	
	
func _on_button_pressed() -> void:
	pass # Replace with function body.
