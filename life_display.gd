extends Node2D

var _lives: int = 3

func set_lives(n: int) -> void:
	_lives = n
	queue_redraw()

func _draw() -> void:
	for i in _lives:
		var c := Vector2(18.0 + i * 30.0, 18.0)
		draw_circle(c, 12, Color(1, 1, 1))
		draw_circle(c, 3.8, Color(0.12, 0.12, 0.12))
		draw_circle(c + Vector2(-3.8, -3.8), 2.5, Color(0.12, 0.12, 0.12))
		draw_circle(c + Vector2( 3.8, -3.8), 2.5, Color(0.12, 0.12, 0.12))
		draw_circle(c + Vector2(-4.5,  1.8), 2.5, Color(0.12, 0.12, 0.12))
		draw_circle(c + Vector2( 4.5,  1.8), 2.5, Color(0.12, 0.12, 0.12))
		draw_circle(c + Vector2(-4.0, -5.0), 3.0, Color(1, 1, 1, 0.50))
