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

var interactionMechanicsAvaliable = [1, 2, 3]
var timesTaken = [-1, -1, -1]
var damagedApplesPicked = [-1, -1, -1]
var raitings = [-1, -1, -1]
var selectedInteractionMechanic
var removedInteractablesContainer
var leftHand
var rightHand

var completed = false

var collectingRating = false


func _ready():
	healthyApplesOnBranch = getCountHealthyApples()
	totalApplesOnBranch = getCountTotalApples()
	totalApplesOnBranchAtStart = totalApplesOnBranch
	damagedApplesAtStart = getCountDamagedApples()
	
	#Choose interaction mechanic
	randomize()
	interactionMechanicsAvaliable.shuffle()
	selectedInteractionMechanic = interactionMechanicsAvaliable[0]
	interactionMechanicsAvaliable.remove(0)
	get_tree().root.get_node("Main/InteractionSelection").selectedInteraction = selectedInteractionMechanic
	
	removedInteractablesContainer = get_tree().root.get_node("Main/RemovedInteractables")
	
	leftHand = get_tree().root.get_node("Main/ARVROrigin/LeftHand")
	rightHand = get_tree().root.get_node("Main/ARVROrigin/RightHand")

var timeTaken = 0

func _process(delta):
	if collectingRating or completed: return
	healthyApplesOnBranch = getCountHealthyApples()
	totalApplesOnBranch = getCountTotalApples()
	if totalApplesOnBranch != totalApplesOnBranchAtStart:
		timeTaken += delta
		dataCollectionNode.visible = false
	if not completed:
		setInteractionTime()
		setInteractionMispicks()
	if healthyApplesOnBranch <= 0 and not leftHand.held_object and not rightHand.held_object:
		complete_section()
		

func complete_section():
	timesTaken[selectedInteractionMechanic-1] = timeTaken
	damagedApplesPicked[selectedInteractionMechanic-1] = damagedApplesAtStart - getCountDamagedApples()
	timeTaken = 0
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
	get_node("DataNode/Viewport/Interaction" + selectedInteractionMechanic as String + "Time").text = "Time: " + stepify(timeTaken, 0.01) as String + "s"

func setInteractionMispicks():
	get_node("DataNode/Viewport/Interaction" + selectedInteractionMechanic as String + "Mispicks").text = "Mispicks: " + (damagedApplesAtStart - getCountDamagedApples()) as String

func setInteractionRaiting(raiting):
	get_node("DataNode/Viewport/Interaction" + selectedInteractionMechanic as String + "Raiting").text = "Raiting: " + raiting as String



func _on_StarOK_area_entered(area):
	if stars.currentSelection == 0: return
	if interactionMechanicsAvaliable.size() == 0:
		raitings[selectedInteractionMechanic-1] = stars.currentSelection
		setInteractionRaiting(stars.currentSelection)
		stars.reset_stars()
		stars.visible = false
		collectingRating = false
		completed = true
		get_tree().root.get_node("Main/InformationNode/Viewport/TitleLabel").text = ""
		get_tree().root.get_node("Main/InformationNode/Viewport/BottomLabel").text = "Thank you for trying out this demo, If you have any other comments on the interaction mechanics tried please don't hesitate to leave a comment where you found this demo,\n\nAgain, your time taken data, mispicks, and raiting have been sent to me to decide on the prefered interaction mechanic"
	else:
		raitings[selectedInteractionMechanic-1] = stars.currentSelection
		setInteractionRaiting(stars.currentSelection)
		stars.reset_stars()
		addInteractables()
		removedInteractablesContainer.visible = true
		branchContainer.visible = true
		tableApplesContainer.visible = true
		table.visible = true
		stars.visible = false
		collectingRating = false
		next_interaction()
	
