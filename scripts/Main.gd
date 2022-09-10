extends Spatial

onready var resetAreaMesh = $InteractionSelection/Reset/Area/MeshInstance
onready var resetArea = $InteractionSelection/Reset/Area
onready var canReset = true
onready var branchResourse = load("res://scenes/branch.tscn")
onready var tableApplesResourse = load("res://scenes/TableApples.tscn")

onready var branchContainer = $BranchContainer
onready var tableApplesContainer = $TableApplesContainer
onready var table = $Table
onready var stars = $Stars
onready var informationNode = $InformationNode
onready var dataNode = $DataNode
onready var dataCollectionNode = $DataCollectionConformation
var healthyApplesOnBranch
var totalApplesOnBranch
var totalApplesOnBranchAtStart
var damagedApplesAtStart

var interactionMechanicsAvaliable = [1, 2, 3, 1, 2, 3, 1, 2, 3]

var data = {
	1: {
		"times": [],
		"damagedPicked": [],
		"raitings": []
	},
	2: {
		"times": [],
		"damagedPicked": [],
		"raitings": []
	},
	3: {
		"times": [],
		"damagedPicked": [],
		"raitings": []
	}
}

var selectedInteractionMechanic
var removedInteractablesContainer
var leftHand
var rightHand

var completed = false

var collectingRating = false

var acceptedTerms = false



func _ready():
	healthyApplesOnBranch = getCountHealthyApples()
	totalApplesOnBranch = getCountTotalApples()
	totalApplesOnBranchAtStart = totalApplesOnBranch
	damagedApplesAtStart = getCountDamagedApples()
	
	#Choose interaction mechanic
	randomize()
	interactionMechanicsAvaliable.shuffle()
	next_interaction()
	
	removedInteractablesContainer = get_tree().root.get_node("Main/RemovedInteractables")
	
	leftHand = get_tree().root.get_node("Main/ARVROrigin/LeftHand")
	rightHand = get_tree().root.get_node("Main/ARVROrigin/RightHand")
	
	informationNode.visible = false
	dataNode.visible = false
	table.visible = false
	tableApplesContainer.visible = false
	branchContainer.visible = false



func _process(delta):
	if collectingRating or completed or not acceptedTerms: return
	healthyApplesOnBranch = getCountHealthyApples()
	totalApplesOnBranch = getCountTotalApples()
	if totalApplesOnBranch != totalApplesOnBranchAtStart:
		data[selectedInteractionMechanic]["times"][-1] = data[selectedInteractionMechanic]["times"][-1] + delta
		data[selectedInteractionMechanic]["damagedPicked"][-1] = damagedApplesAtStart - getCountDamagedApples()
		dataCollectionNode.visible = false
	if not completed:
		setInteractionTime()
		setInteractionMispicks()
		setInteractionRaiting()
	if healthyApplesOnBranch <= 0 and not leftHand.held_object and not rightHand.held_object:
		complete_section()
		

func complete_section():
	removeInteractables(removedInteractablesContainer)
	removeInteractables(branchContainer)
	removeInteractables(tableApplesContainer)
	removedInteractablesContainer.visible = false
	branchContainer.visible = false
	tableApplesContainer.visible = false
	table.visible = false
	stars.visible = true
	collectingRating = true
	
func next_interaction():
	selectedInteractionMechanic = interactionMechanicsAvaliable[0]
	interactionMechanicsAvaliable.remove(0)
	data[selectedInteractionMechanic]["times"].append(0)
	data[selectedInteractionMechanic]["damagedPicked"].append(0)
	data[selectedInteractionMechanic]["raitings"].append("")
	get_tree().root.get_node("Main/InteractionSelection").selectedInteraction = selectedInteractionMechanic

func getCountHealthyApples():
	var children = get_tree().root.get_node("Main/BranchContainer/branch").get_children()
	var countChildren = 0
	for child in children:
		if child.get_groups().has("HealthyLarge") or child.get_groups().has("HealthySmall"):
				countChildren += 1
	return countChildren


func getCountTotalApples():
	var children = get_tree().root.get_node("Main/BranchContainer/branch").get_children()
	var countChildren = 0
	for child in children:
		if child.get_groups().has("Apple"):
				countChildren += 1
	return countChildren


func getCountDamagedApples():
	var children = get_tree().root.get_node("Main/BranchContainer/branch").get_children()
	var countChildren = 0
	for child in children:
		if child.get_groups().has("Damaged"):
				countChildren += 1
	return countChildren


func _on_reset_area_entered(area):
	var material = resetAreaMesh.get_surface_material(0)
	material.albedo_color = Color(1, 0, 0)
	resetAreaMesh.set_surface_material(0, material)
	
	if canReset:
		removeInteractables(removedInteractablesContainer)
		removeInteractables(branchContainer)
		removeInteractables(tableApplesContainer)
		addInteractables()
		canReset = false
		


func _on_reset_area_exited(area):
	if resetArea.get_overlapping_areas().size() == 0:
		var material = resetAreaMesh.get_surface_material(0)
		material.albedo_color = Color(1, 1, 1)
		resetAreaMesh.set_surface_material(0, material)
		canReset = true


func addInteractables():
	branchContainer.add_child(branchResourse.instance())
	tableApplesContainer.add_child(tableApplesResourse.instance())

func removeInteractables(container: Spatial):
	for n in container.get_children():
		container.remove_child(n)
		n.free()

		
func setInteractionTime():
	var node = get_node("DataNode/Viewport/Interaction" + selectedInteractionMechanic as String + "Time")
	var times = data[selectedInteractionMechanic]["times"]
	var string = ""
	for time in times: string += "Time: " + stepify(time, 0.01) as String + "s\n"
	node.text = string
	#if node.text == "Time:":
	#	node.text = "Time: " + stepify(timeTaken, 0.01) as String + "s"
	#else:
	#	node.text += "\nTime: " + stepify(timeTaken, 0.01) as String + "s"

func setInteractionMispicks():
	var node = get_node("DataNode/Viewport/Interaction" + selectedInteractionMechanic as String + "Mispicks")
	
	var damagedPicked = data[selectedInteractionMechanic]["damagedPicked"]
	var string = ""
	for indDamagedPicked in damagedPicked: string += "Mispicks: " + indDamagedPicked as String + "\n"
	node.text = string

func setInteractionRaiting():
	var node = get_node("DataNode/Viewport/Interaction" + selectedInteractionMechanic as String + "Raiting")
	
	var raitings = data[selectedInteractionMechanic]["raitings"]
	var string = ""
	for raiting in raitings: string += "Raiting: " + raiting as String + "\n"
	node.text = string


func _on_StarOK_area_entered(area):
	if stars.currentSelection == 0: return
	data[selectedInteractionMechanic]["raitings"][-1] = stars.currentSelection
	setInteractionRaiting()
	if interactionMechanicsAvaliable.size() == 0:
		stars.reset_stars()
		stars.visible = false
		collectingRating = false
		completed = true
		get_tree().root.get_node("Main/InformationNode/Viewport/TitleLabel").text = ""
		get_tree().root.get_node("Main/InformationNode/Viewport/BottomLabel").text = "Thank you for trying out this demo, If you have any other comments on the interaction mechanics tried please don't hesitate to leave a comment where you found this demo,\n\nAgain, your time taken data, mispicks, and raiting have been sent to me to decide on the prefered interaction mechanic"
	else:
		
		stars.reset_stars()
		addInteractables()
		removedInteractablesContainer.visible = true
		branchContainer.visible = true
		tableApplesContainer.visible = true
		table.visible = true
		stars.visible = false
		collectingRating = false
		next_interaction()
	


func _on_StartButton_area_entered(area):
	$DataCollectionConformation.visible = false
	
	informationNode.visible = true
	dataNode.visible = true
	table.visible = true
	tableApplesContainer.visible = true
	branchContainer.visible = true
	
	acceptedTerms = true
