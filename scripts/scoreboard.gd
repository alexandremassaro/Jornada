extends CanvasLayer

var previous_scene = null


func _ready():
	get_tree().paused = false
	load_scoreboard()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().root.remove_child(self)


func _on_tree_exiting():
	if previous_scene:
		get_tree().paused = true
		get_tree().root.add_child.call_deferred(previous_scene)
		queue_free()


func load_scoreboard():
	await Global.update_scoreboard()
	add_score_entry("Rank", "Nome", "Score")
	for score in Global.scoreboard:
		add_score_entry(score.player_rank, score.player_name, score.player_score)


func add_score_entry(player_rank, player_name, player_score):
	var entries = find_child("Entries")
	
	entries.add_child(entry_label(player_rank))
	entries.add_child(entry_label(player_name))
	entries.add_child(entry_label(player_score))


func entry_label(text):
	var label_value : Label = Label.new()
	label_value.text = str(text)
	label_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label_value.uppercase = true
	return label_value


func set_previous_scene(scene):
	previous_scene = scene

