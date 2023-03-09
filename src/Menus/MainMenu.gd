extends Control

onready var displayOptionBtn: OptionButton = get_node("Grid/OptionButton")
onready var masterValue: Label = get_node("Grid/HBox/MasterVolValue")
onready var masterSlider: HSlider = get_node("Grid/HBox/MasterVolSlider")
onready var audio: AudioStreamPlayer = get_node("Play")

export(String, FILE) var nextScenePath: = ""

func _ready():
	displayOptionBtn.select(1 if Save.game_data.fullscreen_on else 0)
	GlobalSettings.toggle_fullscreen(Save.game_data.fullscreen_on)
	masterSlider.value = Save.game_data.master_vol
	GlobalSettings.HighScore = Save.game_data.high_score

func _on_NewGame_button_up():
	audio.play(0)
	yield(get_tree().create_timer(1.0), "timeout")
	var err = get_tree().change_scene(nextScenePath)
	if err != OK:
		print("Error MainScreen")

func _on_DisplayOptions_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)

func _on_VolSlider_value_changed(value):
	GlobalSettings.update_vol(value)
	var v = int((50 + Save.game_data.master_vol) * 2)
	masterValue.text = str(v)

func _on_LinkButton_button_up():
	var err = OS.shell_open("https://www.nihilore.com/")
	if err != OK:
		print("Error link")
