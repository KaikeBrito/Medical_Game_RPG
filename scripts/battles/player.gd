extends CharacterBody2D

@onready var anim_tree      = $AnimationTree
@onready var state_machine  = anim_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var progress_bar   = $ProgressBarPlayer
@onready var attack_area = $Area2D

var max_health := 100
var health := max_health
var xp_system := XPSystem.new()  



func _ready():
	attack_area.body_entered.connect(_on_body_entered)
	add_child(xp_system)
	anim_tree.active = true
	state_machine.travel("idle_right")
	update_health_bar()

func _on_body_entered(body: Node):
	if body.is_in_group("slimes"):  # Verifica se o corpo é um slime
		attack(body)  # Aplica o ataque no slime

func attack(target):
	# Executa a animação de ataque
	state_machine.travel("attack")
	await get_tree().create_timer(0.5).timeout  # Aguarda a animação do ataque (0.5 segundos)

	# Verifica se o alvo pode levar dano
	if target and target.has_method("take_damage"):
		target.take_damage(20)  # Aplica 20 de dano no alvo
	
	# Retorna ao estado "idle" após o ataque
	state_machine.travel("idle_right")
	
	

func take_damage(amount):
	health = max(0, health - amount)
	update_health_bar()
	if health == 0:
		die()

func update_health_bar():
	progress_bar.value = float(health) / max_health * 100

func die():
	state_machine.travel("die")

func is_dead() -> bool:
	return health <= 0
