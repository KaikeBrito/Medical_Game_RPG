# Pergaminho.gd
extends Area2D

signal pergaminho_coletado

# Ajuste o caminho para apontar para o UI_Pergaminho na sua árvore
@onready var ui = get_node("../UI_Pergaminho")  

func _ready() -> void:
	monitoring = true
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# Verifica se quem entrou é o jogador
	if not body.is_in_group("Player"):
		return

	# Tenta adicionar ao inventário do jogador; 
	# `body.canvas_layer` deve apontar para o nó que gerencia o inventário
	var texture = $Sprite.texture
	if body.canvas_layer.add_item_inventory(texture):
		print("🏺 Pergaminho adicionado ao inventário!")
		
		# Emite o sinal, caso algo mais escute
		emit_signal("pergaminho_coletado")
		
		# Abre a UI de narrativa
		ui.mostrar_pergaminho(
			"Em meio às ruínas antigas, você encontra um pergaminho desgastado pelo tempo.\n" +
			"Ele fala sobre uma civilização perdida e um artefato poderoso escondido nas profundezas do templo.\n" +
			"Prepare-se para a aventura que está por vir!"
		)
		
		# Remove o pergaminho do mapa
		queue_free()
	else:
		print("❌ Inventário cheio — não foi possível pegar o pergaminho.")
