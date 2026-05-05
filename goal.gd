extends Node2D

signal goal_scored

const GL = 395.0   # goal left
const GR = 795.0   # goal right
const GT = 20.0    # goal top (y, directly below top wall)
const GB = 120.0   # goal bottom (opening)
const PW = 18.0    # post width

func _draw() -> void:
	_draw_net()
	_draw_shadow()
	_draw_frame()
	_draw_highlights()

func _draw_net() -> void:
	var il = GL + PW
	var ir = GR - PW
	var it = GT + PW

	# Net background (dark navy blue)
	draw_rect(Rect2(il, it, ir - il, GB - it), Color(0.03, 0.08, 0.45, 0.6))

	# Net grid lines
	var y = it + 20.0
	while y < GB:
		draw_line(Vector2(il, y), Vector2(ir, y), Color(1, 1, 1, 0.28), 1.5)
		y += 20.0
	var x = il + 20.0
	while x < ir:
		draw_line(Vector2(x, it), Vector2(x, GB), Color(1, 1, 1, 0.28), 1.5)
		x += 20.0

func _draw_shadow() -> void:
	var o = 7.0
	var s = Color(0, 0, 0, 0.45)
	# Crossbar shadow
	draw_rect(Rect2(GL + o, GT + o, GR - GL, PW), s)
	# Left post shadow
	draw_rect(Rect2(GL + o, GT + o, PW, GB - GT), s)
	# Right post shadow
	draw_rect(Rect2(GR - PW + o, GT + o, PW, GB - GT), s)

func _draw_frame() -> void:
	var c = Color(0.95, 0.95, 0.96)
	# Crossbar
	draw_rect(Rect2(GL, GT, GR - GL, PW), c)
	# Left post
	draw_rect(Rect2(GL, GT, PW, GB - GT), c)
	# Right post
	draw_rect(Rect2(GR - PW, GT, PW, GB - GT), c)

	# Red accent bands (like real soccer goals)
	var band_h = 8.0
	var band_c = Color(0.85, 0.1, 0.1)
	var steps = int((GB - GT - PW) / (band_h * 3))
	for i in range(steps + 1):
		var by = GT + PW + i * band_h * 3
		if by + band_h <= GB:
			draw_rect(Rect2(GL, by, PW, band_h), band_c)
			draw_rect(Rect2(GR - PW, by, PW, band_h), band_c)

func _draw_highlights() -> void:
	var h = Color(1, 1, 1, 0.72)
	var h2 = Color(0.55, 0.55, 0.6, 0.8)
	# Crossbar top edge highlight
	draw_rect(Rect2(GL + 3, GT + 2, GR - GL - 6, 4), h)
	# Crossbar bottom edge
	draw_rect(Rect2(GL + 3, GT + PW - 4, GR - GL - 6, 2), h2)
	# Left post inner highlight
	draw_rect(Rect2(GL + 3, GT + PW + 2, 4, GB - GT - PW - 4), h)
	# Right post inner highlight
	draw_rect(Rect2(GR - PW + 3, GT + PW + 2, 4, GB - GT - PW - 4), h)

const MARGIN := 60.0  # ポスト内面からの余白（ポスト接触誤判定防止）

var _ball: Node2D = null
var _scored := false

func _ready() -> void:
	$ScoreZone.body_entered.connect(_on_body_entered)
	$ScoreZone.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		_ball = body
		_scored = false

func _on_body_exited(body: Node2D) -> void:
	if body == _ball:
		_ball = null
		_scored = false

func _process(_delta: float) -> void:
	if _scored or _ball == null or not is_instance_valid(_ball):
		return
	var bx := _ball.global_position.x
	var by := _ball.global_position.y
	# ボールの中心がゴール内部に入ったときのみゴール
	if bx > GL + PW + MARGIN and bx < GR - PW - MARGIN and by > GT and by < GB:
		_scored = true
		goal_scored.emit()
