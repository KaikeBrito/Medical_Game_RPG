extends Node

class_name XPSystem

var current_xp := 0
var level := 1
var xp_to_next_level := 100

func gain_xp(amount: int) -> void:
	current_xp += amount
	print("Ganhou ", amount, " XP. XP total: ", current_xp)

	while current_xp >= xp_to_next_level:
		level_up()

func level_up() -> void:
	current_xp -= xp_to_next_level
	level += 1
	xp_to_next_level = calculate_xp_for_next_level()
	print("🔺 Subiu para o nível ", level, "! XP restante: ", current_xp)

func calculate_xp_for_next_level() -> int:
	return 100 + (level - 1) * 50
