# res://scripts/GameManager.gd
extends Node

# ─── Estado salvo do jogador ─────────────────
var player_health: int = 100
var player_max_health: int = 100
var player_xp: int = 0
var player_level: int = 1
var player_xp_to_next: int = 100

# ─── Salvar estado antes de batalha ───────────
func save_player_state(h: int, max_h: int, xp: int, lvl: int, xp_next: int) -> void:
	player_health      = h
	player_max_health  = max_h
	player_xp          = xp
	player_level       = lvl
	player_xp_to_next  = xp_next

# ─── Carregar estado ao retornar ao mapa ──────
func load_player_state(target) -> void:
	# target deve ter: health, max_health, xp_system.current_xp, xp_system.level e xp_system.xp_to_next_level
	target.health                   = player_health
	target.max_health               = player_max_health
	target.xp_system.current_xp     = player_xp
	target.xp_system.level          = player_level
	target.xp_system.xp_to_next_level = player_xp_to_next
