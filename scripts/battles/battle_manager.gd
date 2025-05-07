# res://scripts/battles/battle_manager.gd
extends Node   # este script está no nó BattleManager, filho de BattleScene

@onready var player           = $"../CanvasLayer/Characters/Player"
@onready var enemy            = $"../CanvasLayer/Characters/Enemy"
@onready var attack_button    = $"../CanvasLayer//Panel/Attack"    as Button
@onready var defense_button   = $"../CanvasLayer//Panel/Defense"   as Button
@onready var skip_button      = $"../CanvasLayer/Panel/Skip"      as Button
@onready var player_bar       = player.get_node("ProgressBarPlayer") as ProgressBar
@onready var enemy_bar        = enemy.get_node("ProgressBarEnemy")  as ProgressBar
@onready var victory_label    = $"../CanvasLayer/VictoryLabel" as Label
@onready var defeat_label     = $"../CanvasLayer/DefeatLabel"  as Label
@onready var xp_bar = $"../CanvasLayer/XPBar" as ProgressBar
@onready var xp_label = $"../CanvasLayer/XPLabel" as Label


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
	
func _update_xp_bar():
	var current = float(player.xp_system.current_xp)  # converte para float
	var total = float(player.xp_system.xp_to_next_level)  # converte para float
	var level = player.xp_system.level

	# Atualiza valor e máximo da barra
	xp_bar.max_value = total
	xp_bar.value = lerp(xp_bar.value, current, 0.25)  # animação suave

	# Atualiza o texto do XPText Label
	xp_label.text = "Nível %d - %d / %d XP" % [level, current, total]

	

func _on_victory():
	# Concede XP e atualiza UI
	player.xp_system.gain_xp(50)
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
	# Remove a cena de batalha COMPLETA (nó pai)
	get_parent().queue_free()  # Alterado para remover a cena inteira


func _on_defeat():
	defeat_label.visible = true
	attack_button.disabled = true
	defense_button.disabled = true
	skip_button.disabled = true
	
	await get_tree().create_timer(2.0).timeout
	
	get_tree().paused = false
	# Remove a cena de batalha antes de recarregar
	get_parent().queue_free()  # Adicionado aqui também
	get_tree().reload_current_scene()
