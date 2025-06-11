extends CharacterBody2D

@onready var label_interacao: Label       = $LabelInteracao
@onready var caixa_dialogo: Label         = $CanvasLayer/CaixadeDialogo
@onready var texto_dialogo: Label         = $CanvasLayer/TextoDialogo
@onready var sprite: AnimatedSprite2D     = $Animated
@onready var interaction_zone: Area2D     = $InteractionZone

# Pontos de vai-e-volta
var waypoints: Array[Vector2] = [ Vector2(218,325), Vector2(300,325) ]
var current_wp := 0
var speed: float = 40.0

# Estado do diálogo
var player_in_area = false
var falando = false
var pode_avancar = false
var fala_index = 0
var falas = [
	"Bem-vindo, jovem Kuaray. Antes de a treva cair sobre nossas terras, vivíamos em paz com a floresta de Tiwahan.",
	"Cantávamos para Ñande ao amanhecer, colhíamos fruto e curávamos feridas com ervas sagradas.",
	"Mas na noite da Lua Negra, seis sombras surgiram e tomaram nossas casas ancestrais – cada lar profanado por um invasor sedento por poder.",
	"Os tambores calaram-se, e um silêncio frio tomou conta do vilarejo.",
	"Agora, cabe a ti seguir seu chamado: visite cada casa, reencontre os Símbolos de Proteção que ali guardávamos, e enfrente os usurpadores que se apossaram delas. Só assim devolveremos a luz ao nosso povo.",
	"Mas antes para testar seus ataques e técnicas herdadas por gerações bata nesse slime para iniciar o modo de batalha.",
	"Boa sorte e uma ótima jornada, vai precisar."
]

func _ready() -> void:
	interaction_zone.body_entered.connect(_on_zone_body_entered)
	interaction_zone.body_exited.connect(_on_zone_body_exited)
	_reset_dialogo()
	global_position = waypoints[0]

func _physics_process(delta: float) -> void:
	if not falando:
		_move_back_and_forth(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_area:
		if not falando:
			iniciar_dialogo()
		elif pode_avancar:
			proxima_fala()

func _move_back_and_forth(delta: float) -> void:
	var target = waypoints[current_wp]
	var dir = target - global_position
	if dir.length() < 4:
		current_wp = (current_wp + 1) % waypoints.size()
		return
	dir = dir.normalized()
	velocity = dir * speed
	move_and_slide()
	sprite.play("walk_right")
	sprite.flip_h = dir.x < 0

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
	# bloqueia input até terminar o texto
	pode_avancar = false
	if fala_index < falas.size():
		texto_dialogo.text = ""
		_type_text(falas[fala_index])
		fala_index += 1
	else:
		encerrar_dialogo()

# Tornamos esta função async, no escopo da classe
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
