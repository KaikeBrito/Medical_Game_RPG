# XPSystem.gd
extends Node

# ─── Variáveis de XP ────────────────────────
var current_xp: int = 0
var level:      int = 1
var xp_to_next_level: int = 100

# ─── Ganho de XP ────────────────────────────
func gain_xp(amount: int) -> void:
	current_xp += amount
	# Checa e faz level up enquanto ultrapassar o limite
	while current_xp >= xp_to_next_level:
		current_xp -= xp_to_next_level
		level += 1
		xp_to_next_level = calculate_xp_for_level(level)
		_on_level_up()

# ─── Cálculo de XP para próximo nível ───────
func calculate_xp_for_level(lv: int) -> int:
	# Exemplo de fórmula: 100 + 50 * (lv - 1)
	return 100 + 50 * (lv - 1)

# ─── Callback de level up ───────────────────
func _on_level_up() -> void:
	# Aqui você pode tocar um som, emitir sinal, dar skill point, etc.
	print("Level up! Agora você está no nível %d" % level)
	# Exemplo: emitir sinal
	emit_signal("level_up", level)

# ─── Sinal para level up ────────────────────
signal level_up(new_level)
