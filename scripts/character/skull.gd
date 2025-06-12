extends NPCEnemy


# Estado do diálogo
func _ready() -> void:
	max_health = 50
	health  = 50
	attack_damage = 12
	battle_scene_path = "res://scenes/battles/battle_scene_skull.tscn"
	var falas = [
		"Quantos fios de esperança ainda te restam, guerreirinho?",
		"Eu vejo tua alma enredada... lutando contra um destino inevitável.",
		"Continue dançando, pequeno tolo, minha teia já envolve teus passos."
	]
	super._ready()
