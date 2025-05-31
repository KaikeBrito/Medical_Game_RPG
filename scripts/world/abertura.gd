extends Node2D


func _on_jogar_pressed() -> void:
	# Altere esse caminho para o caminho real do seu primeiro level
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
