extends Spatial

onready var raycast: RayCast = get_node("RayCast")
onready var collision_point: MeshInstance = get_node("ColisionPoint")

func _physics_process(delta):
	if raycast.is_colliding():
		collision_point.global_transform.origin = raycast.get_collision_point()
