extends CharacterBody2D
class_name Enemy

# 🔹 Stats do inimigo
@export_category("Enemy Stats")
@export var move_speed: float = 64.0
@export var detection_radius: float = 200.0
@export var attack_radius: float = 32.0
@export var change_dir_interval: float = 2.0

# 🔹 Fricção e aceleração
@export var friction: float = 0.2
@export var acceleration: float = 0.2

# 🔹 Animação
@export_category("Animation")
@onready var animation_tree: AnimationTree = $AnimationTree
var state_machine

# 🔹 Estados da IA
enum {
	STATE_PATROL,
	STATE_CHASE,
	STATE_ATTACK
}
var state: int = STATE_PATROL

# 🔹 Patrulha aleatória
var patrol_timer: float = 0.0
var patrol_dir: Vector2 = Vector2.ZERO

# 🔹 Jogador (pode não existir; aí só patrulha)
var player: Node2D = null

var health := 50  # Vida inicial do slime

func _ready() -> void:
	add_to_group("Enemy")  # Adiciona ao grupo "enemy"
	state_machine = animation_tree["parameters/playback"]
	var plist = get_tree().get_nodes_in_group("Player")
	if plist.size() > 0:
		player = plist[0]
	else:
		push_warning("Enemy: não encontrou nó em grupo 'Player'; vai patrulhar só.")
	_pick_new_patrol_dir()

func _physics_process(delta: float) -> void:
	# 1) Determina o estado
	if player:
		var to_player = player.global_position - global_position
		var dist = to_player.length()
		if dist <= attack_radius:
			state = STATE_ATTACK
		elif dist <= detection_radius:
			state = STATE_CHASE
		else:
			state = STATE_PATROL
	else:
		state = STATE_PATROL

	# 2) Calcula a velocidade desejada
	var desired: Vector2 = Vector2.ZERO
	match state:
		STATE_PATROL:
			desired = _patrol(delta)
		STATE_CHASE:
			desired = _chase(player.global_position - global_position)
		STATE_ATTACK:
			desired = Vector2.ZERO

	# 3) Escolhe coeficiente de suavização
	var smooth = friction if state == STATE_PATROL else acceleration

	# 4) Aplica LERP para suavizar
	velocity.x = lerp(velocity.x, desired.x, smooth)
	velocity.y = lerp(velocity.y, desired.y, smooth)

	# 5) Anima e move
	_animate()
	move_and_slide()

func _patrol(delta: float) -> Vector2:
	patrol_timer += delta
	if patrol_timer >= change_dir_interval:
		patrol_timer = 0.0
		_pick_new_patrol_dir()
	return patrol_dir * move_speed

func _chase(to_player: Vector2) -> Vector2:
	return to_player.normalized() * move_speed * 1.2

func _pick_new_patrol_dir() -> void:
	patrol_dir = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

func _animate() -> void:
	# blend_position recebe a direção do movimento (ou zero se estiver parado)
	var mov_dir = velocity.normalized() if velocity.length() > 0.1 else Vector2.ZERO
	animation_tree["parameters/idle/blend_position"] = mov_dir
	animation_tree["parameters/walk/blend_position"] = mov_dir

	# troca de animação conforme estado
	match state:
		STATE_PATROL, STATE_CHASE:
			if velocity.length() > 2:
				state_machine.travel("walk")
			else:
				state_machine.travel("idle")
				
# Função para aplicar dano ao slime
func take_damage(amount: int):
	health -= amount  
	if health <= 0:
		die()  
				
func die():
	if player and player.has_method("gain_xp"):
		player.gain_xp(30)
		
	queue_free()
