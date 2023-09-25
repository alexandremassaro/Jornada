extends CharacterBody2D
## Contém todos os métodos e propriedades do personagem principal do jogador.
##
## Controla o movimento, velocidade, animações e ações do personagem.
##

## A velocidade que personagem se move pela tela.
@export var move_speed : float = 50.0

## A posição que define qual animação será disparada quando a cena for 
## carregada pela primeira vez.
@export var starting_direction : Vector2 = Vector2(0, 1)

## O objeto que o personagem principal está segurando.
## Deve ser do tipo Trash, ou nulo.
var carying : Trash = null

## Uma lista de todos os items que o personagem pricipal pode agarrar. 
## FIFO. O personagem vai pegar o primeiro item dessa lista.
var items_in_range = []

## Uma referência ao node AnimationTree.
## Esse node controla as animações do personagem.
@onready var animation_tree = $AnimationTree

## Uma referência ao state machine que define a animação 
## que está sendo tocada pelo AnimationTree.
@onready var state_machine = animation_tree["parameters/playback"]


func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)


func _input(event):
	if event.is_action_released("pick_up_item"):
		if carying:
			drop_item()
		else:
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


## Pega o primeiro item da lista items_in_range.[br]
## [color=yellow]Aviso:[/color] Sempre se certifique que a propriedade 'carying'
## é null antes de chamar esse método, senão ele nunca conseguirá soltar o item.
func pick_up_item():
	if len(items_in_range) > 0:
		carying = items_in_range[0]


## Solta o item que está sendo carregado.
func drop_item():
	carying = null

## Atualiza o node AnimationTree para alternar as animações de acordo com a 
## direção do movimento e o input do jogador (direita, esquerda, cima e baixo).
## Altera a direção que o personagem está olhando.
func update_animation_parameters(move_input : Vector2):
	# Don't update if there is no user input
	if move_input != Vector2.ZERO: 
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input)


## Atualiza o state machine que controla as animações para que alterne 
## entre as animações idle (parado) ou walk (andando).
func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")


## Atualiza a posição do item sendo carregado para que fique sempre 
## a frente do personagem principal.
func change_pick_up_position(pos : Vector2):
	$PickUpPosition.position = pos * 10
