extends AnimatableBody2D

signal bonus_scored(points: int)

# 0=UFO 1=GK 2=MF 3=DF 4=Referee 5=Captain  ※UFO(0)は撃墜でボーナス300点
const COLLISION_SIZES = [
	Vector2(46, 70),   # FW
	Vector2(82, 58),   # GK
	Vector2(46, 70),   # MF
	Vector2(62, 52),   # DF
	Vector2(38, 70),   # Referee
	Vector2(48, 72),   # Captain
]

var _speed: float = 150.0
var _dir: int = 1
var _type: int = 0
var _manager: Node = null
var _removing := false

func setup(spd: float, d: int, t: int, mgr: Node) -> void:
	_speed   = spd
	_dir     = d
	_type    = t
	_manager = mgr
	($CollisionShape2D.shape as RectangleShape2D).size = COLLISION_SIZES[t]

func _physics_process(delta: float) -> void:
	if _removing:
		return
	position.x += _speed * _dir * delta
	if (_dir > 0 and position.x > 1350.0) or (_dir < 0 and position.x < -250.0):
		if _manager:
			_manager.on_obstacle_removed()
		queue_free()

func on_hit_by_ball() -> void:
	if _type != 0 or _removing:
		return
	_removing = true
	bonus_scored.emit(300)
	if _manager:
		_manager.on_obstacle_removed()
		_manager = null
	queue_free()

# --- drawing ---

func _draw() -> void:
	if _dir < 0:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(-1.0, 1.0))
	match _type:
		0: _draw_ufo()
		1: _draw_gk()
		2: _draw_mf()
		3: _draw_df()
		4: _draw_referee()
		5: _draw_captain()
	if _dir < 0:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

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

func _draw_ball(x: float, y: float) -> void:
	var c := Vector2(x, y)
	draw_circle(c, 5.8, Color(1, 1, 1))
	draw_circle(c, 1.8, Color(0.1, 0.1, 0.1))
	draw_circle(c + Vector2(-2.9, -2.9), 1.4, Color(0.1, 0.1, 0.1))
	draw_circle(c + Vector2( 2.9, -2.9), 1.4, Color(0.1, 0.1, 0.1))
	draw_circle(c + Vector2(-3.7,  1.4), 1.4, Color(0.1, 0.1, 0.1))
	draw_circle(c + Vector2( 3.7,  1.4), 1.4, Color(0.1, 0.1, 0.1))

# UFO — 撃墜でボーナス300点
func _draw_ufo() -> void:
	_e(0, 0, 52, 16, Color(0.5, 0.8, 1.0, 0.18))
	_e(0, 0, 47, 12, Color(0.68, 0.68, 0.78))
	_e(-9, -3, 18, 5, Color(0.84, 0.84, 0.93))
	_e(0, -12, 21, 21, Color(0.32, 0.60, 1.0, 0.70))
	var wc := [Color(1,1,0,0.9), Color(0,1,0.85,0.9), Color(1,0.4,0,0.9), Color(0.5,0.4,1,0.9)]
	for i in 4:
		var a := TAU * (i + 0.25) / 4
		draw_circle(Vector2(cos(a) * 31, sin(a) * 8), 4.5, wc[i])
	draw_arc(Vector2(0, 0), 47, -1.0, 0.0, 8, Color(1, 1, 1, 0.35), 2.0)
	# "BONUS" 表示で撃墜可能とわかるよう金色のリング強調
	draw_arc(Vector2(0, 0), 50, -PI, PI, 32, Color(1.0, 0.85, 0.0, 0.55), 2.5)

# FW (Forward) — 赤ユニフォーム、ボールを蹴る体勢
func _draw_fw() -> void:
	var jersey := Color(0.85, 0.12, 0.12)
	var shorts := Color(0.10, 0.10, 0.75)
	var skin   := Color(1.0, 0.82, 0.68)
	var sock   := Color(0.9, 0.9, 0.9)
	var shoe   := Color(0.12, 0.08, 0.08)
	var hair   := Color(0.15, 0.10, 0.05)
	_e(0, 38, 22, 5, Color(0, 0, 0, 0.15))
	draw_circle(Vector2(-9, 33), 5, shoe)
	draw_circle(Vector2(15, 29), 5, shoe)
	draw_rect(Rect2(-13, 20, 9, 14), sock)
	draw_rect(Rect2(6,  16, 9, 14), sock)
	draw_rect(Rect2(-13, 9, 9, 13), skin)
	draw_rect(Rect2(6,   5, 9, 13), skin)
	draw_rect(Rect2(-14, 5, 28, 14), shorts)
	draw_rect(Rect2(-13, -14, 26, 21), jersey)
	draw_rect(Rect2(-24, -10, 12,  7), jersey)
	draw_rect(Rect2( 13, -14, 11,  7), jersey)
	_draw_face(0, -25, skin, hair)
	_draw_ball(22, 32)

# GK (Goalkeeper) — 黄緑ユニフォーム、両腕を大きく広げる
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

# MF (Midfielder) — 青ユニフォーム、胸に縦ストライプ
func _draw_mf() -> void:
	var jersey := Color(0.10, 0.20, 0.85)
	var shorts := Color(0.10, 0.20, 0.85)
	var skin   := Color(0.88, 0.68, 0.52)
	var sock   := Color(1.0, 1.0, 1.0)
	var shoe   := Color(0.08, 0.08, 0.08)
	var hair   := Color(0.08, 0.06, 0.04)
	_e(0, 38, 20, 5, Color(0, 0, 0, 0.15))
	draw_circle(Vector2(-10, 32), 5, shoe)
	draw_circle(Vector2( 10, 32), 5, shoe)
	draw_rect(Rect2(-14, 20, 10, 13), sock)
	draw_rect(Rect2(  4, 20, 10, 13), sock)
	draw_rect(Rect2(-14,  8, 10, 14), skin)
	draw_rect(Rect2(  4,  8, 10, 14), skin)
	draw_rect(Rect2(-14,  5, 28, 14), shorts)
	draw_rect(Rect2(-13, -14, 26, 21), jersey)
	draw_rect(Rect2(-24, -12, 12,  7), jersey)
	draw_rect(Rect2( 12,  -8, 12,  7), jersey)
	draw_rect(Rect2(-2, -14, 4, 21), Color(1, 1, 1, 0.55))
	_draw_face(0, -25, skin, hair)

# DF (Defender) — 白ユニフォーム、腰を落としてブロック体勢
func _draw_df() -> void:
	var jersey := Color(0.92, 0.92, 0.92)
	var shorts := Color(0.10, 0.10, 0.75)
	var skin   := Color(0.72, 0.52, 0.40)
	var shoe   := Color(0.10, 0.10, 0.10)
	var hair   := Color(0.08, 0.06, 0.04)
	_e(0, 28, 32, 5, Color(0, 0, 0, 0.15))
	draw_circle(Vector2(-22, 24), 6, shoe)
	draw_circle(Vector2( 22, 24), 6, shoe)
	var leg_l := PackedVector2Array([
		Vector2(-6, 10), Vector2(-15, 10), Vector2(-28, 24), Vector2(-18, 24)])
	draw_polygon(leg_l, PackedColorArray([shorts]))
	var leg_r := PackedVector2Array([
		Vector2(6, 10), Vector2(15, 10), Vector2(28, 24), Vector2(18, 24)])
	draw_polygon(leg_r, PackedColorArray([shorts]))
	draw_rect(Rect2(-15, -2, 30, 14), shorts)
	draw_rect(Rect2(-15, -14, 30, 18), jersey)
	draw_rect(Rect2(-30, -10, 16,  8), jersey)
	draw_rect(Rect2( 14, -10, 16,  8), jersey)
	_draw_face(0, -23, skin, hair)

# Referee — 黒ユニフォーム、イエローカードを掲げる
func _draw_referee() -> void:
	var jersey := Color(0.10, 0.10, 0.10)
	var skin   := Color(0.88, 0.72, 0.58)
	var hair   := Color(0.25, 0.15, 0.08)
	var shoe   := Color(0.08, 0.08, 0.08)
	_e(0, 38, 18, 5, Color(0, 0, 0, 0.15))
	draw_circle(Vector2(-9, 32), 5, shoe)
	draw_circle(Vector2( 9, 32), 5, shoe)
	draw_rect(Rect2(-12, 20,  9, 13), jersey)
	draw_rect(Rect2(  3, 20,  9, 13), jersey)
	draw_rect(Rect2(-12,  7, 24, 14), jersey)
	draw_rect(Rect2(-12, -14, 24, 22), jersey)
	draw_rect(Rect2(-12, -14, 24,  3), Color(1, 1, 1, 0.45))
	draw_rect(Rect2(-22,  -8, 11,  7), jersey)
	draw_rect(Rect2( 11, -26,  9, 18), jersey)
	draw_rect(Rect2(15, -38, 12, 16), Color(1.0, 0.90, 0.0))
	draw_rect(Rect2(-5, -18,  8,  4), Color(0.75, 0.75, 0.10))
	_draw_face(0, -25, skin, hair)

# Captain — オレンジユニフォーム、腕を上げてチームを鼓舞、キャプテンマーク
func _draw_captain() -> void:
	var jersey := Color(0.95, 0.50, 0.05)
	var shorts := Color(0.08, 0.08, 0.08)
	var skin   := Color(0.92, 0.75, 0.60)
	var sock   := Color(0.95, 0.50, 0.05)
	var shoe   := Color(0.10, 0.10, 0.10)
	var hair   := Color(0.88, 0.72, 0.10)
	_e(0, 38, 22, 5, Color(0, 0, 0, 0.15))
	draw_circle(Vector2(-10, 32), 5, shoe)
	draw_circle(Vector2( 10, 32), 5, shoe)
	draw_rect(Rect2(-14, 20, 10, 13), sock)
	draw_rect(Rect2(  4, 20, 10, 13), sock)
	draw_rect(Rect2(-14,  8, 10, 14), skin)
	draw_rect(Rect2(  4,  8, 10, 14), skin)
	draw_rect(Rect2(-15,  5, 30, 14), shorts)
	draw_rect(Rect2(-14, -14, 28, 21), jersey)
	draw_rect(Rect2(-25, -12, 12,  7), jersey)
	draw_rect(Rect2( 14, -22, 10, 14), jersey)
	draw_rect(Rect2( 14, -16, 10,  5), Color(1.0, 1.0, 0.0, 0.92))
	draw_rect(Rect2(-14,  -3, 28,  5), Color(0.08, 0.08, 0.08, 0.65))
	_draw_face(0, -25, skin, hair)
