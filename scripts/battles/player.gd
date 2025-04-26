# res://scripts/battles/player.gd
extends CharacterBody2D

@onready var anim_tree      = $AnimationTree
@onready var state_machine  = anim_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var progress_bar   = $ProgressBarPlayer

var max_health := 100
var health := max_health

func _ready():
	anim_tree.active = true
	state_machine.travel("idle_right")
	update_health_bar()

func attack(target):
	state_machine.travel("attack")
	await get_tree().create_timer(0.5).timeout
	target.take_damage(20)
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
