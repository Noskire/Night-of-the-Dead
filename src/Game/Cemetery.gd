extends Node2D

onready var score_label: Label = get_node("Score")
onready var flwrs_lb: RichTextLabel = get_node("Flowers")
onready var camera: Camera2D = get_node("Camera2D")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")

export(String, FILE) var endPath: = ""

export var random_shake_strength: float = 30.0
export var shake_decay_rate: float = 5.0
export var noise_shake_speed: float = 30.0
export var noise_shake_strength: float = 60.0

var rand = RandomNumberGenerator.new()
var noise = OpenSimplexNoise.new()

var noise_i: float = 0.0
var shake_strength: float = 0.0

var flower_current
var flower_max = 10
var score
var total_graves = 36

func _ready():
	rand.randomize()
	noise.seed = rand.randi()
	noise.period = 2
	
	flower_current = flower_max
	update_flowers_label()

	score = 0
	get_node("Music").play(0)
	get_node("Timer").start()

func _process(delta):
	shake_strength = lerp(shake_strength, 0, shake_decay_rate * delta)
	camera.offset = get_noise_offset(delta)

func up_score():
	score += 1
	score_label.set_text("Score: %05d" % score)

func grave_opened():
	total_graves -= 1
	if total_graves == 0:
		yield(get_tree().create_timer(.1), "timeout")
		game_over()

func game_over():
	GlobalSettings.Score = score
	anim.play("FadeOut")
	get_tree().paused = true

func apply_shake():
	shake_strength = noise_shake_strength

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * noise_shake_speed
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)

func update_flowers_label():
	var bgn = "[center][color="
	var mdl
	var end = "]Flowers: " + str(flower_current) + " / " + str(flower_max) + "[/color][/center]"
	if flower_current == 0:
		mdl = "red"
	elif flower_current <= 3:
		mdl = "#FFA500"
	elif flower_current <= 6:
		mdl = "yellow"
	else:
		mdl = "white"
	flwrs_lb.set_bbcode(bgn + mdl + end)

func refil():
	flower_current = flower_max
	update_flowers_label()

func _on_animation_finished(_anim_name):
	get_tree().paused = false
	var err = get_tree().change_scene(endPath)
	if err != OK:
		print("Error GameOver")

func _on_Timer_timeout():
	score += 300
	GlobalSettings.clearFase = 1
	game_over()
