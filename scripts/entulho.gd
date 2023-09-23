extends Trash
class_name entulho


enum tipo {PEDRA, ALVENARIA, MADEIRA}

var tipo_de_entulho : tipo


func _ready():
	tipo_de_entulho = randi_range(0, 2)
