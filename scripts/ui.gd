extends CanvasLayer


@onready var game_over_bg = $GameOverBG
@onready var game_over_container = $GameOverContainer
@onready var pause_menu_bg = $PauseMenuBG
@onready var pause_menu_container = $PauseMenuContainer
@onready var score_label = $MarginContainer/PanelContainer/CenterContainer/HBoxContainer/ScoreLabel
@onready var timer_label = $MarginContainer/PanelContainer/CenterContainer/HBoxContainer/TimerLabel


var scoreboard_scene = preload("res://scenes/scoreboard.tscn")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not get_tree().paused:
			show_pause_menu()
			get_tree().paused = true
		else:
			hide_pause_menu()
			get_tree().paused = false


func _on_button_pressed():
	var scoreboard = scoreboard_scene.instantiate()
	var current_scene = get_current_scene()
	scoreboard.set_previous_scene(current_scene)
	get_tree().root.add_child(scoreboard)
	get_tree().root.remove_child(current_scene)


func _on_restart_pressed():
	var current_scene = get_current_scene()
	get_tree().current_scene = current_scene
	get_tree().reload_current_scene()
	get_tree().paused = false


func show_game_over():
	game_over_container.show()
	game_over_bg.show()


func hide_game_over():
	game_over_container.hide()
	game_over_bg.hide()


func show_pause_menu():
	pause_menu_container.show()
	pause_menu_bg.show()


func hide_pause_menu():
	pause_menu_container.hide()
	pause_menu_bg.hide()


func update_score(value):
	score_label.text = value


func update_timer(value):
	timer_label.text = value


func get_current_scene():
	return get_tree().root.get_child(get_tree().root.get_child_count() - 1)

