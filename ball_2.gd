extends Area2D

var speed = 20

func _physics_process(delta):
	position.y -= speed


#lled when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
