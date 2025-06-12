extends NPCEnemy


func _ready() -> void:
	 # Chama o _ready() de npc_enemy.gd para inicializar diálogo e batalha
	max_health = 60   # Saúde máxima do NPC
	health = 60       # Saúde atual
	attack_damage = 15  # Dano de ataque
	battle_scene_path = "res://scenes/battles/battle_scene_orc.tscn"
	falas = [
		"Eu sou a ausência... sou o silêncio após o último tambor.",
		"Você protege uma terra condenada. Lute, se quiser, será apenas ritual.",
		"Eu devoro sonhos, tradições, futuros. E você será o último a ser esquecido."
	]
	super._ready()
