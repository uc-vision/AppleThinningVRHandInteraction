extends Spatial


onready var interaction1Mesh = $Interaction1/Area/MeshInstance
onready var interaction2Mesh = $Interaction2/Area/MeshInstance
onready var interaction3Mesh = $Interaction3/Area/MeshInstance
	

func _on_interaction1_area_entered(area):
	resetMeshes()
	var material = interaction1Mesh.get_surface_material(0)
	material.albedo_color = Color(1, 0, 0)
	interaction1Mesh.set_surface_material(0, material)


func _on_interaction2_area_entered(area):
	resetMeshes()
	var material = interaction2Mesh.get_surface_material(0)
	material.albedo_color = Color(1, 0, 0)
	interaction2Mesh.set_surface_material(0, material)

func _on_interaction3_area_entered(area):
	resetMeshes()
	var material = interaction3Mesh.get_surface_material(0)
	material.albedo_color = Color(1, 0, 0)
	interaction3Mesh.set_surface_material(0, material)
	
	
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
