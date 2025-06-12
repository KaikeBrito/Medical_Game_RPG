# res://globais/xp_system.gd

# AQUI! Esta linha CRIA a classe "XPSystem" e a torna globalmente reconhecida.
class_name XPSystem
extends Node

# ─── Variáveis de XP ────────────────────────
var current_xp: int = 0
var level:       int = 1
var xp_to_next_level: int = 100

# ─── Ganho de XP ────────────────────────────
func gain_xp(amount: int) -> void:
	current_xp += amount
	print("Ganhou %d XP. XP total: %d/%d" % [amount, current_xp, xp_to_next_level])
	
	while current_xp >= xp_to_next_level:
		current_xp -= xp_to_next_level
		level += 1
		xp_to_next_level = calculate_xp_for_level(level)
		_on_level_up()
	
	emit_signal("stats_changed", current_xp, xp_to_next_level, level)

# ─── Cálculo de XP para próximo nível ───────
func calculate_xp_for_level(lv: int) -> int:
	return 100 + 50 * (lv - 1)

# ─── Callback de level up ───────────────────
func _on_level_up() -> void:
	print("🔺 Level up! Agora você está no nível %d" % level)
	emit_signal("level_up", level)

# ─── Sinais para a interface (UI) ───────────
signal level_up(new_level)
signal stats_changed(new_xp, xp_needed, new_level)
