extends CharacterBody2D
## Contém todos os métodos e propriedades do personagem principal do jogador.
##
## Controla o movimento, velocidade, animações e ações do personagem.
##

## A velocidade que personagem se move pela tela.
@export var move_speed : float = 65.0
@export var boost_speed : float = 100.00

## A posição que define qual animação será disparada quando a cena for 
## carregada pela primeira vez.
@export var starting_direction : Vector2 = Vector2(0, 1)


## Uma referência ao node AnimationTree.
## Esse node controla as animações do personagem.
@onready var animation_tree = $AnimationTree

## Uma referência ao state machine que define a animação 
## que está sendo tocada pelo AnimationTree.
@onready var state_machine = animation_tree["parameters/playback"]
@onready var cenoura_timer = $CenouraTimer


var is_cenoura_on = false


func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)


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
	
	if is_cenoura_on:
		velocity *= 2
	
	pick_new_state()
	move_and_slide()


## Atualiza o path do item sendo segurado pelo personagem, para fazer o personagem carregar o ítem.
func pick_up_item(item_path):
	$PickUpSpot.remote_path = item_path


## Apaga o path do item sendo segurado pelo personagem para soltar o item que está sendo carregado.
func drop_item():
	$PickUpSpot.remote_path = ""

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
	$PickUpSpot.position = pos * 10


func cenoura_start():
	is_cenoura_on = true
	cenoura_timer.start()


func cenoura_stop():
	is_cenoura_on = false


func _on_cenoura_timer_timeout():
	cenoura_stop()
