extends CanvasLayer

@onready var line_edit = %LineEdit
@onready var dialogue_label = %DialogueLabel
@onready var dialogue_commands = %DialogueCommands
@onready var responde_form_label = %RespondeFormLabel
@onready var next_dialogue_label = %NextDialogueLabel
@onready var escape_label = %EscapeLabel

var dialogue = [
	"Oi! Meu nome é Benício, \n
	e eu sou um gatoelho, \n
	uma mistura fofa de gato \n
	e coelho! E o seu nome, \n
	qual é?",
	"Muito prazer, {player_name}! \n
	Preciso muito da sua ajuda. \n
	Restos de obras estão aparecendo \n
	na minha ilha, e isso é muito \n
	ruim para o meio ambiente. Você \n
	pode me ajudar a recolher esses \n
	resíduos e colocá-los nas \n
	caçambas certas?",
	"Use as teclas [W], [A], [S] e [D] \n
	para se mover, e a tecla [E] para \n
	pegar ou soltar os resíduos. \n
	Precisamos ser rápidos! \n
	Cada resíduo tem sua caçamba certa: \n
	pedra e alvenaria na preta, \n
	vidro na azul, madeira na laranja, \n
	e metal na vermelha.",
	"Ah, e fique de olho nas cenouras! \n
	Se você tocar em uma, vai ficar \n
	super rápido! Vamos lá, \n
	{player_name}, eu sei que \n
	podemos fazer isso juntos \n
	e cuidar da nossa ilha!"
]


var form_dialogue = "
	Ah, antes de começarmos \n
	nossa aventura, você pode \n
	responder a um \n
	formulário rápido? Isso vai \n
	me ajudar a entender \n
	como posso melhorar e \n
	tornar nossa jornada \n
	ainda mais incrível! Muito \n
	obrigado, {player_name}!
"
var start_screen = null
var current_dialogue = 0
var player_name = ""
var form_url = "https://docs.google.com/forms/d/e/1FAIpQLSf698M1FpoAiOGtbrqv4P7HYTwJC3EFvT66x5J54UV1oOb8DQ/viewform?usp=pp_url&entry.483982770={player_name}"

func _ready():
	line_edit.grab_focus()


func _process(_delta):
	if LootLocker.finished_form_request:
		escape_label.text = "APERTE [ESC] PARA PULAR DIÁLOGO"
		next_dialogue_label.show()
		next_dialogue_label.text = "APERTE [ESPAÇO] PARA CONTINUAR"


func _input(event):
	if dialogue_commands.visible:
		if event.is_action_pressed("ui_select"): 
			next_dialogue()
		elif event.is_action_pressed("ui_cancel"):
			start_game()
	elif responde_form_label.visible:
		if event.is_action_pressed("ui_select") or event.is_action_pressed("ui_cancel"):
			start_game()


func _on_line_edit_text_submitted(new_text):
	if str(new_text).strip_edges().is_empty():
		return
	
	player_name = str(new_text).strip_edges()
	LootLocker.authenticate_guest(player_name)
	
	line_edit.hide()
	dialogue_commands.show()
	dialogue_commands.grab_focus()
	next_dialogue()


func _on_line_edit_text_changed(new_text):
	line_edit.text = str(new_text).to_upper()
	
	line_edit.caret_column = len(new_text)


func next_dialogue():
	current_dialogue += 1
	if current_dialogue < dialogue.size():
		dialogue_label.text = dialogue[current_dialogue].format({"player_name":player_name})
	else:
		start_game()


func start_game():
	if not LootLocker.finished_form_request:
		next_dialogue_label.hide()
		escape_label.text = "AGUARDE ESTAMOS CARREGANDO INFORMAÇÕES"
		return
		
	if not responde_form_label.visible and not LootLocker.form1_status:
		responde_form_label.text = form_dialogue.format({"player_name":player_name})
		responde_form_label.show()
		dialogue_label.hide()
	else:
		if not LootLocker.form1_status:
			var url = form_url.format({"player_name":LootLocker.session_token})
			if OS.get_name() == "HTML5" or OS.has_feature("web"):
				JavaScriptBridge.eval("window.open('%s', '_blank').focus();" % url)
			else:
				OS.shell_open(url)
		
		var main_scene = preload("res://scenes/main.tscn")
		var main_screen = main_scene.instantiate()
		
		get_tree().root.add_child(main_screen)
		start_screen.queue_free()
		queue_free()

