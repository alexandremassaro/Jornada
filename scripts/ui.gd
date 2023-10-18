extends CanvasLayer


@onready var game_over_container = $GameOverContainer
@onready var score_label = $MarginContainer/PanelContainer/CenterContainer/HBoxContainer/ScoreLabel
@onready var timer_label = $MarginContainer/PanelContainer/CenterContainer/HBoxContainer/TimerLabel


func show_game_over():
	game_over_container.show()


func hide_game_over():
	game_over_container.hide()


func update_score(value):
	score_label.text = value


func update_timer(value):
	timer_label.text = value

