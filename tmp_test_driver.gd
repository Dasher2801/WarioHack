extends Node
## Temporary headless test driver for minigame_3. Not part of the game.
## Run: godot --headless --fixed-fps 60 --quit-after 800 res://tmp_test_driver.tscn -- flap

var game: Node2D
var moon: CharacterBody2D
var container: Node2D
var label: RichTextLabel
var pressed: bool = false
var frame: int = 0
var flap: bool = false
var pipe_reported: bool = false
var life_lost_reported: bool = false

func _ready() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	flap = args.has("flap")
	game = load("res://scenes/minigame_3.tscn").instantiate()
	add_child(game)
	moon = game.get_node("Moon")
	container = game.get_node("ObstacleContainer")
	label = game.get_node("Countdown")
	print("DRIVER START flap=", flap)

func _physics_process(_delta: float) -> void:
	frame += 1
	if not is_instance_valid(game):
		set_physics_process(false)
		return
	if flap:
		var target_y: float = 310.0
		var best_x: float = INF
		for pipe: Node2D in container.get_children():
			if pipe.position.y == 0.0 and pipe.position.x + 80.0 > moon.global_position.x - 50.0 and pipe.position.x < best_x:
				best_x = pipe.position.x
				target_y = (pipe.get_child(1) as CollisionShape2D).shape.size.y + 90.0 # gap center
		if moon.global_position.y > target_y + 10.0 and not pressed:
			Input.action_press("ui_accept")
			pressed = true
		elif pressed and moon.global_position.y <= target_y:
			Input.action_release("ui_accept")
			pressed = false
	if flap and not pipe_reported and container.get_child_count() > 0:
		pipe_reported = true
		var pipe: Area2D = container.get_child(0)
		var spr: Sprite2D = pipe.get_child(0)
		var col: CollisionShape2D = pipe.get_child(1)
		print("PIPE: layer=", pipe.collision_layer, " pos=", pipe.position, " tex=", spr.texture.resource_path, " scale=", spr.scale, " flip_v=", spr.flip_v, " shape=", col.shape.size)
	if flap:
		for pipe: Node2D in container.get_children():
			pipe.collision_layer = 0 # neutralize pipe collision: pipe-death already proven, now testing the timer-win path
	if frame % 60 == 0 and is_instance_valid(moon):
		print("t=", frame / 60, "s | countdown='", label.text, "' | moon_y=", snappedf(moon.global_position.y, 0.1), " | obstacles=", container.get_child_count(), " | lives=", Global.lives)
	if Global.lives < 5 and not life_lost_reported:
		life_lost_reported = true
		print(">>> LIFE LOST at frame ", frame, " (", snappedf(frame / 60.0, 0.01), "s) moon_y=", snappedf(moon.global_position.y, 0.1))

func _exit_tree() -> void:
	print("DRIVER EXIT frame=", frame, " lives=", Global.lives, " minigames_done=", Global.minigames_done)
