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


#Interaction Mechanic 1

#This interaction simply detects whether any of the users fingers have entered into the palm_area.
#and if there are any, then the function returns the closest pickupable object

func detect_grabbing_object_1():
	if palm_area.get_overlapping_areas().size() > 0:
		return get_closest_rigidbody()
	return null


#Interaction Mechanic 2

#This interaction behaves similarly to the first, but calculates the angle of bend of each of the 
#users fingers and then returns the closest pickupable object if at least two fingers are bent to 
#at least 90 degrees

#Has a lot of complicated setup for getting the angle of bend for each joint in each finger


onready var hand = get_parent()
enum ovrHandFingers {
	Thumb		= 0,
	Index		= 1,
	Middle		= 2,
	Ring		= 3,
	Pinky		= 4,
	Max,
	EnumSize = 0x7fffffff
};

enum ovrHandBone {
	Invalid						= -1,
	WristRoot 					= 0,	# root frame of the hand, where the wrist is located
	ForearmStub					= 1,	# frame for user's forearm
	Thumb0						= 2,	# thumb trapezium bone
	Thumb1						= 3,	# thumb metacarpal bone
	Thumb2						= 4,	# thumb proximal phalange bone
	Thumb3						= 5,	# thumb distal phalange bone
	Index1						= 6,	# index proximal phalange bone
	Index2						= 7,	# index intermediate phalange bone
	Index3						= 8,	# index distal phalange bone
	Middle1						= 9,	# middle proximal phalange bone
	Middle2						= 10,	# middle intermediate phalange bone
	Middle3						= 11,	# middle distal phalange bone
	Ring1						= 12,	# ring proximal phalange bone
	Ring2						= 13,	# ring intermediate phalange bone
	Ring3						= 14,	# ring distal phalange bone
	Pinky0						= 15,	# pinky metacarpal bone
	Pinky1						= 16,	# pinky proximal phalange bone
	Pinky2						= 17,	# pinky intermediate phalange bone
	Pinky3						= 18,	# pinky distal phalange bone
	MaxSkinnable				= 19,

	# Bone tips are position only. They are not used for skinning but useful for hit-testing.
	# NOTE: ThumbTip == MaxSkinnable since the extended tips need to be contiguous
	ThumbTip					= 19 + 0,	# tip of the thumb
	IndexTip					= 19 + 1,	# tip of the index finger
	MiddleTip					= 19 + 2,	# tip of the middle finger
	RingTip						= 19 + 3,	# tip of the ring finger
	PinkyTip					= 19 + 4,	# tip of the pinky
	Max 						= 19 + 5,
	EnumSize 					= 0x7fff
};

const _ovrHandFingers_Bone1Start = [ovrHandBone.Thumb1, ovrHandBone.Index1, ovrHandBone.Middle1, ovrHandBone.Ring1,ovrHandBone.Pinky1]



func _get_bone_angle_diff(ovrHandBone_id):
	var quat_diff = hand._vrapi_bone_orientations[ovrHandBone_id] * hand._vrapi_inverse_neutral_pose[ovrHandBone_id];
	var a = acos(clamp(quat_diff.w, -1.0, 1.0));
	return rad2deg(a);

func get_finger_angle_estimate(finger):
	var angle = 0.0;
	angle += _get_bone_angle_diff(_ovrHandFingers_Bone1Start[finger]+0);
	angle += _get_bone_angle_diff(_ovrHandFingers_Bone1Start[finger]+1);
	angle += _get_bone_angle_diff(_ovrHandFingers_Bone1Start[finger]+2);
	return angle;

onready var last_detected_gripping = null

func detect_grabbing_object_2():
	if (hand.tracking_confidence <= 0.5): return last_detected_gripping;
	var fingers_gripping = 0
	for i in range(0, 5):
		var finger_angle = get_finger_angle_estimate(i)
		if finger_angle > 90:
			fingers_gripping += 1
	if fingers_gripping > 2:
		var closest = get_closest_rigidbody()
		last_detected_gripping = closest
		return closest
	last_detected_gripping = null
	return false


#Interaction Mechanic 3

#This interaction mechanic uses areas on the users fingers to detect when 
#fingers are inside of grabable objects and then the detect_grabbing_object 
#function returns the gripping object if the users thumb and at least one other 
#finger are inside of the object.

var enteredBodies = {}

func _on_body_entered_finger_area(body, fingerName):
	
	if not body in enteredBodies:
		enteredBodies[body] = [fingerName]
	else:
		enteredBodies[body].append(fingerName)


func _on_body_exited_finger_area(body, fingerName):
	
	enteredBodies[body].erase(fingerName)
	
	if enteredBodies[body].empty():
		enteredBodies.erase(body)

func detect_grabbing_object_3():
	var objects = enteredBodies.keys()
	var num_fingers = 0
	var grabbingObject = null
	
	for object in enteredBodies:
		var fingers = enteredBodies[object]
		if "ThumbTip" in fingers and num_fingers < len(fingers) and len(fingers) >= 2:
			num_fingers = len(fingers)
			grabbingObject = object
			if num_fingers >= 3: break
	
	return grabbingObject
