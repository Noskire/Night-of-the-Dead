extends Node

var HighScore
var Score = 0
var clearFase = 0

func toggle_fullscreen(value):
	OS.window_fullscreen = value
	Save.game_data.fullscreen_on = value
	Save.save_data()

func update_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	Save.game_data.master_vol = vol
	Save.save_data()

func change_highscore(score):
	HighScore = score
	Save.game_data.high_score = score
	Save.save_data()
