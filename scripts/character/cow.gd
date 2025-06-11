extends CharacterBody2D

@onready var animated_sprite = $Animated

var speed := 20
var direction := Vector2.ZERO
var time_elapsed := 0.0
var move_interval := 1.5  # tempo entre mudanças de direção

func _process(delta):
	time_elapsed += delta

	# Muda a direção após um intervalo de tempo
	if time_elapsed >= move_interval:
		choose_random_direction()
		time_elapsed = 0.0

	velocity = direction * speed

	# Move a galinha
	move_and_slide()

	# Atualiza a animação de acordo com a direção
	update_animation()

func choose_random_direction():
	var dirs = [
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.UP,
		Vector2.DOWN,
		Vector2.ZERO  # Ficar parado às vezes
	]
	direction = dirs[randi() % dirs.size()]

func update_animation():
	if direction == Vector2.ZERO:
		animated_sprite.stop()
	else:
		if direction == Vector2.LEFT:
			animated_sprite.flip_h = false
			animated_sprite.play("walk_left")
		elif direction == Vector2.RIGHT:
			animated_sprite.flip_h = true
			animated_sprite.play("walk_right")
		elif direction == Vector2.UP:
			animated_sprite.play("walk_up")
		elif direction == Vector2.DOWN:
			animated_sprite.play("walk_down")
