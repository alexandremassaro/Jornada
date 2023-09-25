extends CharacterBody2D

@export var move_speed : float = 50.0

var carying : Trash = null
var items_in_range = []

@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]


func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)


func _input(event):
	if event.is_action_released("pick_up_item"):
		drop_item()
		pick_up_item()


func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
	
	if input_direction != Vector2.ZERO:
		update_animation_parameters(input_direction)
		change_pick_up_position(input_direction)
	
	# Update velocity
	velocity = input_direction * move_speed
	
	pick_new_state()
		
	move_and_slide()
	
	if carying:
		carying.global_position = $PickUpPosition.global_position


func _on_pick_up_area_area_entered(area):
	var item  = area.get_parent()
	if item is Trash:
		items_in_range.append(area.get_parent())


func _on_pick_up_area_area_exited(area):
	var item_index = items_in_range.find(area.get_parent())
	
	if item_index != -1:
		items_in_range.remove_at(item_index)
	
	# print(items_in_range.size())


func pick_up_item():
	for item in items_in_range:
		carying = item
		break
	
	if carying:
		items_in_range.remove_at(items_in_range.find(carying))


func drop_item():
	carying = null


func update_animation_parameters(move_input : Vector2):
	# Don't update if there is no user input
	if not move_input == Vector2.ZERO: 
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input)


func pick_new_state():
	if not velocity == Vector2.ZERO:
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")


func change_pick_up_position(pos : Vector2):
	$PickUpPosition.position = pos * 10
