extends Node2D
@onready var garlic_container: HBoxContainer = $Hearts
@onready var garlic: TextureRect = $Hearts/Heart
@onready var garlic_2: TextureRect = $Hearts/Heart2
@onready var garlic_3: TextureRect = $Hearts/Heart3
@onready var garlic_4: TextureRect = $Hearts/Heart4
@onready var garlic_5: TextureRect = $Hearts/Heart5
@onready var level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $Timer

var time

func _ready() -> void:
	await Timer(3.0) # using the function created
	
	if Global.minigames_done < 5: # if you havent completed 5 minigames yet 
		Global.minigames_done = Global.minigames_done +1
		# Randomly pick one of the 3 minigames (1, 2 or 3)
		var scene_index: int = randi() % 4 + 1
		get_tree().change_scene_to_file("res://scenes/minigame_" + str(scene_index) + ".tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn") # changes your scene
	

func _process(_delta: float) -> void: # runs EVERY FRAME
	match Global.lives: # asks or checks if lives is equal to one of 
#these values, cool hack. by the way this is a horrid way to illustrate the 
#lives visually so later you can always find alternative code. Now, dw abt it.

		4:
			garlic.hide()
		3:
			garlic.hide()
			garlic_2.hide()
		2:
			garlic.hide()
			garlic_2.hide()
			garlic_3.hide()
		1:
			garlic.hide()
			garlic_2.hide()
			garlic_3.hide()
			garlic_4.hide()
		0:
			garlic_container.hide() # just hides everything
			get_tree().change_scene_to_file("res://scenes/lose_screen.tscn") # sofort zum lose screen
	
	timer.text = str(time) # make ths text reflect the value of the time variable. this makes names easier. the str() converts the int to a String
	level.text = "Level " + str(Global.minigames_done) # this tells you want minigame you're on using concatenation (google the word yo)

func Timer(start_time: float): # making a new function for timer countdown!
	# we want the timer to go down, and when it reaches 0 it transitions 
	# to the next scene!
	
	time = start_time # make the timer, which is reflected through the timer text, start at your desired number
	
	while time > 0.1: # run if timer hasnt reached 0
		await wait(0.1) # asks script to wait on this function. the 'wait' name for the function does nothing here, as await is just telling the scrpit to wait for the function to complete before progressing
		time -= 0.1 # remove 0.1
		# progressively get the value smaller and smaller
	
	#when timer reaches 0
	return

func wait(seconds: float) -> void: # write this simple function out for wait!
	await get_tree().create_timer(seconds).timeout # makes u wait, dw abt this being complex '''
