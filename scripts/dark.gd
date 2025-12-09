extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var demon: Demon = $Demon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.player.speed += 100
	self.demon.speed += 100
	self.demon.timer.start()
	self.demon.apply_scale(Vector2(2.0, 2.0))
	self.demon.currentState = DemonState.DemonState.DEMON
