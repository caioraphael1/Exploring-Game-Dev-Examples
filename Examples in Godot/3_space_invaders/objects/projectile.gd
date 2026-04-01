extends Area2D


const SPEED = 400

func _ready() -> void:
	area_entered.connect(func(_area: Area2D) -> void:
		queue_free()
	)


func _physics_process(delta: float) -> void:
	position.y -= delta * SPEED
	
	if position.y < 0:
		queue_free()
