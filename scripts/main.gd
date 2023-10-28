extends Node2D

const CENOURA_SPAWN_RATE = 0.00035

@export var trash_scene = preload("res://scenes/trash.tscn")
@export var cenoura_scene =preload("res://scenes/cenoura.tscn")
@export var start_spawn_rate = 10
@export var countdown_timer = 60

@onready var spawn_areas = $SpawnAreas
@onready var non_spawn_areas = $NonSpawnAreas
@onready var spawn_clock = $SpawnClock
@onready var countdown_clock = $CountdownClock
@onready var ui = $UI
@onready var player_chararcter = $player_chararcter

var score = 0
var is_new_record = false


func _ready():
	randomize()
	spawn_clock.wait_time = start_spawn_rate
	spawn_trash()
	update_ui()
	Global.get_current_record()


func _process(_delta):
	if randf() < CENOURA_SPAWN_RATE:
		spawn_cenoura()
	
	var trash_count = get_tree().get_nodes_in_group("trash").size()
	spawn_clock.wait_time = 10.0 / (trash_count if trash_count > 0 else 1)
	var spawn_clock_label = $SpawnClockLabel
	spawn_clock_label.text = str(spawn_clock.wait_time)

	countdown_clock.wait_time = 1.0 / (trash_count if trash_count > 0 else 1)
	var countdown_clock_label = $CountdownClockLabel
	countdown_clock_label.text = str(countdown_clock.wait_time)



func _on_spawn_clock_timeout():
	spawn_trash()


func _on_countdown_clock_timeout():
	countdown()


func _on_time_played_clock_timeout():
	Global.increase_time_played()


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


func spawn_cenoura ():
	var spawn_area_index = 0
	
	if randf() < .1:
		spawn_area_index = 1
	
	var spawn_area_rect : Rect2 = spawn_areas.get_child(spawn_area_index).get_rect()
	var spawn_position = get_random_position(spawn_area_rect)
	
	while is_non_spawn_area(spawn_position):
		spawn_position = get_random_position(spawn_area_rect)
	
	var new_cenoura = cenoura_scene.instantiate()
	add_child(new_cenoura)
	new_cenoura.position = spawn_position
	new_cenoura.connect("cenoura", cenoura_start)


func cenoura_start():
	player_chararcter.cenoura_start()


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
	var trash_count = get_tree().get_nodes_in_group("trash").size()
	score += trash_count if trash_count > 0 else 1
	
	countdown_timer += 10 / trash_count
	print(Global.record_score)
	if score > Global.record_score:
		is_new_record = true
		Global.set_record_score(score)
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
	if countdown_timer <= 0:
		game_over()


func game_over():
	ui.show_game_over()
	print(is_new_record)
	if is_new_record:
		LootLocker.submit_highscore(Global.record_score)
		is_new_record = false
	get_tree().paused = true

