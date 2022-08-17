extends Spatial

onready var resetAreaMesh = $InteractionSelection/Reset/Area/MeshInstance
onready var resetArea = $InteractionSelection/Reset/Area
onready var canReset = true
onready var branchResourse = load("res://scenes/branch.tscn")

onready var branchContainer = $BranchContainer


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
	branchContainer.add_child(branchResourse.instance())

func removeInteractables():
	for n in branchContainer.get_children():
		branchContainer.remove_child(n)
		n.queue_free()

