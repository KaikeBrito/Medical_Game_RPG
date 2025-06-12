extends NPCEnemy

func _ready() -> void:
	max_health = 50
	health  = 50
	attack_damage = 12
	battle_scene_path = "res://scenes/battles/battle_scene_skeleton.tscn"
	falas = [
		"Você ousa levantar a lança contra mim, pequeno espírito da floresta?",
		"Teus ancestrais sussurram... mas o meu veneno grita mais alto.",
		"Quando seu corpo tombar, será apenas mais uma raiz seca na terra."
	]
	super._ready()
