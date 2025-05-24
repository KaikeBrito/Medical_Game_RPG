# Enemy.gd
extends CharacterBody2D
class_name Enemy

# 🔹 Stats do inimigo
@export_category("Enemy Stats")
@export var move_speed: float = 64.0
@export var change_dir_interval: float = 2.0

# 🔹 Fricção e aceleração (aplicada sempre igual)
@export var smoothness: float = 0.2

# 🔹 Animação
@export_category("Animation")
@onready var animation_tree: AnimationTree = $AnimationTree
var state_machine

# 🔹 Patrulha aleatória
var patrol_timer: float = 0.0
var patrol_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("Enemy")
	state_machine = animation_tree["parameters/playback"]
	_pick_new_patrol_dir()

func _physics_process(delta: float) -> void:
	# Sempre patrulha
	patrol_timer += delta
	if patrol_timer >= change_dir_interval:
		patrol_timer = 0.0
		_pick_new_patrol_dir()

	# Calcular velocidade desejada
	var desired_vel = patrol_dir * move_speed

	# Suaviza transição de velocidade
	velocity.x = lerp(velocity.x, desired_vel.x, smoothness)
	velocity.y = lerp(velocity.y, desired_vel.y, smoothness)

	# Anima e move
	_animate()
	move_and_slide()

func _pick_new_patrol_dir() -> void:
	# Gera direção aleatória normalizada
	patrol_dir = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

func _animate() -> void:
	# Blend de direção
	var mov_dir = velocity.normalized() if velocity.length() > 0.1 else Vector2.ZERO
	animation_tree["parameters/idle/blend_position"] = mov_dir
	animation_tree["parameters/walk/blend_position"] = mov_dir

	# Escolhe "walk" ou "idle" dependendo se está se movendo
	if mov_dir == Vector2.ZERO:
		state_machine.travel("idle")
	else:
		state_machine.travel("walk")
