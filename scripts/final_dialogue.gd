extends CanvasLayer


@onready var dialogue_label = %DialogueLabel
@onready var responde_form_label = %RespondeFormLabel
@onready var dialogue_commands = %DialogueCommands
@onready var escape_label = %EscapeLabel
@onready var next_dialogue_label = %NextDialogueLabel

var dialogue = [
	"Ufa, {player_name}! Conseguimos\n
	recolher muitos resíduos, mas a luta\n 
	contra o descarte incorreto não acaba\n
	aqui. Sozinho, eu não dou conta de\n
	resolver tudo. É fundamental que\n
	todos façam sua parte!",
	"Você sabia que o descarte correto\n
	dos resíduos é super importante para\n
	proteger nosso meio ambiente?\n
	A Resolução CONAMA Nº 307 estabelece\n
	regras para que os resíduos de \n
	construção sejam descartados de forma\n
	segura e sustentável.",
	"Quando descartamos tudo corretamente,\n
	ajudamos a preservar a natureza e\n
	garantimos um futuro melhor para todos.\n
	Mas eu não posso fazer isso sozinho,\n
	preciso de você e de todos à nossa volta!",
	"Então, {player_name}, eu te peço:\n
	converse com seus amigos, sua família e\n
	todos que puder. Ensine-os sobre a\n
	importância do descarte correto e sobre\n
	a Resolução CONAMA. Vamos juntos criar\n
	uma onda de consciência e ação!",
	"Cada pequena atitude conta, e com a\n
	ajuda de todos, podemos fazer uma grande\n
	diferença. Obrigado por jogar e por se\n
	importar, {player_name}! Você é um\n
	verdadeiro herói ambiental!"
]

var form_dialogue = "
	Uau, você foi incrível, {player_name}!\n
	Agora que nossa jornada chegou ao fim,\n
	você poderia responder outro\n
	formulário para mim? Suas respostas\n
	são super importantes para que eu\n
	possa aprender e melhorar para a\n
	próxima vez. Muito obrigado por sua\n 
	ajuda e por se importar com nossa ilha!
"

var ui_screen = null
var current_dialogue = -1
var form_url = "https://docs.google.com/forms/d/e/1FAIpQLSdtco5rvl-ATmqQaeSsV6JiWe1NTsn6l4VSGy_GaV3ROG8g6A/viewform?usp=pp_url&entry.1413972473={session_token}"


func _ready():
	next_dialogue()
	LootLocker.get_all_key_value_pairs()


func _process(_delta):
	if LootLocker.finished_form_request:
		escape_label.text = "APERTE [ESC] PARA PULAR DIÁLOGO"
		next_dialogue_label.show()
		next_dialogue_label.text = "APERTE [ESPAÇO] PARA CONTINUAR"


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		end_dialogue()
	elif event.is_action_pressed("ui_select"):
		next_dialogue()


func next_dialogue():
	current_dialogue += 1
	if current_dialogue < dialogue.size():
		dialogue_label.text = dialogue[current_dialogue].format({"player_name":LootLocker.player_id})
	else:
		end_dialogue()


func end_dialogue():
	if not LootLocker.finished_form_request:
		next_dialogue_label.hide()
		escape_label.text = "AGUARDE ESTAMOS CARREGANDO INFORMAÇÕES"
		return
	
	if not responde_form_label.visible and not LootLocker.form2_status:
		responde_form_label.text = form_dialogue.format({"player_name":LootLocker.player_id})
		responde_form_label.show()
		dialogue_label.hide()
	else:
		if not LootLocker.form2_status:
			var url = form_url.format({"session_token":LootLocker.session_token})
			if OS.get_name() == "HTML5" or OS.has_feature("web"):
				JavaScriptBridge.eval("window.open('{url}', '_form2').focus();".format({"url":url}))
			else:
				OS.shell_open(url)
				
#			if OS.get_name() == "HTML5" or OS.has_feature("web"):
#				JavaScriptBridge.eval("window.open('%s', '_blank').focus();" % url)
#			else:
#				OS.shell_open(url)
	
		ui_screen.show_game_over()
		queue_free()

