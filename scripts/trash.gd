extends Node2D
class_name Trash


@onready var interactive_area = $InteractiveArea

var is_picked = false
var type : Global.trash_type = Global.trash_type.ENTULHO


func _ready():
	interactive_area.interact = Callable(self, "on_interact")
	type = randi() % Global.trash_type.size() as Global.trash_type
	
	match type:
		Global.trash_type.ENTULHO:
			modulate = Color.BLACK
		Global.trash_type.MADEIRA:
			modulate = Color.ORANGE
		Global.trash_type.VIDRO:
			modulate = Color.CYAN
		Global.trash_type.METAL:
			modulate = Color.RED


func on_interact():
	var player = get_tree().get_first_node_in_group("player")
	if is_picked:
		player.drop_item()
		interactive_area.action_name = "pegar resíduo"
		is_picked = false
	else:
		player.pick_up_item(get_path())
		interactive_area.action_name = "soltar resíduo"
		is_picked = true

