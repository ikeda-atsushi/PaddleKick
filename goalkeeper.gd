extends AnimatableBody2D

const GL := 395.0
const GR := 795.0
const PW := 18.0

@export var speed: float = 220.0

var _half_w: float
var _target_x: float
var _wait_time: float = 0.0
var _waiting: bool = false
var _facing: int = 1

func _ready() -> void:
	_half_w = ($CollisionShape2D.shape as RectangleShape2D).size.x * 0.5
	_target_x = _rand_x()
	queue_redraw()

func _rand_x() -> float:
	return randf_range(GL + PW + _half_w, GR - PW - _half_w)

func _physics_process(delta: float) -> void:
	if _waiting:
		_wait_time -= delta
		if _wait_time <= 0.0:
			_target_x = _rand_x()
			_waiting = false
		return
	var diff: float = _target_x - position.x
	var step: float = speed * delta
	if abs(diff) <= step:
		position.x = _target_x
		_wait_time = randf_range(0.1, 1.0)
		_waiting = true
	else:
		var new_facing: int = 1 if diff > 0 else -1
		if new_facing != _facing:
			_facing = new_facing
			queue_redraw()
		position.x += sign(diff) * step

# --- obstacle.gd と共通の描画ヘルパー ---

func _e(cx: float, cy: float, rx: float, ry: float, c: Color, n: int = 24) -> void:
	var p := PackedVector2Array()
	for i in n:
		var a := TAU * i / n
		p.append(Vector2(cx + cos(a) * rx, cy + sin(a) * ry))
	draw_polygon(p, PackedColorArray([c]))

func _draw_face(x: float, y: float, skin: Color, hair: Color) -> void:
	draw_circle(Vector2(x, y), 11, skin)
	_e(x, y - 7, 10, 5, hair)
	draw_circle(Vector2(x - 3.5, y - 1), 2.0, Color(0.1, 0.1, 0.1))
	draw_circle(Vector2(x + 3.5, y - 1), 2.0, Color(0.1, 0.1, 0.1))
	draw_arc(Vector2(x, y + 4), 4, 0.3, PI - 0.3, 6, Color(0.6, 0.2, 0.2), 1.5)

func _draw() -> void:
	if _facing < 0:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(-1.0, 1.0))
	_draw_gk()
	if _facing < 0:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_gk() -> void:
	var jersey := Color(0.55, 0.88, 0.18)
	var shorts := Color(0.08, 0.08, 0.08)
	var skin   := Color(0.95, 0.78, 0.62)
	var sock   := Color(0.70, 0.70, 0.70)
	var shoe   := Color(0.08, 0.08, 0.08)
	var hair   := Color(0.85, 0.65, 0.10)
	var glove  := Color(0.88, 0.88, 0.88)
	_e(0, 32, 22, 5, Color(0, 0, 0, 0.15))
	draw_circle(Vector2(-10, 29), 6, shoe)
	draw_circle(Vector2( 10, 29), 6, shoe)
	draw_rect(Rect2(-14, 17, 10, 13), sock)
	draw_rect(Rect2(  4, 17, 10, 13), sock)
	draw_rect(Rect2(-14,  5, 10, 14), skin)
	draw_rect(Rect2(  4,  5, 10, 14), skin)
	draw_rect(Rect2(-15,  3, 30, 14), shorts)
	draw_rect(Rect2(-14, -14, 28, 19), jersey)
	draw_rect(Rect2(-40, -12, 28,  8), jersey)
	draw_rect(Rect2( 12, -12, 28,  8), jersey)
	draw_circle(Vector2(-40, -8), 8, glove)
	draw_circle(Vector2( 40, -8), 8, glove)
	_draw_face(0, -25, skin, hair)
