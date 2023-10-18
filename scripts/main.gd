extends Node2D

const DIFICULTY_INCREASE = .2

@export var trash_scene = preload("res://scenes/trash.tscn")
@export var start_spawn_rate = 10
@export var dificulty_increase_rate = 30

@onready var spawn_areas = $SpawnAreas
@onready var non_spawn_areas = $NonSpawnAreas
@onready var spawn_clock = $SpawnClock
@onready var dificulty_clock = $DificultyClock
@onready var countdown_clock = $CountdownClock
@onready var ui = $UI

var score = 0
var countdown_timer = 60


func _ready():
	randomize()
	spawn_clock.wait_time = start_spawn_rate
	dificulty_clock.wait_time = dificulty_increase_rate 
	spawn_trash()
	update_ui()


func _on_spawn_clock_timeout():
	spawn_trash()


func _on_dificulty_clock_timeout():
	spawn_clock.wait_time -= spawn_clock.wait_time * .2


func _on_countdown_clock_timeout():
	countdown()


func spawn_trash ():
	var spawn_area_index = 0
	
	if randf() < .1:
		spawn_area_index = 1
	
	var spawn_area_rect : Rect2 = spawn_areas.get_child(spawn_area_index).get_rect()
	var spawn_position = get_random_position(spawn_area_rect)
	
	while is_non_spawn_area(spawn_position):
		spawn_position = get_random_position(spawn_area_rect)
	
	var new_trash : Trash = trash_scene.instantiate()
	add_child(new_trash)
	new_trash.position = spawn_position


func get_random_position(rect : Rect2) -> Vector2:
	return rect.position + Vector2(
		randf() * rect.size.x, 
		randf() * rect.size.y
		)


func is_non_spawn_area(pos : Vector2) -> bool :
	for non_spawn_area in non_spawn_areas.get_children():
		var non_spawn_rect : Rect2 = non_spawn_area.get_rect()
		if non_spawn_rect.has_point(pos):
			return true
	
	return false


func increase_score():
	score += 1
	update_ui()


func decrease_score():
	score -= 1 if score > 0 else 0
	update_ui()


func countdown():
	countdown_timer -= 1
	update_ui()


func update_ui():	
	ui.update_score(str(score))
	ui.update_timer(str(countdown_timer))

