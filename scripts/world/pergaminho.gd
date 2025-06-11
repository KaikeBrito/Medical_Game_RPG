# Pergaminho.gd
extends Area2D

signal pergaminho_coletado

# Ajuste o caminho para apontar para o UI_Pergaminho na sua árvore
@onready var ui = get_node("../UI_Pergaminho")  

func _ready() -> void:
	monitoring = true
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# Verifica se quem entrou é o jogador
	if not body.is_in_group("Player"):
		return

	# Tenta adicionar ao inventário do jogador; 
	# `body.canvas_layer` deve apontar para o nó que gerencia o inventário
	var texture = $Sprite.texture
	if body.canvas_layer.add_item_inventory(texture):
		print("🏺 Pergaminho adicionado ao inventário!")
		
		# Emite o sinal, caso algo mais escute
		emit_signal("pergaminho_coletado")
		
		# Abre a UI de narrativa
		ui.mostrar_pergaminho(
			"Pergaminho Ancestral de Aruá
			“No coração de Tiwahan, a Terra do Sol Que Nasce, viviam os povos Aruá em harmonia com a floresta sagrada. Sob a proteção de Ñande, o grande Espírito Ancestral, cada gota de chuva e cada folha ao vento carregavam a sabedoria dos antepassados.
			Mas eis que, no ano da Lua Negra, estranhas criaturas surgiram além das Montanhas de Fogo — monstros forjados nas sombras, com garras de noite e olhos feitos de brasa. Chamaram-se os Ikrâ, nascidos do ódio esquecido por antigas escaramuças entre deuses e demônios.
			Ao romper do amanhecer, as trombetas de guerra anunciaram a queda de nossas defesas: aldeias em chamas, tambores silenciados, cantos ancestrais calados pela fúria dos invasores. Em meio ao caos, o jovem guerreiro Kuaray — último descendente da linhagem dos Guardiões da Chama — despertou para o chamado do destino.
			“Ergue-te, filho do Sol, e toma em tuas mãos a Lâmina do Raio Carmesim,” sussurrou o vento, lembrando-lhe dos feitos de seus antepassados. Era ele quem deveria reunir os fragmentos de poder espalhados pela terra profanada — o amuleto de osso do Tatu Rei, a Pedra do Coração da Serpente e as Plumas do Guardião Celeste — para forjar novamente o elo entre o mundo terreno e o mundo dos espíritos.
			Somente devolvendo a luz roubada pelos Ikrâ e restaurando o altar de Ñande no Vale Esquecido, nossos rituais poderão ecoar pelos quatro ventos e banir a escuridão que ameaça engolir Tiwahan.
			Que teu coração seja forte, Kuaray, e que cada passo teu reverbere com a coragem dos antigos. Pois quando o último fragmento ocupar seu lugar na Pedra Sagrada, a fúria dos monstros se quebrará como galhos secos ao vento — e a canção dos Aruá voltará a ressoar, triunfante, sob o sol eterno.”
			— Mémoria dos Anciãos de Tiwahan"
		)
		
		# Remove o pergaminho do mapa
		queue_free()
	else:
		print("❌ Inventário cheio — não foi possível pegar o pergaminho.")
