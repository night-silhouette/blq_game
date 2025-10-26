extends Enemy
@onready var hp=$hp

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	hp.text=str(now_HP)+"hp"
