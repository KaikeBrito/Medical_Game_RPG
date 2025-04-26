extends CanvasLayer  # Define este nó como uma camada de interface (HUD/UI)

func _process(delta: float) -> void:
	# Verifica se a tecla de cancelar (por padrão "Esc") foi pressionada
	if Input.is_action_just_pressed("ui_cancel"):
		# Alterna a visibilidade do inventário (abre/fecha)
		$Inventory.visible = not $Inventory.visible

# Função para adicionar um item ao inventário
func add_item_inventory(sprite: Texture) -> bool:
	# Percorre todos os slots dentro do contêiner do inventário
	for slot in $Inventory/container.get_children():
		# Verifica se o slot está vazio (sem item)
		if slot.get_node("sprite").texture == null:
			# Adiciona o sprite do item ao slot vazio
			slot.get_node("sprite").texture = sprite
			# Define a quantidade inicial como 1
			slot.get_node("amount").text = "1"
			return true  # Retorna verdadeiro indicando que o item foi adicionado
	
	# Se não houver slots vazios, retorna falso
	return false
