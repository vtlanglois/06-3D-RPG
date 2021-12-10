extends KinematicBody

onready var Dialogue = get_node("/root/Game/UI/Dialogue")


var dialogue = ["Hi!", "Shoot!", "Go!"]


func _ready():
	$AnimationPlayer.play("Idle")
	Dialogue.connect("finished_dialogue", self, "finished")
	


func _on_Area_body_entered(body):
	Dialogue.start_dialogue(dialogue)


func _on_Area_body_exited(body):
	Dialogue.hide_dialogue()
	
func finished():
	get_node("/root/Game/Target_Container").show()
	Global.timer = 120
	Global.update_time()
	get_node("/root/Game/UI/Timer").start()
