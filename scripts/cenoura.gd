extends Node2D

signal cenoura


@onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("hover")


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("cenoura")
		queue_free()

