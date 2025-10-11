extends CharacterBody2D
@onready var animationPlayer=$AnimationPlayer
@onready var state_machine=$State_machine
@onready var collision_management=$Collision_management
@onready var gameInputControl=$GameInputControl
func _ready():
	state_machine.init(self,animationPlayer,collision_management,gameInputControl)
	
