extends StaticBody2D
## Contém todos os métodos e propriedades do objeto caçamba.
##
## Controla as animações e ações do objeto caçamba.
##

signal score_increase
signal score_decrease

## Uma referência ao node AnimationPlayer.
@onready var animation_player = $AnimationPlayer
@onready var interactive_area = $InteractiveArea

var trash_reference : Trash = null

@export var type : Global.trash_type = Global.trash_type.ENTULHO

var texture_cacamba_entulho = preload("res://resources/cacamba_entulho.tres")
var texture_cacamba_vidro = preload("res://resources/cacamba_vidro.tres")
var texture_cacamba_madeira = preload("res://resources/cacamba_madeira.tres")
var texture_cacamba_metal = preload("res://resources/cacamba_metal.tres")


func _ready():
	interactive_area.interact = Callable(self, "on_interact")
	if type == Global.trash_type.ENTULHO:
		$Sprite2D.set_texture(texture_cacamba_entulho)
	elif type == Global.trash_type.VIDRO:
		$Sprite2D.set_texture(texture_cacamba_vidro)
	elif type == Global.trash_type.MADEIRA:
		$Sprite2D.set_texture(texture_cacamba_madeira)
	elif type == Global.trash_type.METAL:
		$Sprite2D.set_texture(texture_cacamba_metal)


func on_interact():
	if trash_reference:
		if trash_reference.type == type:
			score_increase.emit()
		else:
			score_decrease.emit()
		
		trash_reference.queue_free()
		trash_reference = null


func _on_interactive_area_body_entered(body):
	if body.is_in_group("player"):
		abrir_tampa()
		var trash_path = body.find_child("PickUpSpot").remote_path
		if trash_path:
			trash_reference = get_node(trash_path)


func _on_interactive_area_body_exited(body):
	if body.is_in_group("player"):
		fechar_tampa()
		trash_reference = null


## Toca a animação de abrir a tampa da caçamba.
func abrir_tampa():
	animation_player.play("open")


## Toca a animação de fechar a tampa da caçamba.
func fechar_tampa():
	animation_player.play("close")
