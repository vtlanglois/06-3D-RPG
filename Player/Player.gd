extends KinematicBody

onready var Camera = get_node("Pivot/Camera")
onready var Pivot = get_node("Pivot")

var velocity = Vector3();
var gravity = -9.8
var speed = 0.2
var maxSpeed = 4
var mouseSense = 0.002

var target = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	velocity.y += gravity * delta
	var falling = velocity.y
	velocity.y = 0
	var desired_velocity = get_input() * speed
	if desired_velocity.length(): 
		velocity += desired_velocity
	else:
		velocity *= 0.9
	var current_speed = velocity.length()
	velocity = velocity.normalized() * clamp(current_speed, 0, maxSpeed)
	velocity.y = falling
	$AnimationTree.set("parameters/Idle_Run/blend_amount", current_speed)
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if (Input.is_action_just_pressed("shoot")) and target != null and target.is_in_group("target"):
		Global.update_score()
		target.die()
		
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouseSense)
		Pivot.rotate_x(-event.relative.y * mouseSense)
		Pivot.rotation_degrees.x = clamp(Pivot.rotation_degrees.x, -30, 15)
		
func get_input():
	var input_dir = Vector3();
	if Input.is_action_pressed("forward"):
		input_dir -= Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir -= Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir


func _on_Timer_timeout():
	pass # Replace with function body.
