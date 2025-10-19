extends Node2D
@onready var obj=$".."

signal reverse_h()

@onready var children=get_children()
func _ready() -> void:
	
	
	
	

	for child in children:
		var texture=child.get_texture()
		var w=texture.get_width()
		var h=texture.get_height()
		reverse_h.connect(func():
			if child.can_reverse:

					child.flip_h=not child.flip_h
					child.offset.x+= -w/child.hframes if (!child.flip_h) else w/child.hframes
			
			)
func _physics_process(delta: float) -> void:
	for child in children:
		if (child.flip_h and obj.face_dir==-1) or (!child.flip_h and obj.face_dir==1):
			reverse_h.emit()
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
