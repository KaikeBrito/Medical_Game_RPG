# res://scripts/battles/npc_enemy.gd
extends CharacterBody2D
class_name NPCEnemy


@export_category("Battle Stats")
@export var max_health: int = 100
@export var health: int = 100
@export var attack_damage: int = 15
@export var battle_scene_path: String = "res://scenes/battles/battle_scene.tscn"


# Diálogo
@export_category("Dialogue")
@export var falas: Array[String] = []
@onready var label_interacao: Label = $LabelInteracao
@onready var caixa_dialogo: Label = $CanvasLayer/CaixadeDialogo
@onready var texto_dialogo: Label = $CanvasLayer/TextoDialogo
@onready var sprite: AnimatedSprite2D = $Animated
@onready var interaction_zone: Area2D = $InteractionZone
@onready var progress_bar: ProgressBar = $ProgressBarEnemy

# Animação de batalha
@onready var anim_tree: AnimationTree = $AnimationTreeEnemy
@onready var state_machine = anim_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback

# Estado do diálogo
var player_in_area: bool = false
var falando: bool = false
var pode_avancar: bool = false
var fala_index: int = 0

func _ready() -> void:
	add_to_group("Enemy")
	interaction_zone.body_entered.connect(_on_zone_body_entered)
	interaction_zone.body_exited.connect(_on_zone_body_exited)
	_reset_dialogo()
	sprite.play("idle")
	anim_tree.active = true
	state_machine.travel("idle_left")
	update_health_bar()

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()
	sprite.play("idle")
	# Verifica input para batalha
	if player_in_area and (Input.is_action_just_pressed("battle") or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		_start_battle()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_area:
		if not falando:
			iniciar_dialogo()
		elif pode_avancar:
			proxima_fala()

func _on_zone_body_entered(body: Node) -> void:
	if body.name == "Character":
		player_in_area = true
		label_interacao.text = "Pressione 'E' para dialogar ou 'Q'/Botão Direito para batalhar"
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

func _start_battle() -> void:
	Global.current_enemy = self
	var battle_scene = load(battle_scene_path).instantiate()
	battle_scene.name = "BattleScene"
	get_tree().root.add_child(battle_scene)
	var viewport_size = get_viewport().get_visible_rect().size
	battle_scene.position = viewport_size / 2
	get_tree().paused = true
	battle_scene.process_mode = Node.PROCESS_MODE_ALWAYS

# Funções de batalha (de enemy.gd)
func attack(target, target_defending: bool = false) -> void:
	state_machine.travel("attack")
	await get_tree().create_timer(0.5).timeout
	var dmg = attack_damage
	if target_defending:
		dmg = int(floor(dmg / 2.0))
	target.take_damage(dmg)
	state_machine.travel("idle_left")

func take_damage(amount: int) -> void:
	health = max(0, health - amount)
	update_health_bar()
	if health == 0:
		die()

func update_health_bar() -> void:
	progress_bar.value = float(health) / max_health * 100

func die() -> void:
	state_machine.travel("die")

func is_dead() -> bool:
	return health <= 0
