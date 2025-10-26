extends Enemy
@onready var hp=$hp

func _ready() -> void:
	super._ready()
	hp.text=str(now_HP)
