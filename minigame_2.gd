extends Node2D

var buttons_pressed := 0
var timer_end = false
var game_won = false

func _ready() -> void:
	var time_left: float = 4.0
	while time_left > 0:
		if game_won:
			return # Stop counting down if won!
		var node = get_node_or_null("Countdown")
		if node == null:
			return
		node.text = str(int(time_left))
		await get_tree().create_timer(1.0).timeout
		time_left -= 1.0
	
	if not game_won:
		timer_end = true 


func _process(_delta: float) -> void:
	if buttons_pressed == 3: # We now have Button1, Button2, Button3 (three tomatoes)
		game_won = true
		get_tree().change_scene_to_file("res://level_scene.tscn")
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -= 1
		get_tree().change_scene_to_file("res://level_scene.tscn")
