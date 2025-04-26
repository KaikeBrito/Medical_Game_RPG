# res://scripts/battles/battle_manager.gd
extends Node   # este script está no nó BattleManager, filho de BattleScene

@onready var player           = $"../Characters/Player"
@onready var enemy            = $"../Characters/Enemy"
@onready var attack_button    = $"../CanvasLayer/Panel/Attack"    as Button
@onready var defense_button   = $"../CanvasLayer/Panel/Defense"   as Button
@onready var skip_button      = $"../CanvasLayer/Panel/Skip"      as Button
@onready var player_bar       = player.get_node("ProgressBarPlayer") as ProgressBar
@onready var enemy_bar        = enemy.get_node("ProgressBarEnemy")  as ProgressBar
@onready var victory_label    = $"../CanvasLayer/Panel/VictoryLabel" as Label
@onready var defeat_label     = $"../CanvasLayer/Panel/DefeatLabel"  as Label

var player_turn      = true
var player_defending = false

func _ready():
	# conecta sinais
	attack_button.pressed.connect(_on_attack)
	defense_button.pressed.connect(_on_defend)
	skip_button.pressed.connect(_on_skip)

	# inicializa UI
	player_bar.value      = 100
	enemy_bar.value       = 100
	victory_label.visible = false
	defeat_label.visible  = false

	_update_ui()

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
	player_bar.value   = float(player.health) / player.max_health * 100
	enemy_bar.value    = float(enemy.health)  / enemy.max_health  * 100
	attack_button.disabled  = not player_turn
	defense_button.disabled = not player_turn
	skip_button.disabled    = not player_turn

func _on_victory():
	victory_label.visible  = true
	attack_button.disabled  = true
	defense_button.disabled = true
	skip_button.disabled    = true
	await get_tree().create_timer(2.0).timeout
	# usa change_scene_to_file em Godot 4
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_defeat():
	defeat_label.visible   = true
	attack_button.disabled  = true
	defense_button.disabled = true
	skip_button.disabled    = true
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
