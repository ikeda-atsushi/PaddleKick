extends Node2D

static var persistent_score: int = 0

var _lives     := 3
var _goal_pending  := false
var _resetting := false

func _ready() -> void:
	$CanvasLayer/CenterContainer.hide()
	$CanvasLayer/GoalFlash.hide()
	$CanvasLayer/PauseLabel.hide()
	$CanvasLayer/ScoreLabel.text = "SCORE: " + str(persistent_score)
	$CanvasLayer/LifeDisplay.set_lives(_lives)
	$Ball.game_over.connect(_on_game_over)
	$Goal.goal_scored.connect(_on_goal_scored)
	$ObstacleManager.bonus_scored.connect(_on_bonus_scored)
	if persistent_score >= 1:
		$ObstacleManager.enable()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_P and event.pressed and not event.echo:
		get_tree().paused = not get_tree().paused
		$CanvasLayer/PauseLabel.visible = get_tree().paused

func _on_goal_scored() -> void:
	if _goal_pending:
		return
	_goal_pending = true
	persistent_score += 1
	$CanvasLayer/ScoreLabel.text = "SCORE: " + str(persistent_score)
	$ObstacleManager.enable()
	var flash = $CanvasLayer/GoalFlash
	flash.modulate.a = 1.0
	flash.show()
	$CanvasLayer/Confetti.start()
	get_tree().create_timer(1.5).timeout.connect(func():
		flash.hide()
		_goal_pending = false
	)

func _on_bonus_scored(points: int) -> void:
	persistent_score += points
	$CanvasLayer/ScoreLabel.text = "SCORE: " + str(persistent_score)

func _on_game_over() -> void:
	if _goal_pending or _resetting:
		return
	_lives -= 1
	$CanvasLayer/LifeDisplay.set_lives(_lives)
	if _lives < 0:
		$BGM.stop()
		$CanvasLayer/CenterContainer.show()
		return
	_resetting = true
	get_tree().create_timer(1.0).timeout.connect(func():
		$Ball.reset()
		get_tree().create_timer(0.3).timeout.connect(func():
			_resetting = false
		)
	)

func _on_restart_button_pressed() -> void:
	persistent_score = 0
	get_tree().reload_current_scene()
