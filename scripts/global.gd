extends Node

enum trash_type {ENTULHO, VIDRO, METAL, MADEIRA}

var time_played = 0
var scoreboard = []
var record_score = 0


func increase_time_played():
	time_played += 1


func update_scoreboard():
	var response = await LootLocker.get_scoreboard()
	if response:
		scoreboard = []
		for i in response:
			scoreboard.append({"player_name": i["member_id"], "player_rank" : i["rank"], "player_score" : i["score"]})


func get_current_record():
	await update_scoreboard()
	for score in scoreboard:
		if score["player_name"] == LootLocker.player_id:
			record_score = score["player_score"]
			return


func set_record_score(score):
	record_score = score


