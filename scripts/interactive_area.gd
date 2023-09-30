class_name InteractiveArea extends Area2D


@export var action_name : String = "interact"


var interact : Callable = func(): pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		InteractionManager.register_area(self)


func _on_body_exited(_body):
	InteractionManager.unregister_area(self)
