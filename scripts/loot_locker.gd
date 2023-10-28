extends Node

const API_KEY = "dev_8b9ffd833c674805986614ee1f815a53"
const API_DOMAIN = "https://f9oeo444.api.lootlocker.io/game/"
const DOMAIN_KEY = "f9oeo444"
const LEADERBOARD_ID = "18467"
const API_URL = "https://api.lootlocker.io/game/"
const GAME_VERSION = "0.0.0.1"

var development_mode = true
var session_token = ""
var player_id = "Juvenal_pega"
var message = ""
var score_list = []


func request_message(msg):
	message = msg
	print(message)


func authenticate_guest(user_id):
	var url = API_DOMAIN + "v2/session/guest"
	var header = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	var request_body = {
		"game_key" : API_KEY,
		"player_identifier" : user_id,
		"game_version" : GAME_VERSION
	}
	
	request_message("Autenticando")
	
	print(user_id)
	
	var auth_http = HTTPRequest.new()
	add_child(auth_http)
	
	auth_http.request(url, header, method, JSON.stringify(request_body))
	
	var response = await auth_http.request_completed
	
	if response[1] == 200:
		auth_http.queue_free()
		
		var json = JSON.new()
		var error = json.parse(response[3].get_string_from_utf8())
		
		if error == OK:
			var data_received = json.data
			
			if "session_token" in data_received:
				session_token = data_received["session_token"]
				request_message("Sucesso")
				player_id = user_id
				return
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", response, " at line ", json.get_error_line())
	else:
		print(response[1])
	
	request_message("Falha")
	


func submit_highscore(score):
	var url = API_DOMAIN + "leaderboards/" + LEADERBOARD_ID + "/submit"
	var header = ["Content-Type: application/json", "x-session-token: %s" % session_token]
	var method = HTTPClient.METHOD_POST
	var request_body = {
		"score" : score,
		"member_id" : player_id,
		"metadata" : player_id
	}
	
	request_message("Enviando")
	
	var submit_score_http = HTTPRequest.new()
	add_child(submit_score_http)
	
	submit_score_http.request(url, header, method, JSON.stringify(request_body))
	
	var response = await submit_score_http.request_completed
	
	if response[1] == 200:
		submit_score_http.queue_free()
		
		var json = JSON.new()
		var error = json.parse(response[3].get_string_from_utf8())
		if error == OK:
			request_message("Sucesso")
			return
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", response, " at line ", json.get_error_line())
	else:
		print(response[1])
	
	request_message("Falha")


func get_scoreboard():
	var url = API_DOMAIN + "leaderboards/" + LEADERBOARD_ID + "/list?count=10"
	var header = ["Content-Type: application/json", "x-session-token: %s" % session_token]
	var method = HTTPClient.METHOD_GET
	
	request_message("Solicitando")
	
	var get_score_http = HTTPRequest.new()
	add_child(get_score_http)
	
	get_score_http.request(url, header, method)
	
	var response = await get_score_http.request_completed
	get_score_http.queue_free()
	
	if response[1] == 200:
		
		var json = JSON.new()
		var error = json.parse(response[3].get_string_from_utf8())
		if error == OK:
			var data_received = json.data
			
			request_message("Sucesso")
			
			if "items" in data_received:
				return data_received["items"]
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", response, " at line ", json.get_error_line())
	elif response[1] == 403:
		print(403)
		return await get_scoreboard()
	else:
		print(response[1])
	
	request_message("Falha")
	return false

