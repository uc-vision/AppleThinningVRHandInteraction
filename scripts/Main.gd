extends Spatial

onready var resetAreaMesh = $InteractionSelection/Reset/Area/MeshInstance
onready var resetArea = $InteractionSelection/Reset/Area
onready var canReset = true
onready var interactablesResourse = load("res://scenes/Interactables.tscn")

onready var interactablesContainer = $InteractablesContainer


func _on_reset_area_entered(area):
	var material = resetAreaMesh.get_surface_material(0)
	material.albedo_color = Color(1, 0, 0)
	resetAreaMesh.set_surface_material(0, material)
	
	if canReset:
		removeInteractables()
		addInteractables()
		canReset = false
		


func _on_reset_area_exited(area):
	if resetArea.get_overlapping_areas().size() == 0:
		var material = resetAreaMesh.get_surface_material(0)
		material.albedo_color = Color(1, 1, 1)
		resetAreaMesh.set_surface_material(0, material)
		canReset = true


func addInteractables():
	interactablesContainer.add_child(interactablesResourse.instance())

func removeInteractables():
	for n in interactablesContainer.get_children():
		interactablesContainer.remove_child(n)
		n.queue_free()

