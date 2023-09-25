extends StaticBody2D
## Contém todos os métodos e propriedades do objeto caçamba.
##
## Controla as animações e ações do objeto caçamba.
##

## Uma referência ao node AnimationPlayer.
@onready var animation_player = $AnimationPlayer


func _on_open_close_area_body_entered(body):
	if body.is_in_group("player"):
		abrir_tampa()


func _on_open_close_area_body_exited(body):
	if body.is_in_group("player"):
		fechar_tampa()


## Toca a animação de abrir a tampa da caçamba.
func abrir_tampa():
	animation_player.play("open")


## Toca a animação de fechar a tampa da caçamba.
func fechar_tampa():
	animation_player.play("close")
