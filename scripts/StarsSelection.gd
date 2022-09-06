extends Spatial


onready var currentSelection = 0
onready var selectedMeshColour = Color(1, 1, 0)
onready var unselectedMeshColuor = Color(1, 1, 1)

func _process(delta):
	for i in range(0, currentSelection + 1):
		changeStarMaterial(i, selectedMeshColour)
	for i in range(currentSelection + 1, 6):
		changeStarMaterial(i, unselectedMeshColuor)

func changeStarMaterial(index: int, colour: Color):
	for i in range(1, 4):
		var mesh = get_node("Star" + index as String + "/MeshInstance" + i as String)
		var material = mesh.get_surface_material(0)
		material.albedo_color = colour
		mesh.set_surface_material(0, material)

func _on_star_area_entered(area, rating):
	currentSelection = rating

func reset_stars():
	currentSelection = 0
	for i in range(0, 6):
		changeStarMaterial(i, unselectedMeshColuor)
