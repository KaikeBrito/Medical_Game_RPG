# Character.gd
extends CharacterBody2D
class_name Character

# 🔹 Categoria de variáveis exportáveis no editor
@export_category("Variables")
@export var move_speed: float = 64.0        # Velocidade de movimento
@export var friction: float = 0.2           # Atrito para desacelerar
@export var acceleration: float = 0.2       # Aceleração ao mover

# 🔹 Referência ao CanvasLayer (se precisar manipular HUD/UI)
@export_category("References")
@export var canvas_layer_path: NodePath     # Arraste aqui seu nó CanvasLayer
@onready var canvas_layer: CanvasLayer = get_tree().get_current_scene().get_node("CanvasLayer")

# 🔹 Objetos exportáveis
@export_category("Objects")
@export var animation_tree: AnimationTree   # Arraste seu AnimationTree aqui
@export var attack_timer: Timer             # Arraste seu Timer aqui

var _state_machine                          # Máquina de estados da animação
var _is_attacking: bool = false             # Flag de ataque

func _ready() -> void:
	# Configura máquina de estados
	_state_machine = animation_tree.get("parameters/playback")
	# Garante que o personagem entra no grupo correto
	add_to_group("character")
	# Conecta o sinal de timeout do Timer
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _physics_process(delta: float) -> void:
	_move()
	_attack()
	_animate()
	move_and_slide()

func _move() -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up",   "move_down")
	)
	if direction != Vector2.ZERO:
		# Atualiza blend positions
		animation_tree.set("parameters/idle/blend_position", direction)
		animation_tree.set("parameters/walk/blend_position", direction)
		animation_tree.set("parameters/attack/blend_position", direction)
		# Aplica aceleração
		velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, acceleration)
		velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, acceleration)
	else:
		# Aplica atrito
		velocity.x = lerp(velocity.x, 0.0, friction)
		velocity.y = lerp(velocity.y, 0.0, friction)

func _attack() -> void:
	if Input.is_action_just_pressed("attack") and not _is_attacking:
		set_physics_process(false)
		attack_timer.start()
		_is_attacking = true

func _animate() -> void:
	if _is_attacking:
		_state_machine.travel("attack")
	elif velocity.length() > 10:
		_state_machine.travel("walk")
	else:
		_state_machine.travel("idle")

func _on_attack_timer_timeout() -> void:
	# Fim do ataque
	set_physics_process(true)
	_is_attacking = false
