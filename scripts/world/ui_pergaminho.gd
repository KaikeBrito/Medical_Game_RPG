extends CanvasLayer

func _ready() -> void:
	visible = false

func mostrar_pergaminho(texto: String) -> void:
	print("📜 mostrar_pergaminho chamado!")
	# Se a sua hierarquia for Panel → Sprite2D → Label:
	$Panel/Label.text = texto
	visible = true

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		visible = false


func _on_pergaminho_pergaminho_coletado() -> void:
	pass # Replace with function body.
