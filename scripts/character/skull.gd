extends CharacterBody2D

@onready var label_interacao: Label       = $LabelInteracao
@onready var caixa_dialogo: Label         = $CanvasLayer/CaixadeDialogo
@onready var texto_dialogo: Label         = $CanvasLayer/TextoDialogo
@onready var sprite: AnimatedSprite2D     = $Animated
@onready var interaction_zone: Area2D     = $InteractionZone

# Estado do diálogo
var player_in_area = false
var falando = false
var pode_avancar = false
var fala_index = 0
var falas = [
	"Quantos fios de esperança ainda te restam, guerreirinho?",
	"Eu vejo tua alma enredada... lutando contra um destino inevitável.",
	"Continue dançando, pequeno tolo, minha teia já envolve teus passos."
]

func _ready() -> void:
	interaction_zone.body_entered.connect(_on_zone_body_entered)
	interaction_zone.body_exited.connect(_on_zone_body_exited)
	_reset_dialogo()

func _physics_process(delta: float) -> void:
	# Sempre parado; animação idle
	velocity = Vector2.ZERO
	move_and_slide()
	sprite.play("idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_area:
		if not falando:
			iniciar_dialogo()
		elif pode_avancar:
			proxima_fala()

func _on_zone_body_entered(body: Node) -> void:
	if body.name == "Character":
		player_in_area = true
		label_interacao.text = "Pressione 'E' para interagir"
		label_interacao.visible = true

func _on_zone_body_exited(body: Node) -> void:
	if body.name == "Character":
		player_in_area = false
		label_interacao.visible = false
		if falando:
			encerrar_dialogo()

func iniciar_dialogo() -> void:
	falando = true
	label_interacao.visible = false
	caixa_dialogo.visible = true
	texto_dialogo.visible = true
	fala_index = 0
	proxima_fala()

func proxima_fala() -> void:
	pode_avancar = false
	if fala_index < falas.size():
		texto_dialogo.text = ""
		_type_text(falas[fala_index])
		fala_index += 1
	else:
		encerrar_dialogo()

func _type_text(texto: String) -> void:
	await get_tree().create_timer(0.1).timeout
	for letra in texto:
		texto_dialogo.text += letra
		await get_tree().create_timer(0.02).timeout
	pode_avancar = true

func encerrar_dialogo() -> void:
	_reset_dialogo()

func _reset_dialogo() -> void:
	falando = false
	pode_avancar = false
	texto_dialogo.visible = false
	caixa_dialogo.visible = false
	label_interacao.visible = player_in_area
