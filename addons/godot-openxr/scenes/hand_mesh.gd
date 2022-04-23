tool
extends Spatial

onready var output_node = get_node("../../OutputNode")

enum MOTION_RANGE {
	UNUBSTRUCTED = 0,
	CONFORM_TO_CONTROLLER = 1
}

export var hand : String

var held_object = null
var held_object_data = {"mode":RigidBody.MODE_RIGID, "layer":1, "mask":1}

export (MOTION_RANGE) var motion_range setget set_motion_range
export (Texture) var albedo_texture setget set_albedo_texture
export (Texture) var normal_texture setget set_normal_texture

var material : SpatialMaterial

func set_motion_range(value):
	motion_range = value
	if is_inside_tree():
		_update_motion_range()

func _update_motion_range():
	# for some reason not consistantly named between the two hands..
	if $HandModel.find_node("Armature001"):
		$HandModel/Armature001/Skeleton.motion_range = motion_range
	else:
		$HandModel/Armature/Skeleton.motion_range = motion_range

func set_albedo_texture(value):
	albedo_texture = value
	if is_inside_tree():
		_update_albedo_texture()

func _update_albedo_texture():
	if material:
		material.albedo_texture = albedo_texture

func set_normal_texture(value):
	normal_texture = value
	if is_inside_tree():
		_update_normal_texture()

func _update_normal_texture():
	if material:
		material.normal_texture = normal_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	if $HandModel.find_node("Armature001"):
		material = $HandModel/Armature001/Skeleton/vr_glove_left_slim.mesh.surface_get_material(0)
	else:
		material = $HandModel/Armature/Skeleton/vr_glove_right_slim.mesh.surface_get_material(0)

	_update_motion_range()
	_update_albedo_texture()
	_update_normal_texture()
	
func _process(delta):
	pass
	
func _on_Palm_Area_area_entered(area):
	if area.get_name() == "RightHandMiddleFingerTipArea":
		output_node.change_grip_label_text("Right Hand Gripping")
		grab_object()
	elif area.get_name() == "LeftHandMiddleFingerTipArea":
		output_node.change_grip_label_text("Left Hand Gripping")


func _on_Palm_Area_area_exited(area):
	if area.get_name() == "RightHandMiddleFingerTipArea" or area.get_name() == "LeftHandMiddleFingerTipArea":
		output_node.change_grip_label_text("NotGripping")
		drop_object()
		
		

func grab_object():
	if hand == "Right":
		if !held_object:
			var palm_area = $HandModel/Armature/Skeleton/Palm/Palm_Area
			var bodies = palm_area.get_overlapping_bodies()
			var rigid_body = null
			if len(bodies) > 0:
				for body in bodies:
					if body is RigidBody:
						rigid_body = body
						break
		
			if rigid_body:
				get_node("../../OutputNode/Viewport/OtherLabel").text = rigid_body.get_name()
				held_object = rigid_body
				held_object_data["mode"] = held_object.mode
				held_object_data["layer"] = held_object.collision_layer
				held_object_data["mask"] = held_object.collision_mask
				
				held_object.mode = RigidBody.MODE_STATIC
				held_object.collision_layer = 0
				held_object.collision_mask = 0
				
				var parent = get_parent()
				parent.add_child(held_object)
		else:
			held_object.mode = held_object_data["mode"]
			held_object.collision_layer = held_object_data["layer"]
			held_object.collision_mask = held_object_data["mask"]
			
			held_object = null

func drop_object():
	held_object.mode = held_object_data["mode"]
	held_object.collision_layer = held_object_data["layer"]
	held_object.collision_mask = held_object_data["mask"]
	held_object = null
	
	var parent = get_parent()
	parent.remove_child(held_object)
	
	get_node("../../OutputNode/Viewport/OtherLabel").text = ""
