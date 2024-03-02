extends CharacterBody2D

enum CHAR_STATE { IDLE, RUN, SIT, DRINK }

@export var move_speed : float = 20
@export var walk_time : float = 2
@export var current_state : CHAR_STATE = CHAR_STATE.IDLE
@export var changes_state : bool = false

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var timer = $Timer

var move_direction : Vector2 = Vector2.ZERO


func _ready():
	pick_new_state()
	move()

func move():
	if changes_state:
		pick_new_state()
		select_new_direction()
	timer.start(walk_time)

func _physics_process(_delta):
	if(current_state == CHAR_STATE.RUN):
		velocity = move_direction * move_speed
		move_and_slide()

func select_new_direction():
	move_direction = Vector2(
		randf_range(-1,1),
		randf_range(-1,1)
	)
	update_animation_param(move_direction)


func update_animation_param(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Run/blend_position", move_input)
		animation_tree.set("parameters/Sit/blend_position", move_input[0])

# For switching between Idle and Run
func pick_new_state():
	var new_state : CHAR_STATE = randi_range(0, CHAR_STATE.size())
	current_state = new_state
	
	if(current_state == CHAR_STATE.IDLE):
		state_machine.travel("Idle")
	elif(current_state == CHAR_STATE.RUN):
		state_machine.travel("Run")
	elif(current_state == CHAR_STATE.SIT):
		state_machine.travel("Sit")
	elif(current_state == CHAR_STATE.DRINK):
		state_machine.travel("Drink")

func _on_timer_timeout():
	move()
