# Nome do Projeto: Vitalis: Epidemia em Pixel Art

## Descrição
"Vitalis: Epidemia em Pixel Art" é um RPG educativo 2D top-down onde você assume o papel de um médico em um vilarejo devastado por uma epidemia. O jogo combina mecânicas de combate por turnos, coleta de recursos, escolhas morais e elementos de estratégia para ensinar conceitos básicos de saúde e ética médica.

## Principais Funcionalidades
- **Combate por turnos** contra patógenos (vírus, bactérias, fungos)
- **Coleta de recursos**: plantas medicinais na Floresta Medicinal
- **Escolhas morais**: alocação de recursos limitados e decisões éticas
- **Sistema de recompensas**: XP por cura correta e captura de antídotos
- **Desbloqueio de habilidades**: como vacinação em massa
- **Simulação da propagação de doenças** usando grafos
- **Árvore de decisão** para apoiar escolhas morais

## Plataformas
- **PC** (Compatível com Windows, Mac e Linux)

## Tecnologias e Ferramentas
- **Engine**: Godot 4.x
- **Arte**: Pixel art retro (inspirada em clássicos como Pokémon)
- **Áudio**: Música instrumental com tons urgentes (combate) e calmos (exploração)
- **Controle de versão**: Git e GitHub
- **Metodologia**: SCRUM

## Instalação
1. Clone este repositório:
   ```bash
   git clone https://github.com/SEU_USUARIO/vitalis-epidemia.git
   cd vitalis-epidemia
   ```
2. Abra o projeto no Godot:
   - Instale [Godot 4.x](https://godotengine.org/download)
   - No Godot, selecione **Import** e aponte para `project.godot`
3. Execute o jogo clicando em **Play** ou pressionando `F5`.

## Como Jogar
- **Movimento**: Use as teclas `W`, `A`, `S`, `D` para mover o personagem.
- **Interação**: Clique com o mouse sobre NPCs, itens e objetos para interagir.
- **Inventário**: Abra com `I` para ver plantas medicinais e antídotos.
- **Combate**: Selecione antídotos e habilidades através da barra de diagnóstico rápido.
- **Mapa**: Pressione `M` para visualizar o mapa interativo do vilarejo.

## Estrutura do Projeto
```
/vitalis-epidemia
├── assets/             # Sprites, ícones e áudio
├── scenes/             # Cenas Godot (vila, floresta, laboratório)
├── scripts/            # Lógicas de jogo (combate, UI, IA)
├── project.godot       # Arquivo de configuração do Godot
├── README.md           # Este documento
└── LICENSE             # Licença do projeto
```

## Cronograma de Desenvolvimento
| Fase               | Objetivos Principais                                  | Prazo        |
|--------------------|-------------------------------------------------------|--------------|
| **Primeira Entrega** | Criação do personagem, mapa da vila, inimigos         | Semana 1     |
| **Segunda Entrega**  | Implementar modo de batalha e coleta de itens         | Semana 3     |
| **Terceira Entrega** | Desenvolvimento da narrativa e laboratório abandonado  | Semana 5     |

## Contribuição
Sua contribuição é bem-vinda! Para colaborar:
1. Faça um fork deste repositório.
2. Crie uma branch: `git checkout -b feature/nova-mecânica`
3. Faça suas alterações e commit: `git commit -m "Adiciona nova mecânica"`
4. Envie para o repositório remoto: `git push origin feature/nova-mecânica`
5. Abra um pull request.

## Equipe
- Kaike Brito Leitão (2214661)
- Enrico Santos Navajas (2219125)
- Luca Fiuza (2219124)
- Vinicius Dias

## Licença
Este projeto está licenciado sob a [MIT License](LICENSE).
