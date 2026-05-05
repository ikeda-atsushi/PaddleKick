extends CharacterBody2D

@export var speed: int = 300

func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		direction.x = 1
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		direction.x = -1
	position += speed * direction * delta
	var half_w := ($CollisionShape2D.shape as RectangleShape2D).size.x * 0.5
	var screen_w := get_viewport_rect().size.x
	position.x = clamp(position.x, half_w, screen_w - half_w)
