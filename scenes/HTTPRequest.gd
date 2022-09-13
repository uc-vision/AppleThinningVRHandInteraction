extends HTTPRequest

var my_full_url = "https://docs.google.com/forms/u/0/d/e/1FAIpQLScv6L4iDehjDN8s1bdHqm3qXqq_In2fhxiTXw_ij_yjeD5AOw/formResponse"
var headers = ["Content-Type: application/x-www-form-urlencoded"]
var http = HTTPClient.new()

var sessionId = "entry.79263384"
var interactionNumber = "entry.1077871421"
var interactionTimeTaken = "entry.571957013"
var interactionMispicks = "entry.1246872964"
var interactionRating = "entry.53116450"

var characters = 'abcdefghijklmnopqrstuvwxyz!@#$%^&*'
var unique_session_id = null

func _ready():
	randomize()
	unique_session_id = generate_string(characters, 20)


func generate_string(chars, length):
	var string: String
	var n_char = len(chars)
	for i in range(length):
		string += chars[randi()% n_char]
	return string


func send_data(interactionNum: int, timeTaken: float, mispicks: int, rating: int):
	var data = {
		sessionId: unique_session_id,
		interactionNumber: interactionNum as String,
		interactionTimeTaken: timeTaken as String,
		interactionMispicks: mispicks as String,
		interactionRating: rating as String
	}
	var headers_pool = PoolStringArray(headers)
	var data_ready = http.query_string_from_dict(data)
	
	var result = self.request(my_full_url, headers_pool, false, http.METHOD_POST, data_ready)
