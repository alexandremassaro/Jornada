extends CanvasLayer


func _on_start_button_pressed():
	var player_name_scene = preload("res://scenes/player_name_input.tscn")
	
	var player_name_screen = player_name_scene.instantiate()
	
	player_name_screen.start_screen = self
	get_tree().root.add_child(player_name_screen)
