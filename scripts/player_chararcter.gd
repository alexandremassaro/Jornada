extends CharacterBody2D

@export var move_speed = 200

@onready var direction_line = $AimLine

var carying : Trash = null
var items_in_range = []


func _ready():
	direction_line.default_color = Color.GREEN
	direction_line.width = 5.0


func _input(event):
	if event.is_action_released("pick_up_item"):
		pick_up()


func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
	
	velocity = move_speed * direction 
		
	move_and_slide()
	
	if carying:
		carying.global_position = $PickUpPosition.global_position
	
	look_at(get_global_mouse_position())


func _on_pick_up_area_area_entered(area):
	items_in_range.append(area.get_parent())
	print(items_in_range.size())


func _on_pick_up_area_area_exited(area):
	var item_index = items_in_range.find(area.get_parent())
	
	if item_index != -1:
		items_in_range.remove_at(item_index)
	
	print(items_in_range.size())


func pick_up():
	for item in items_in_range:
		carying = item
		break
	
	if carying:
		items_in_range.remove_at(items_in_range.find(carying))

