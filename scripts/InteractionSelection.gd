extends Spatial


onready var interaction1Mesh = $Interaction1/Area/MeshInstance
	

func _on_interaction1_area_entered():
	#get_node("../OutputNode/Viewport/OtherLabel").text = "ON"
	var material = interaction1Mesh.get_surface_material(0)
	material.albedo_color = Color(1, 0, 0)
	interaction1Mesh.set_surface_material(0, material)
	
func _process(delta):
	var areas = $Interaction1/Area.get_overlapping_areas()
	get_node("../OutputNode/Viewport/OtherLabel").text = areas as String
	if areas.size() > 0:
		var material = interaction1Mesh.get_surface_material(0)
		material.albedo_color = Color(1, 0, 0)
		interaction1Mesh.set_surface_material(0, material)
	else:
		var material = interaction1Mesh.get_surface_material(0)
		material.albedo_color = Color(1, 1, 1)
		interaction1Mesh.set_surface_material(0, material)
