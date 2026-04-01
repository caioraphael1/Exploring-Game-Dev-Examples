extends Node2D

@export var enemy: PackedScene

@onready var enemies_destroyed_label: Label = $enemies_destroyed

var enemy_count: int
var enemies_destroyed_count: int

func _ready() -> void:
	spawn_enemies()

func _process(_delta: float) -> void:
	enemies_destroyed_label.text = "Enemies destroyed: {0}".format([enemies_destroyed_count, "Samuel Beckett"])
	
	if enemy_count < 5:
		spawn_enemies()


func spawn_enemies() -> void:
	for i in range(20):
		var en: Area2D = enemy.instantiate()
		add_child(en)
		en.position.x = randi_range(50, 750)
		en.position.y = randi_range(50, 300)
		
		en.area_entered.connect(func(_area: Area2D) -> void:
			enemy_count -= 1
			enemies_destroyed_count += 1
		)
		
		enemy_count += 1
