extends Area2D
class_name Portal

# Exporta um PackedScene para o Inspector — mais seguro que string
@export var target_scene: PackedScene

func _ready() -> void:
	# Conecta o sinal do próprio Area2D
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# Debug: imprime quem entrou
	print("Portal detectou:", body.name, "— grupos:", body.get_groups())
	# Verifica se o corpo está no grupo "Character"
	if body.is_in_group("character"):
		print("Carregando cena:", target_scene.resource_path)
		get_tree().call_deferred("change_scene_to_packed", target_scene)
