extends RigidBody2D

signal game_over

@export var ball_speed = 350
var screen_size
var _start_pos: Vector2
var _do_reset  := false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	_start_pos  = global_position
	_launch()

func _launch() -> void:
	var angle_rad := deg_to_rad(45.0 * (1.0 if randf() > 0.5 else -1.0))
	linear_velocity = Vector2(sin(angle_rad), -cos(angle_rad)) * ball_speed

func reset() -> void:
	_do_reset = true
	set_process(true)

# custom_integrator=true のため、位置・速度のリセットは必ずここで行う
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not _do_reset:
		return
	_do_reset = false
	state.transform = Transform2D(0.0, _start_pos)
	var angle_rad := deg_to_rad(45.0 * (1.0 if randf() > 0.5 else -1.0))
	state.linear_velocity = Vector2(sin(angle_rad), -cos(angle_rad)) * ball_speed

func _process(_delta: float) -> void:
	var out_x: bool = position.x < -100.0 or position.x > screen_size.x + 100.0
	var out_y: bool = position.y > screen_size.y + 100.0
	if out_x or out_y:
		set_process(false)
		game_over.emit()

func _on_body_entered(body: Node) -> void:
	if body.has_method("on_hit_by_ball"):
		body.on_hit_by_ball()
