extends Node2D

signal bonus_scored(points: int)

const OBSTACLE_SCENE = preload("res://obstacle.tscn")
const MAX_COUNT     = 3
const SPAWN_Y_MIN   = 220.0   # ゴール底辺(120) + 最大上方描画(52) + マージン(48)
const SPAWN_Y_MAX   = 810.0   # パドル(915) - 最大下方描画(56) - マージン(49)
const SPAWN_SPD_MIN = 80.0
const SPAWN_SPD_MAX = 280.0
const SPAWN_X_LEFT  = -160.0
const SPAWN_X_RIGHT = 1350.0

var _enabled := false
var _count   := 0
var _timer   := 0.0

func enable() -> void:
	if _enabled:
		return
	_enabled = true
	_timer = randf_range(0.5, 2.0)

func on_obstacle_removed() -> void:
	_count = max(0, _count - 1)

func _process(delta: float) -> void:
	if not _enabled or _count >= MAX_COUNT:
		return
	_timer -= delta
	if _timer > 0.0:
		return
	_spawn()
	_timer = randf_range(2.5, 6.0)

func _spawn() -> void:
	var d   := 1 if randf() > 0.5 else -1
	var spd := randf_range(SPAWN_SPD_MIN, SPAWN_SPD_MAX)
	var y   := randf_range(SPAWN_Y_MIN, SPAWN_Y_MAX)
	var t   := randi() % 6
	var ob: AnimatableBody2D = OBSTACLE_SCENE.instantiate()
	# position を add_child より前に設定することで、(0,0) = ゴール付近への一瞬の描画を防ぐ
	ob.position = Vector2(SPAWN_X_LEFT if d == 1 else SPAWN_X_RIGHT, y)
	ob.setup(spd, d, t, self)
	ob.bonus_scored.connect(func(pts: int) -> void: bonus_scored.emit(pts))
	add_child(ob)
	_count += 1
