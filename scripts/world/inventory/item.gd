extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# Verifica se o objeto que entrou na área de colisão possui um 'canvas_layer'
	# e tenta adicionar o item ao inventário
	if body.canvas_layer.add_item_inventory($sprite.texture):
		# Se o item foi adicionado com sucesso ao inventário, remove este objeto da cena
		queue_free()
