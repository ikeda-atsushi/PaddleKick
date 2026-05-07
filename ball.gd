extends RigidBody2D

signal game_over

@export var ball_speed = 350
var screen_size
var _start_pos: Vector2
var _do_reset  := false
var _trapped   := false
var _trap_body: Node2D = null
var _trap_offset: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	_start_pos  = global_position
	can_sleep   = false
	_launch()

func _launch() -> void:
	var angle_rad := deg_to_rad(45.0 * (1.0 if randf() > 0.5 else -1.0))
	linear_velocity = Vector2(sin(angle_rad), -cos(angle_rad)) * ball_speed

func reset() -> void:
	_trapped   = false
	_trap_body = null
	_do_reset  = true
	set_process(true)

# custom_integrator=true のため、位置・速度のリセットは必ずここで行う
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _do_reset:
		_do_reset = false
		state.transform = Transform2D(0.0, _start_pos)
		var angle_rad := deg_to_rad(45.0 * (1.0 if randf() > 0.5 else -1.0))
		state.linear_velocity = Vector2(sin(angle_rad), -cos(angle_rad)) * ball_speed
		return
	if _trapped and _trap_body:
		state.transform = Transform2D(0.0, _trap_body.global_position + _trap_offset)
		state.linear_velocity = Vector2.ZERO

func _process(_delta: float) -> void:
	if _do_reset:
		return
	var out_x: bool = position.x < -100.0 or position.x > screen_size.x + 100.0
	var out_y: bool = position.y > screen_size.y + 100.0
	if out_x or out_y:
		set_process(false)
		game_over.emit()
		return
	if _trapped and not Input.is_key_pressed(KEY_T):
		_release()

func _release() -> void:
	_trapped = false
	# パドル上の位置に応じて微妙に角度をつけて発射（最大±30度）
	var angle: float = clamp(_trap_offset.x / 200.0, -0.5, 0.5)
	linear_velocity = Vector2(sin(angle), -cos(angle)) * ball_speed
	_trap_body = null

func _on_body_entered(body: Node) -> void:
	if body.has_method("on_hit_by_ball"):
		body.on_hit_by_ball()
	if not _trapped and Input.is_key_pressed(KEY_T) and body is CharacterBody2D:
		var cs := body.get_node("CollisionShape2D") as CollisionShape2D
		var half_h: float = (cs.shape as RectangleShape2D).size.y * 0.5
		var paddle_top: float = body.global_position.y + cs.position.y - half_h
		if global_position.y < paddle_top + 5.0:
			_trapped    = true
			_trap_body  = body
			_trap_offset = global_position - body.global_position
