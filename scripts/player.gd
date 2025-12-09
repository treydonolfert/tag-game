extends CharacterBody2D


var speed = 300.0
const JUMP_VELOCITY = -800.0
enum State {
	IDLE,
	WALK,
	FROZEN
}
var current_state = State.WALK
@onready var timer: Timer = $Timer
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if current_state == State.FROZEN:
		velocity.x = 0
		anim.play("idle")
		move_and_slide()
		return
	if velocity.x == 0:
		current_state = State.IDLE
		anim.play("idle")
	else:
		current_state = State.WALK
		anim.play("walk")
		anim.flip_h = velocity.x > 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func freeze():
	current_state = State.FROZEN
	timer.start()
	


func _on_timer_timeout() -> void:
	current_state = State.IDLE
	
