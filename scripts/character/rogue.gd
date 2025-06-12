extends NPCEnemy

func _ready() -> void:
	max_health = 50
	health = 50
	attack_damage = 12
	battle_scene_path = "res://scenes/battles/battle_scene_rogue.tscn"
	falas = [
		"Eu reduzi tua aldeia a cinzas… e farei o mesmo com teu espírito.",
		"A floresta que você tanto protege? Agora serve apenas de lenha para minha fúria.",
		"O fogo não teme folhas nem orações."
	]
	super._ready()
