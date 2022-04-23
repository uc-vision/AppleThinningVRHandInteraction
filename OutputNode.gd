extends Spatial


onready var grip_label = $Viewport/GripLabel
onready var other_label = $Viewport/OtherLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func change_grip_label_text(text):
	grip_label.text = text
	
func change_other_label_text(text):
	other_label.text = text
