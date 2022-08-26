extends Spatial


onready var interaction1Mesh = $Interaction1/Area/MeshInstance
onready var interaction2Mesh = $Interaction2/Area/MeshInstance
onready var interaction3Mesh = $Interaction3/Area/MeshInstance

var selectedInteraction = 1
var previouslySelectedInteraction = 1

var interaction1Title = "Interaction style 1"
var interaction1Description = "This interaction uses an Area object in your palm to sense when your fingertips have entered this palm area and interpret this as a grip. To grip an object simply move your fingertips into your palms by bending your fingers."

var interaction2Title = "Interaction style 2"
var interaction2Description = "This interaction mechanic behaves similarly to the first, but uses the angle of your fingers to detect gripping. To grip an object simply bend your fingers."

var interaction3Title = "Interaction style 3"
var interaction3Description = "This interaction mechanic is quite different from the first two. This interaction uses areas on the fingertips to sense when they are interacting with objects. To grip an object simply make sure your thumb and at least one other finger is on or in the object you want to pick up. This can be easily achieved using a pinching motion."

func _ready():
	var material = interaction1Mesh.get_surface_material(0)
	material.albedo_color = Color(0, 1, 0)
	interaction1Mesh.set_surface_material(0, material)
	get_tree().root.get_node("Main/InformationNode/Viewport/TitleLabel").text = interaction1Title
	get_tree().root.get_node("Main/InformationNode/Viewport/BottomLabel").text = interaction1Description
	
func _process(delta):
	if selectedInteraction != previouslySelectedInteraction:
		var area = Area
		previouslySelectedInteraction = selectedInteraction
		match selectedInteraction:
			1:
				_on_interaction1_area_entered(area)
			2:
				_on_interaction2_area_entered(area)
			3:
				_on_interaction3_area_entered(area)
				

func _on_interaction1_area_entered(area):
	resetMeshes()
	var material = interaction1Mesh.get_surface_material(0)
	material.albedo_color = Color(0, 1, 0)
	interaction1Mesh.set_surface_material(0, material)
	selectedInteraction = 1
	get_tree().root.get_node("Main/InformationNode/Viewport/TitleLabel").text = interaction1Title
	get_tree().root.get_node("Main/InformationNode/Viewport/BottomLabel").text = interaction1Description


func _on_interaction2_area_entered(area):
	resetMeshes()
	var material = interaction2Mesh.get_surface_material(0)
	material.albedo_color = Color(0, 1, 0)
	interaction2Mesh.set_surface_material(0, material)
	selectedInteraction = 2
	get_tree().root.get_node("Main/InformationNode/Viewport/TitleLabel").text = interaction2Title
	get_tree().root.get_node("Main/InformationNode/Viewport/BottomLabel").text = interaction2Description

func _on_interaction3_area_entered(area):
	resetMeshes()
	var material = interaction3Mesh.get_surface_material(0)
	material.albedo_color = Color(0, 1, 0)
	interaction3Mesh.set_surface_material(0, material)
	selectedInteraction = 3
	get_tree().root.get_node("Main/InformationNode/Viewport/TitleLabel").text = interaction3Title
	get_tree().root.get_node("Main/InformationNode/Viewport/BottomLabel").text = interaction3Description
	
	
func resetMeshes():
	var material = interaction1Mesh.get_surface_material(0)
	material.albedo_color = Color(1, 1, 1)
	interaction1Mesh.set_surface_material(0, material)
	
	material = interaction2Mesh.get_surface_material(0)
	material.albedo_color = Color(1, 1, 1)
	interaction2Mesh.set_surface_material(0, material)
	
	material = interaction3Mesh.get_surface_material(0)
	material.albedo_color = Color(1, 1, 1)
	interaction3Mesh.set_surface_material(0, material)
