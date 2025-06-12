# res://scripts/battles/battle_manager.gd
extends Node

@onready var player           = $"../CanvasLayer/Characters/Player"
@onready var enemy            = $"../CanvasLayer/Characters/Enemy"
@onready var attack_button    = $"../CanvasLayer/Panel/Attack"    as Button
@onready var defense_button   = $"../CanvasLayer/Panel/Defense"   as Button
@onready var skip_button      = $"../CanvasLayer/Panel/Skip"      as Button
@onready var player_bar       = player.get_node("ProgressBarPlayer") as ProgressBar
@onready var enemy_bar        = enemy.get_node("ProgressBarEnemy")  as ProgressBar
@onready var victory_label    = $"../CanvasLayer/VictoryLabel" as Label
@onready var defeat_label     = $"../CanvasLayer/DefeatLabel"  as Label
@onready var xp_bar           = $"../CanvasLayer/XPBar" as ProgressBar
@onready var xp_label         = $"../CanvasLayer/XPLabel" as Label

var player_turn      = true
var player_defending = false

func _ready():
	# Configura o inimigo com base em Global.current_enemy
	if Global.current_enemy:
		if Global.current_enemy.name == "Slime":
			# Configura o Slime
			enemy.max_health = 80
			enemy.health = 80
			enemy.attack_damage = 15
			# Mantém sprites e animações do Slime (definidos na battle_scene.tscn)
			var battle_anim_tree = enemy.get_node("AnimationTreeEnemy") as AnimationTree
			if battle_anim_tree:
				battle_anim_tree.active = true
				var state = battle_anim_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
				state.travel("idle_left")
			# Altera o script do nó Enemy para slime_battle.gd
			enemy.set_script(load("res://scripts/battles/slime_battle.gd"))
		else:
			# Configura outros NPCs
			enemy.max_health = Global.current_enemy.max_health
			enemy.health = Global.current_enemy.health
			enemy.attack_damage = Global.current_enemy.attack_damage
			var enemy_sprite = Global.current_enemy.get_node("Animated") as AnimatedSprite2D
			var battle_enemy_sprite = enemy.get_node("AnimatedSprite2D") as AnimatedSprite2D
			if enemy_sprite and battle_enemy_sprite:
				battle_enemy_sprite.sprite_frames = enemy_sprite.sprite_frames
				battle_enemy_sprite.play("idle")
			var enemy_anim_tree = Global.current_enemy.get_node("AnimationTreeEnemy") as AnimationTree
			var battle_anim_tree = enemy.get_node("AnimationTreeEnemy") as AnimationTree
			if enemy_anim_tree and battle_anim_tree:
				battle_anim_tree.tree_root = enemy_anim_tree.tree_root.duplicate()
				battle_anim_tree.active = true
				var state = battle_anim_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
				state.travel("idle_left")

	# Conecta botões
	attack_button.pressed.connect(_on_attack)
	defense_button.pressed.connect(_on_defend)
	skip_button.pressed.connect(_on_skip)

	# Atualiza UI inicial
	player_bar.value = float(player.health) / player.max_health * 100
	enemy_bar.value = float(enemy.health) / enemy.max_health * 100
	victory_label.visible = false
	defeat_label.visible = false
	_update_ui()
	_update_xp_bar()

func _on_attack():
	if not player_turn or player.is_dead():
		return
	await player.attack(enemy)
	_after_player_action()

func _on_defend():
	if not player_turn or player.is_dead():
		return
	player_defending = true
	_after_player_action()

func _on_skip():
	if not player_turn or player.is_dead():
		return
	_after_player_action()

func _after_player_action():
	player_turn = false
	_update_ui()

	if enemy.is_dead():
		_on_victory()
		return

	await get_tree().create_timer(1.0).timeout
	await _enemy_turn()

func _enemy_turn():
	if enemy.is_dead():
		return
	await enemy.attack(player, player_defending)
	player_defending = false

	if player.is_dead():
		_on_defeat()
		return

	player_turn = true
	_update_ui()

func _update_ui():
	player_bar.value = float(player.health) / player.max_health * 100
	enemy_bar.value = float(enemy.health) / enemy.max_health * 100
	attack_button.disabled = not player_turn
	defense_button.disabled = not player_turn
	skip_button.disabled = not player_turn

func _update_xp_bar():
	# CORRIGIDO: Usa o nome do Autoload (o objeto)
	var current = float(XPManager.current_xp)
	var total = float(XPManager.xp_to_next_level)
	var level = XPManager.level
	
	xp_bar.max_value = total
	xp_bar.value = lerp(xp_bar.value, current, 0.25)
	xp_label.text = "Nível %d - %d / %d XP" % [level, current, total]

func _on_victory():
	XPManager.gain_xp(50)
	_update_xp_bar()
	victory_label.visible = true
	attack_button.disabled = true
	defense_button.disabled = true
	skip_button.disabled = true

	await get_tree().create_timer(2.0).timeout

	if Global.current_enemy != null:
		Global.current_enemy.queue_free()
		Global.current_enemy = null

	get_tree().paused = false
	get_parent().queue_free()

func _on_defeat():
	defeat_label.visible = true
	attack_button.disabled = true
	defense_button.disabled = true
	skip_button.disabled = true

	await get_tree().create_timer(2.0).timeout

	get_tree().paused = false
	get_parent().queue_free()
	get_tree().reload_current_scene()
