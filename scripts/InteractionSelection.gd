extends Spatial


var selectedInteraction = 1
var previouslySelectedInteraction = null


var interactionDescriptions = [
	"This interaction uses an Area object in your palm to sense when your fingertips have entered this palm area and interpret this as a grip. To grip an object simply move your fingertips into your palms by bending your fingers.\n\nRemember you can use both hands!\n\nPick off all of the Green Apples while leaving the Red Apples",
	"This interaction mechanic uses the angle of your fingers to detect gripping. To grip an object simply bend your fingers.\n\nRemember you can use both hands!\n\nPick off all of the Green Apples while leaving the Red Apples",
	"This interaction mechanic uses areas on the fingertips to sense when they are interacting with objects. To grip an object simply make sure your thumb and at least one other finger is on or in the object you want to pick up. This can be easily achieved using a pinching motion.\n\nRemember you can use both hands!\n\nPick off all of the Green Apples while leaving the Red Apples"]

func _ready():
	get_tree().root.get_node("Main/InformationNode/Viewport/TitleLabel").text = "s"
	get_tree().root.get_node("Main/InformationNode/Viewport/BottomLabel").text = ""
	
func _process(delta):
	if selectedInteraction != previouslySelectedInteraction:
		var area = Area
		previouslySelectedInteraction = selectedInteraction
		setTitle()
		setDescription(selectedInteraction)
				


func setTitle():
	get_tree().root.get_node("Main/InformationNode/Viewport/TitleLabel").text = "Interaction Style " + selectedInteraction as String
	
func setDescription(interactionNumber):
	get_tree().root.get_node("Main/InformationNode/Viewport/BottomLabel").text = interactionDescriptions[interactionNumber-1]
