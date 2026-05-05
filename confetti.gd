extends Node2D

const COLORS = [
	Color(0.96, 0.26, 0.26),
	Color(1.0,  0.85, 0.1),
	Color(0.2,  0.55, 1.0),
	Color(0.2,  0.85, 0.3),
	Color(1.0,  0.4,  0.7),
	Color(1.0,  0.6,  0.1),
	Color(0.75, 0.2,  1.0),
]

var _pieces := []
var _active := false

func start() -> void:
	_pieces.clear()
	for i in 200:
		_pieces.append({
			"pos": Vector2(randf_range(30.0, 1160.0), randf_range(-100.0, -5.0)),
			"vel": Vector2(randf_range(-60.0, 60.0), randf_range(120.0, 360.0)),
			"rot": randf_range(0.0, TAU),
			"rot_spd": randf_range(-6.0, 6.0),
			"w": randf_range(8.0, 18.0),
			"h": randf_range(5.0, 10.0),
			"color": COLORS[randi() % COLORS.size()],
			"t": 0.0,
			"max_t": randf_range(3.0, 5.0),
		})
	_active = true
	queue_redraw()

func _process(delta: float) -> void:
	if not _active:
		return
	var any_alive := false
	for p in _pieces:
		p["t"] += delta
		if p["t"] < p["max_t"]:
			p["pos"] += p["vel"] * delta
			p["vel"].y += 200.0 * delta
			p["vel"].x += randf_range(-30.0, 30.0) * delta
			p["rot"] += p["rot_spd"] * delta
			any_alive = true
	if not any_alive:
		_active = false
		_pieces.clear()
	queue_redraw()

func _draw() -> void:
	for p in _pieces:
		if p["t"] >= p["max_t"]:
			continue
		var alpha := 1.0
		var fade_start: float = p["max_t"] - 0.8
		if p["t"] > fade_start:
			alpha = (p["max_t"] - p["t"]) / 0.8
		var c: Color = p["color"]
		c.a = alpha
		draw_set_transform(p["pos"], p["rot"])
		draw_rect(Rect2(-p["w"] * 0.5, -p["h"] * 0.5, p["w"], p["h"]), c)
	draw_set_transform(Vector2.ZERO, 0.0)
