extends CharacterBody2D

enum CHAR_STATE { IDLE, RUN, SIT, DRINK }

@export var move_speed : float = 20

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var move_direction : Vector2 = Vector2.ZERO
var current_state : CHAR_STATE = CHAR_STATE.IDLE

func _ready():
	select_new_direction()
	pick_new_state(CHAR_STATE.RUN)

func _physics_process(_delta):
	velocity = move_direction * move_speed
	move_and_slide()

func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	update_animation_param(move_direction)


func update_animation_param(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Run/blend_position", move_input)
		animation_tree.set("parameters/Sit/blend_position", move_input[0])


# For switching between Idle and Run
func pick_new_state(state : CHAR_STATE):
	current_state = state
	if(state == CHAR_STATE.IDLE):
		state_machine.travel("Idle")
	elif(state == CHAR_STATE.RUN):
		state_machine.travel("Run")
	elif(state == CHAR_STATE.SIT):
		state_machine.travel("Sit")
	elif(state == CHAR_STATE.DRINK):
		state_machine.travel("Drink")
