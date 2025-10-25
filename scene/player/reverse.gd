extends Node2D
@onready var obj=$".."
@onready var gameinputcontrol=$"../GameInputControl"
signal attack_reversed()

@onready var children=get_children()


var scale_dir={}
func _ready() -> void:
	for child in children:
		scale_dir[child]=child.scale
	
	
	

	for child in children:

		attack_reversed.connect(func():

			if gameinputcontrol.column_dir==0 and obj.face_dir>0:
				child.scale=scale_dir[child]
				child.rotation=0
			elif gameinputcontrol.column_dir==0 and obj.face_dir<0:
				child.scale.x=-scale_dir[child].x
				child.scale.y=scale_dir[child].y
				child.rotation=0
			elif gameinputcontrol.column_dir==1:
				child.scale.x=scale_dir[child].x
				child.rotation=PI/2
				if obj.face_dir>0:
					child.scale.y=-scale_dir[child].y
				if obj.face_dir<0:
					child.scale.y=scale_dir[child].y
			elif gameinputcontrol.column_dir==-1:
				child.scale.x=scale_dir[child].x
				child.rotation=-PI/2
				if obj.face_dir>0:
					child.scale.y=scale_dir[child].y
				if obj.face_dir<0:
					child.scale.y=-scale_dir[child].y
		)
func _physics_process(delta: float) -> void:
	pass

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
