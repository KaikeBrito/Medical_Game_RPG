extends Control  # O script é anexado a um nó do tipo Control (um slot do inventário)

# Função chamada quando o usuário inicia o arraste do item
func _get_drag_data(_position: Vector2):
	# Cria um dicionário com os dados do item sendo arrastado
	var data := {
		"sprite": $sprite.texture,  # Ícone do item
		"amount": $amount.text,  # Quantidade do item
		"backup": self  # Referência ao slot original (para restaurar caso necessário)
	}
	
	# Cria uma cópia do slot atual para usar como pré-visualização
	var preview = self.duplicate()
	
	# Esconde elementos desnecessários na pré-visualização do item arrastado
	preview.get_node("background").hide()
	preview.get_node("amount").hide()
	
	# Centraliza a sprite na pré-visualização
	preview.get_node("sprite").position = -preview.size / 2
	
	# 🔹 Reduz o tamanho da pré-visualização do item arrastado
	preview.scale = Vector2(0.1, 0.2)  # Ajuste conforme necessário

	# Define o slot original como vazio enquanto o item está sendo arrastado
	set_empty_slot()

	# Define a pré-visualização do arraste
	set_drag_preview(preview)
	
	# Retorna os dados do item sendo arrastado
	return data  

# Função para limpar um slot, tornando-o vazio
func set_empty_slot() -> void:
	$sprite.texture = null  # Remove a textura do item
	$amount.text = ""  # Remove a quantidade do item

# Verifica se o slot pode receber um item solto nele (sempre retorna true no momento)
func _can_drop_data(_position: Vector2, data) -> bool:
	return true  

# Função chamada quando um item é solto sobre este slot
func _drop_data(position: Vector2, data) -> void:
	# Se o item já existir no slot e for o mesmo, soma as quantidades
	if $sprite.texture == data.sprite and $sprite.texture != null:
		var drop_item = int($amount.text) + int(data.amount)  # Soma as quantidades
		$amount.text = str(drop_item)  # 🔹 Converte para string e atualiza a quantidade
	else:
		# Caso seja um item diferente, realiza a troca entre os slots
		data.backup.get_node("sprite").texture = $sprite.texture
		data.backup.get_node("amount").text = $amount.text
		$sprite.texture = data.sprite
		$amount.text = data.amount  
