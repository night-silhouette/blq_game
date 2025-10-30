extends GameInputControl


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
@onready var bag=$"../CanvasLayer/bag"
@onready var Canvaslayer=$"../CanvasLayer"
func _process(delta: float) -> void:
		if Input.is_action_just_pressed("bag"):
			bag.visible= not bag.visible
		
			


			
