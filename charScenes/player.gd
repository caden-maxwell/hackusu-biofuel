extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)


@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_param(starting_direction)

func _input(event):
	if event.is_action_pressed("attack"):
		$HitSound.play()

func _physics_process(_delta):
	# input
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_param(input_direction)
	
	velocity = input_direction * move_speed
	
	move_and_slide()
	pick_state()

func update_animation_param(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Run/blend_position", move_input)

func pick_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Run")
	else:
		state_machine.travel("Idle")
