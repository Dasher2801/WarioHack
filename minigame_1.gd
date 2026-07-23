extends Node2D

var garlic_collected = 0
var timer_end = false

func _ready() -> void:
	var time_left: float = 10.0
	while time_left > 0:
		var node = get_node_or_null("Countdown")
		if node == null:
			return
		node.text = str(int(time_left))
		await get_tree().create_timer(1.0).timeout
		time_left -= 1.0
	timer_end = true

func _process(_delta: float) -> void:
	if garlic_collected == 3:
		if Global.minigames_done > 3:
			get_tree().change_scene_to_file("res://scenes/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://level_scene.tscn") 

	if timer_end: # if the timer does end...
		Global.minigames_done -= 1 # go back a minigame
		Global.lives -= 1 # lose ur lives
		get_tree().change_scene_to_file("res://level_scene.tscn") # back to intermission
		

func garlic_collect() -> void: # cool function that you connect to those garlics
	garlic_collected = garlic_collected +1
	return


func _on_tomato_garlic_collected() -> void:
	garlic_collected = garlic_collected +1


func _on_tomato_2_garlic_collected() -> void:
	garlic_collected = garlic_collected +1


func _on_tomato_3_garlic_collected() -> void:
	garlic_collected = garlic_collected +1
