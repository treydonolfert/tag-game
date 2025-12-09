extends CharacterBody2D


var speed = 250.0
const JUMP_VELOCITY = -400.0
var can_fire = false
@export var player: CharacterBody2D
@export var BulletScene: PackedScene
@export var fireRate = 1.0
@onready var timer: Timer = $Timer


func _process(delta: float) -> void:
	if can_fire:
		fire(speed + 100)

func _physics_process(delta: float) -> void:
	var direction = (player.position - position).normalized()
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("Player"):
			var tree = get_tree()
			if tree:
				tree.change_scene_to_file("res://scenes/game_over.tscn")

func fire(bullet_speed):
	var direction = (player.position - position).normalized()
	var bullet = BulletScene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.set_direction(direction, bullet_speed)
	can_fire = false


func _on_timer_timeout() -> void:
	can_fire = true
