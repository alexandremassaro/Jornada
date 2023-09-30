extends Node2D
class_name Trash

enum trash_type {ENTULHO, VIDRO, METAL, MADEIRA}

@onready var interactive_area = $InteractiveArea

var is_picked = false


func _ready():
	interactive_area.interact = Callable(self, "on_interact")


func on_interact():
	var player = get_tree().get_first_node_in_group("player")
	if is_picked:
		player.drop_item()
		interactive_area.action_name = "pegar resíduo"
		is_picked = false
	else:
		player.pick_up_item(get_path())
		is_picked = true
		interactive_area.action_name = "soltar resíduo"

