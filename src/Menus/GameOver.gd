extends Control

onready var overl: Label = get_node("OverText")
onready var scorel: Label = get_node("Score")
onready var high_scorel: Label = get_node("HighScore")

export(String, FILE) var gamePath: = ""
export(String, FILE) var menuPath: = ""

func _ready():
	if GlobalSettings.clearFase == 1:
		overl.set_text("Phase Clear!")
		GlobalSettings.clearFase = 0
	else:
		overl.set_text("Game Over!")
	
	var score = GlobalSettings.Score
	scorel.set_text("Score: %05d" % GlobalSettings.Score)
	
	if score > GlobalSettings.HighScore:
		GlobalSettings.change_highscore(score)
		high_scorel.set_text("HighScore: %05d\n(New HighScore)" % score)
	else:
		high_scorel.set_text("HighScore: %05d" % GlobalSettings.HighScore)

func _on_Retry_button_up():
	var err = get_tree().change_scene(gamePath)
	if err != OK:
		print("Error RetryBtn")

func _on_Menu_button_up():
	var err = get_tree().change_scene(menuPath)
	if err != OK:
		print("Error MenuBtn")
