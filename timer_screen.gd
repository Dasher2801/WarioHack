extends Node2D

func _ready() -> void:
	# 1. Wir warten 3 Sekunden im grauen Bildschirm
	await get_tree().create_timer(3.0).timeout
	
	# 2. Danach weisen wir Godot an, das nächste Level zu laden!
	# (Tausche den Pfad hier einfach gegen die Szene aus, die danach kommen soll):
	get_tree().change_scene_to_file("res://scenes/minigame_1.tscn")
