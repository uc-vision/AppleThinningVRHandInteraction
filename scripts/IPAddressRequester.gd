extends HTTPRequest


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("request_completed", self, "_on_request_completed")

func get_ip_address():
	var result = self.request("https://api64.ipify.org")

func _on_request_completed(result, response_code, headers, body):
	var response = body.get_string_from_utf8()
	get_tree().root.get_node("Main/HTTPRequest").ipAddress = response
