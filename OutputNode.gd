extends Spatial


onready var label = $Viewport/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func change_label_text(text):
	label.text = text
