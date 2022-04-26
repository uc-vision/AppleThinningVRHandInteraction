extends Spatial

export var active := true;
export var ui_raycast_length := 3.0;
export var ui_mesh_length := 1.0;

export var adjust_left_right := true;

var controller : ARVRController = null;
onready var ui_raycast_position : Spatial = $RayCastPosition;
onready var ui_raycast : RayCast = $RayCastPosition/RayCast;
onready var ui_raycast_mesh : MeshInstance = $RayCastPosition/RayCastMesh;
onready var ui_raycast_hitmarker : MeshInstance = $RayCastPosition/RayCastHitMarker;

const hand_click_button := 7;

var is_colliding := false;


func _set_raycast_transform():
	ui_raycast_position.transform.basis = Basis(Vector3(deg2rad(-90),0,0));
		
	
		

func _update_raycasts():
	ui_raycast_hitmarker.visible = false;	
	_set_raycast_transform();
	ui_raycast.force_raycast_update(); # need to update here to get the current position; else the marker laggs behind
	if ui_raycast.is_colliding():
		var c = ui_raycast.get_collider();
		if (!c.has_method("ui_raycast_hit_event")): return;
		
		var click = false;
		var release = false;
		click = controller._button_just_pressed(hand_click_button);
		release = controller._button_just_released(hand_click_button);
		
		var position = ui_raycast.get_collision_point();
		ui_raycast_hitmarker.visible = true;
		ui_raycast_hitmarker.global_transform.origin = position;
		
		c.ui_raycast_hit_event(position, click, release);
		is_colliding = true;
	else:
		is_colliding = false;

func _ready():
	controller = get_parent();
	
	ui_raycast.set_cast_to(Vector3(0, 0, -ui_raycast_length));
	
	#setup the mesh
	ui_raycast_mesh.mesh.size.z = ui_mesh_length;
	ui_raycast_mesh.translation.z = -ui_mesh_length * 0.5;
	
	ui_raycast_hitmarker.visible = false;
	ui_raycast_mesh.visible = false;

# we use the physics process here be in sync with the controller position
func _physics_process(_dt):
	if (!active): return;
	if (!visible): return;
	_update_raycasts();
