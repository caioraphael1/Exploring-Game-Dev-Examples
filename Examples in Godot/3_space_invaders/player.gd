extends Sprite2D


@export var projectile: PackedScene

const SPEED = 250

func _process(delta: float) -> void:
	var direction := Input.get_vector(&'A', &'D', &'W', &'S')
	position += direction * delta * SPEED
	
	if Input.is_action_just_pressed(&'SPACE'):
		var proj := projectile.instantiate()
		get_parent().add_child(proj)
		proj.position = position
