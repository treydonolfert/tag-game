extends Area2D

var velocity = Vector2.ZERO
func set_direction(dir, spd):
	velocity = dir*spd
	rotation = dir.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += velocity * delta



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.freeze()
		queue_free()
