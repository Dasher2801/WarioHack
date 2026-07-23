extends Node2D

@onready var moon: CharacterBody2D = $Moon
@onready var obstacle_container: Node2D = $ObstacleContainer
@onready var countdown: RichTextLabel = $Countdown

var game_won: bool = false
var game_over: bool = false
var timer_end: bool = false
var obstacle_spawn_timer: float = 0.0

const GRAVITY: float = 1200.0
const FLAP_FORCE: float = -400.0
const OBSTACLE_SPEED: float = 300.0
const SPAWN_INTERVAL: float = 1.5
const GURKE: Texture2D = preload("res://Gurke.png")

func _ready() -> void:
	var time_left: float = 8.0
	while time_left > 0:
		if game_over:
			return # Stop counting down if dead!
		var node: RichTextLabel = get_node_or_null("Countdown")
		if node == null:
			return
		node.text = str(int(time_left))
		await get_tree().create_timer(1.0).timeout
		time_left -= 1.0
	
	if not game_over:
		timer_end = true # Survived the full time -> win

func _physics_process(delta: float) -> void:
	if game_won or game_over or timer_end:
		return
	
	# 1. Apply gravity to moon
	moon.velocity.y += GRAVITY * delta
	
	# 2. Flap on accept or mouse click
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		moon.velocity.y = FLAP_FORCE
	
	moon.move_and_slide()
	
	# 3. Check screen boundary limits (if moon falls out of screen or goes too high)
	if moon.global_position.y < 0 or moon.global_position.y > 648:
		die()
		return
	
	# 4. Spawn obstacles
	obstacle_spawn_timer += delta
	if obstacle_spawn_timer >= SPAWN_INTERVAL:
		obstacle_spawn_timer = 0.0
		spawn_obstacle()
	
	# 5. Move obstacles
	for obstacle: Node2D in obstacle_container.get_children():
		obstacle.position.x -= OBSTACLE_SPEED * delta
		if obstacle.position.x < -150:
			obstacle.queue_free()

func _process(_delta: float) -> void:
	if timer_end and not game_won and not game_over:
		game_won = true
		get_tree().change_scene_to_file("res://level_scene.tscn")

func spawn_obstacle() -> void:
	# Random gap position, upper and lower cucumber pipes
	var gap_y: float = randf_range(150.0, 450.0)
	var gap_height: float = 180.0
	var pipe_width: float = 80.0
	
	var top_height: float = gap_y - (gap_height / 2.0)
	var bottom_height: float = 648.0 - (gap_y + (gap_height / 2.0))
	
	_spawn_pipe(Vector2(1200.0, 0.0), Vector2(pipe_width, top_height), true)
	_spawn_pipe(Vector2(1200.0, gap_y + (gap_height / 2.0)), Vector2(pipe_width, bottom_height), false)

func _spawn_pipe(pipe_position: Vector2, pipe_size: Vector2, flipped: bool) -> void:
	var pipe: Area2D = Area2D.new()
	pipe.collision_layer = 4 # Obstacle layer (moon's Area2D looks for this)
	pipe.collision_mask = 0
	pipe.position = pipe_position
	
	# Cucumber sprite stretched to the pipe size
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = GURKE
	sprite.flip_v = flipped # Top cucumber hangs upside down
	sprite.scale = Vector2(pipe_size.x / GURKE.get_width(), pipe_size.y / GURKE.get_height())
	sprite.position = pipe_size / 2.0
	pipe.add_child(sprite)
	
	# Collision matching the pipe size
	var collision: CollisionShape2D = CollisionShape2D.new()
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = pipe_size
	collision.shape = shape
	collision.position = pipe_size / 2.0
	pipe.add_child(collision)
	
	obstacle_container.add_child(pipe)

func _on_moon_collision(_obj: Node2D) -> void:
	die()

func die() -> void:
	if game_won or game_over or timer_end:
		return
	game_over = true # Mark as finished (lost)
	Global.lives -= 1
	Global.minigames_done -= 1
	call_deferred("_change_to_level_scene")

func _change_to_level_scene() -> void:
	get_tree().change_scene_to_file("res://level_scene.tscn")
