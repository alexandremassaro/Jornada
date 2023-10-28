extends CanvasLayer


@onready var line_edit : LineEdit = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/LineEdit

var start_screen = null


func _ready():
	line_edit.grab_focus()


func _on_line_edit_text_submitted(new_text):
	if str(new_text).strip_edges().is_empty():
		return
	
	LootLocker.authenticate_guest(str(new_text).strip_edges())
	
	var main_scene = preload("res://scenes/main.tscn")
	
	var main_screen = main_scene.instantiate()
	
	get_tree().root.add_child(main_screen)
	start_screen.queue_free()
	queue_free()


func _on_line_edit_text_changed(new_text):
	line_edit.text = str(new_text).to_upper()
	
	line_edit.caret_column = len(new_text)




