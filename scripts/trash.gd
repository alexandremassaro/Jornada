extends Node2D
class_name Trash


@onready var interactive_area = $InteractiveArea
@onready var sprite_2d = $Sprite2D


var img_vidro = preload("res://resources/residuo_vidro.tres")
var img_madeira = preload("res://resources/residuo_madeira.tres")
var img_metal = preload("res://resources/residuo_metal.tres")
var img_pedra = preload("res://resources/residuo_pedra.tres")

var is_picked = false
var type : Global.trash_type = Global.trash_type.ENTULHO


func _ready():
	interactive_area.interact = Callable(self, "on_interact")
	type = randi() % Global.trash_type.size() as Global.trash_type
	set_image()


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


func set_image():
	sprite_2d.scale = Vector2(0.015, 0.015)
	match type:
		Global.trash_type.ENTULHO:
			sprite_2d.set_texture(img_pedra)
			sprite_2d.scale = Vector2(1, 1)
		Global.trash_type.MADEIRA:
			sprite_2d.set_texture(img_madeira)
		Global.trash_type.VIDRO:
			sprite_2d.set_texture(img_vidro)
		Global.trash_type.METAL:
			sprite_2d.set_texture(img_metal)

