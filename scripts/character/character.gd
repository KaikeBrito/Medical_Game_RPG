extends CharacterBody2D
class_name Character

# 🔹 Variáveis exportáveis
@export_category("Variables")
@export var move_speed: float = 64.0
@export var friction: float = 0.2
@export var acceleration: float = 0.2
@export var attack_duration: float = 0.3
@export var canvas_layer: CanvasLayer  # Arraste o CanvasLayer aqui no editor

# 🔹 Referências
@export_category("References")
@export var animation_tree: AnimationTree
@export var attack_timer: Timer
@export var attack_area: Area2D

var _state_machine
var _is_attacking: bool = false

func _ready() -> void:
	_state_machine = animation_tree.get("parameters/playback")
	add_to_group("Player")
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.monitoring = false
	canvas_layer = get_tree().get_first_node_in_group("Inventory")
	if canvas_layer == null:
		push_error("CanvasLayer do inventário não encontrado!")

func _physics_process(delta: float) -> void:
	_move()
	_attack()
	_animate()
	move_and_slide()

func _move() -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", direction)
		animation_tree.set("parameters/walk/blend_position", direction)
		animation_tree.set("parameters/attack/blend_position", direction)
		velocity = velocity.lerp(direction.normalized() * move_speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

# Na função _attack():
func _attack() -> void:
	if Input.is_action_just_pressed("attack") and not _is_attacking:
		attack_area.set_deferred("monitoring", true)
		attack_timer.wait_time = attack_duration
		attack_timer.start()
		_is_attacking = true
	elif Input.is_action_just_pressed("battle") and not _is_attacking:
		# Verifica se há inimigos na área
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				call_deferred("_start_battle", body)
				break

# Na função _on_attack_timer_timeout():
func _on_attack_timer_timeout() -> void:
	attack_area.set_deferred("monitoring", false)  # Alterado para set_deferred
	set_physics_process(true)
	_is_attacking = false

func _animate() -> void:
	if _is_attacking:
		_state_machine.travel("attack")
	elif velocity.length() > 10:
		_state_machine.travel("walk")
	else:
		_state_machine.travel("idle")

func _on_attack_area_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		call_deferred("_start_battle", body)  # Adia a criação da batalha

func _start_battle(enemy: Node2D):
	# Carrega a cena de batalha e a coloca EM UMA CAMADA SEPARADA
	var battle_scene = load("res://scenes/battles/battle_scene.tscn").instantiate()
	battle_scene.name = "BattleScene"  # Adicione um nome único para referência
	get_tree().root.add_child(battle_scene)
	
	# Centraliza a cena de batalha na viewport
	var viewport_size = get_viewport().get_visible_rect().size
	battle_scene.position = viewport_size / 2  # Posição central
	
	# Pausa APENAS a cena do level (não a cena de batalha)
	get_tree().paused = true
	
	# Define prioridade de processamento da cena de batalha
	battle_scene.process_mode = Node.PROCESS_MODE_ALWAYS  # Garante que a UI funcione
	Global.current_enemy = enemy
