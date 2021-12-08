extends KinematicBody

onready var Camera = get_node("Pivot/Camera")

var velocity = Vector3();
var gravity = -9.8
var speed = 0.2
var maxSpeed = 4
var mouseSense = 0.002
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
	$AnimationTree.set("parameters/Idle_Run/blend_amount", current_speed/maxSpeed)
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouseSense)
		
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
