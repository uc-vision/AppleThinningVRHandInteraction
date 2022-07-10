extends Node

onready var palm_area = $HandModel/Armature/Skeleton/Palm/Palm_Area
onready var grab_range = $HandModel/Armature/Skeleton/Palm/Grab_Range

	
func get_closest_rigidbody():
	var bodies = grab_range.get_overlapping_bodies()
	var closest_body: RigidBody = null
	var closest_distance = null
	for body in bodies:
		var curr_distance = grab_range.global_transform.origin.distance_to(body.global_transform.origin)
		# closest_body == null is first case
		if body is RigidBody and (closest_body == null or curr_distance < closest_distance):
			closest_body = body
			closest_distance = curr_distance
	return closest_body


func detect_grabbing_object():
	if palm_area.get_overlapping_areas().size() > 0:
		return get_closest_rigidbody()
	return null
