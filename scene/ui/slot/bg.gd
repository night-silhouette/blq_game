extends Control

# 引用BG节点（TextureRect）
@onready var bg = $BG

# 预加载亮/暗图片（替换为你的资源路径）
const LIGHT_TEXTURE = preload("res://asset/image/tile_0013.png")
const DARK_TEXTURE = preload("res://asset/image/tile_0014.png")


var is_light: bool = false  # 记录当前状态（亮/暗）


func set_state(is_light_state: bool):
	is_light = is_light_state
	bg.texture = LIGHT_TEXTURE if is_light else DARK_TEXTURE
