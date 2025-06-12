# res://scripts/battles/slime_battle.gd
extends CharacterBody2D

@onready var anim_tree      = $AnimationTreeEnemy
@onready var state_machine  = anim_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var progress_bar   = $ProgressBarEnemy

var max_health := 80
var health := max_health
var attack_damage := 15

func _ready():
	anim_tree.active = true
	state_machine.travel("idle_left")
	update_health_bar()

func attack(target, target_defending := false):
	state_machine.travel("attack")
	await get_tree().create_timer(0.5).timeout
	var dmg = attack_damage
	if target_defending:
		dmg = int(floor(dmg / 2.0))
	target.take_damage(dmg)
	state_machine.travel("idle_left")

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
