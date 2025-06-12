extends NPCEnemy


func _ready() -> void:
	max_health = 60   # Saúde máxima do NPC
	health = 60       # Saúde atual
	attack_damage = 15  # Dano de ataque
	battle_scene_path = "res://scenes/battles/battle_scene_crew.tscn"
	falas = [
		"Chamas teus ancestrais... mas eles não respondem mais. Estão comigo agora.",
		"Essa terra já é morta. Você apenas não aceitou ainda.",
		"Apenas os tolos acreditam que o passado pode ser salvo."
	]
	super._ready()
