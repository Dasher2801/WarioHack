extends Node2D
var tomato_click = 10
var button_pressed = 0

func _on_button_pressed() -> void:
	button_pressed = button_pressed +1
	tomato_click = tomato_click -1
	return
	
func _process(_delta: float) -> void:
	if button_pressed == 10:
		get_tree().change_scene_to_file("res://level_scene.tscn")
		
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
