extends CharacterBody2D
class_name Character
# 🔹 Categoria de variáveis exportáveis no editor
@export_category("Variables")
@export var _move_speed: float = 64.0  # Velocidade de movimento do personagem
var _state_machine  # Referência para a máquina de estados da animação
@export var _friction: float = 0.2  # Fator de atrito para suavizar o movimento
@export var _acceleration: float = 0.2  # Fator de aceleração ao iniciar o movimento
@onready var canvas_layer: CanvasLayer = get_parent().get_parent().get_node("CanvasLayer") # Referência à camada de interface (HUD, UI)

# 🔹 Categoria de objetos exportáveis no editor
@export_category("Objects")
@onready var _animation_tree: AnimationTree = get_node("AnimationTree")

func _ready() -> void:
	# Obtém a máquina de estados da animação a partir do AnimationTree
	_state_machine = _animation_tree["parameters/playback"]

func _physics_process(_delta: float) -> void:
	# Processa o movimento e animação a cada frame de física
	_move()
	_animate()
	move_and_slide()  # Move o personagem aplicando colisões

func _move() -> void:
	# Captura a direção de movimento com base nas teclas pressionadas
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),  # Eixo horizontal (esquerda/direita)
		Input.get_axis("move_up", "move_down")  # Eixo vertical (cima/baixo)
	)

	# Se houver entrada de movimento
	if _direction != Vector2.ZERO:
		# Atualiza a direção da animação
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction

		# Aplica aceleração gradual para suavizar o movimento
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return
	
	# Se não houver entrada de movimento, aplica atrito para desacelerar gradualmente
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)

func _animate() -> void:
	# Se o personagem estiver se movendo (velocidade maior que 2)
	if velocity.length() > 2:
		_state_machine.travel("walk")  # Troca para a animação de caminhada
		return
	
	# Caso contrário, mantém a animação de idle (parado)
	_state_machine.travel("idle")
