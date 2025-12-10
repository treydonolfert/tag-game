class_name Demon
extends CharacterBody2D


var speed = 250.0
const JUMP_VELOCITY = -400.0
var can_fire = false
@export var player: CharacterBody2D
@export var BulletScene: PackedScene
@export var fireRate = 1.0
@onready var timer: Timer = $BulletCD
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var stagger: Timer = $Stagger

var currentState = DemonState.DemonState.CHILD

func _process(delta: float) -> void:
	if can_fire:
		currentState = DemonState.DemonState.STAGGER
		stagger.start()
		can_fire = false

func _physics_process(delta: float) -> void:
	var direction = (player.position - position).normalized()
	velocity.x = direction.x * speed
	
	if currentState == DemonState.DemonState.CHILD:
		if not is_on_floor():
			velocity += get_gravity() * delta
		anim.play("child")
	else:
		velocity.y = direction.y * speed
		anim.play("demon")
	
	if currentState == DemonState.DemonState.STAGGER:
		velocity = Vector2.ZERO
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
	var time = randf_range(0.5, 3)
	timer.wait_time = time
	timer.start()
	can_fire = false


func _on_timer_timeout() -> void:
	can_fire = true

func _on_stagger_timeout() -> void:
	currentState = DemonState.DemonState.DEMON
	fire(speed + 300)
