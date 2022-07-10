extends Spatial

onready var mechanic1LeftHand = null
onready var mechanic1RightHand = null

onready var mechanic2LeftHand = null
onready var mechanic2RightHand = null

onready var mechanic3LeftHand = null
onready var mechanic3RightHand = null

onready var leftHand = $ARVROrigin/LeftHand
onready var rightHand = $ARVROrigin/RightHand


var timeSinceLast = 0
var mechanic = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	mechanic1LeftHand = load("res://interactionMechanics/InteractionMechanic1LeftHand.tscn")
	mechanic1RightHand = load("res://interactionMechanics/InteractionMechanic1RightHand.tscn")
	
	mechanic2LeftHand = load("res://interactionMechanics/InteractionMechanic2LeftHand.tscn")
	mechanic2RightHand = load("res://interactionMechanics/InteractionMechanic2RightHand.tscn")

	mechanic3LeftHand = load("res://interactionMechanics/InteractionMechanic3LeftHand.tscn")
	mechanic3RightHand = load("res://interactionMechanics/InteractionMechanic3RightHand.tscn")
	
	
	leftHand.add_child(mechanic1LeftHand)
	rightHand.add_child(mechanic1RightHand)
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
