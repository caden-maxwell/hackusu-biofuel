extends Control

@export_file("*.json") var d_file;

signal d_finished
var dialogue = []
var dia_id = 0
var d_active = false

func _ready():
	$NinePatchRect.visible = false
	
func start():
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	dia_id = -1
	next_script()

func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()
	
func load_dialogue():
	var file = FileAccess.open("res://dialogue/dialgoue.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func next_script():
	dia_id += 1
	if dia_id >= len(dialogue):
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("d_finished")
		return
		
	$NinePatchRect/Name.text = dialogue[dia_id]['name']
	$NinePatchRect/Text.text = dialogue[dia_id]['text']
