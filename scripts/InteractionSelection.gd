extends Spatial


onready var interaction1Mesh = $Interaction1/Area/MeshInstance
	

func _on_interaction1_area_entered(area):
	#get_node("../OutputNode/Viewport/OtherLabel").text = "ON"
	var material = interaction1Mesh.get_surface_material(0)
	material.albedo_color = Color(1, 0, 0)
	interaction1Mesh.set_surface_material(0, material)
