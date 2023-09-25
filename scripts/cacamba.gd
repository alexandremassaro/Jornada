extends StaticBody2D


@onready var animation_player = $AnimationPlayer


func abrir_tampa():
	animation_player.play("open")


func fechar_tampa():
	animation_player.play("close")


func _on_open_close_area_body_entered(body):
	if body.is_in_group("player"):
		abrir_tampa()


func _on_open_close_area_body_exited(body):
	if body.is_in_group("player"):
		fechar_tampa()
