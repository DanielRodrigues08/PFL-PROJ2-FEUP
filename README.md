# Functional and Logic Programming
FEUP L.EIC Y3S1

# Projeto 2 (PFL) - Barca

Ana Sofia Guedes Vieira Santos Costa - up202007602 (50%)
Daniel José Mendes Rodrigues - up202006562 (50%)


##  Instalação e Execução

Para jogar a nossa versão do jogo Barca, é necessário a instalação do interpretador SICStus Prolog 4.7 e o download da pasta onde se encontra o código fonte do jogo.
De seguida, no interpretador, deve ser consultado o ficheiro *main.pl* localizado no diretório descarregado.

    ?- consult('/path/src/main.pl').

Se utilizar Windows, podes carregar no botão da gui `File` -> `Consult` e depois selecionar o ficheiro main.pl.
    
Após consultar o ficheiro basta escrever no terminal: 

    ?- play.


## Descrição do jogo
O jogo é composto por um tabuleiro quadrado (NxN, onde N é um número par e maior que 10) com um padrão xadrez de espaços brancos e pretos. Cada jogador tem 6 peças (2 elefantes, 2 ratos e 2 leões), que nunca são removidas do tabuleiro de jogo. 

Em termos de movimento, os ratos só podem se mover horizontal ou verticalmente, enquanto que os leões só podem se mover diagonalmente. Já os elefantes podem se mover em qualquer direção (horizontalmente, verticalmente ou diagonalmente). 
Os jogadores podem mover seus animais para qualquer número de quadrados vazios em uma única direção, desde que eles não saltem por cima de outros animais. É possível que os animais de um jogador estejam adjacentes um ao outro, mas os ratos têm medo dos leões, os leões têm medo dos elefantes e os elefantes têm medo dos ratos. Isso significa que um animal não pode ser movido para perto do animal que tem medo, a menos que o animal esteja preso e não tenha outras opções. 

Um animal é considerado assustado quando está ao lado do animal que tem medo, e nesse caso, deve se mover para um local seguro antes que outros animais possam ser movidos. 

O vencedor é o primeiro jogador se preencher ao mesmo tempo 3 dos 4 poços de água com 3 dos seus animais. 


## Lógica do Jogo

### Representação interna do estado do jogo

O estado de jogo é repesentado pela expressão:

    ?- game_state(Board, Player)
    
O primeiro parâmatro do estado de jogo é o tabuleiro do jogo representado por uma lista de listas :
![](https://i.imgur.com/CVBCyn0.png)

No tabuleiro, cada quadrado íra ter uma das seguintes representações:
- empty -> quadrado vazio;
- water_hole -> representa um poço de água;
- piece(elephant,player1) -> quadrado representa uma peça do tipo elefante do jogador 1.
- piece(elephant,player2) -> quadrado representa uma peça do tipo elefante do jogador 2.
- piece(mouse,player1) -> quadrado representa uma peça do tipo rato do jogador 1.
- piece(mouse,player2) -> quadrado representa uma peça do tipo rato do jogador 2.
- piece(lion,player1) -> quadrado representa uma peça do tipo leão do jogador 1.
- piece(lion,player2) -> quadrado representa uma peça do tipo leão do jogador 2.

O segundo parâmetro do estado de jogo é o jogador atual podendo este variar entre *player1* e *player2*.  

Para criar o estado de jogo foi desenvolvido o predicado initial_state com a seguinte definição :
    
    ?-initial_state(+Size, -GameState) 

Como parâmetros este predicado receberá um size, escolhido pelo utilizador e de seguida verificado pelo programa, e um estado de jogo, onde o Player será definido com o player1.
Neste predicado são chamadas outras funções para criar o tabuleiro (*create_board*) e decidir as posições inicias as peças e dos poços de água de acordo com as regras do jogo (*decide_piece*).

À medida que o jogo vai avançando, como nenhuma peça irá ser retirada do tabuleiro, a cada jogada o valor de Player é atualizado (entre *player1* e *player2*) e no Board as diferentes *pieces* mudam de colunas e linhas dentro da lista de listas.

No estado de jogo final, sendo as coordanadas dos poços de água calculadas através do tamanho do tabuleiro, o tabuleiro tem 3 dos seus quadrados *waterhole* preenchidos com *pieces* do mesmo jogador.


### Visualização do estado de jogo

Para possibilitar a visualização do jogo criado o predicado: 

    ?-display_game(+GameState)
    
Como parâmetro, o predicado recebe o estado de jogo que permitirá mostrar ao utilizador o tabuleiro e indicar quem é o jogador que deve fazer a próxima jogada.

![](https://i.imgur.com/Slzz7cH.png)

Para tentar dar informação ao utilizador, o tabuleiro será dispolibilizado com números que representam as suas linhas e as suas colunas. Foi também acrescentado o caracter '#' em quadrados vazios para dar a ideia de um tabuleiro axadrezado. 
As peças dos diferentes jogadores diferenciam-se através do uso de letras maiúsculas e minúsculas, e a letra pela qual são representadas é a mesma pela qual inicia o seu nome. Enquannto não exitem peças nos locais dos poços de água, estes são representados por 'W'. 
É também disponibilizada uma lista das peças que podem ser movidas no estado de jogo atual.

Para a interface visual do jogo, foi desenvolvido o seguinte menu : 

![](https://i.imgur.com/i4Yfm4T.png)

Escolhendo a opção 7 (*Instructions*) :

![](https://i.imgur.com/h4WAEBe.png)

Escolhendo a opção 0 (*Exit*) : 
![](https://i.imgur.com/hQpvm2K.png)


Qualquer uma das outras levará para o *gameinit* e *game_loop* do respetivo modo escolhido.


### Execução de Jogadas

Para executar as jogadas foi implementado o predicado: 

    ?-move(+GameState, +Move, -NewGameState)
    
Este predicado avalia a jogada escolhida e caso esta seja válida retorna um novo GameState com as alterações efetuadas no tabuleiro e com o próximo jogador. Este predicado recorre ao *valid_move* para validar a jogada. Este verifica as regras do jogo, representadas por predicados.


### Lista de Jogadas Válidas

Para encontrar a lista de jogadas válidas foi criado o predicado: 

    ?-valid_moves(+GameState, -ListOfMoves)

Este predicado recebe uma estado de jogo que, consoante o seu Board e o Player que irá fazer a próxima jogada, retorna uma lista de elementos da estrutura *move_position(InitialPosition, FinalPosition)* que representam todas jogadas que o jogador poderá realizar. O valid_moves recorre ao *findall* e ao *valid_move* para encontrar todas as jogadas.

### Final do Jogo

Para determinar o fim do jogo foi criado o predicado: 

    ?-game_over(+Board, +Player)
    
Este predicado recebe um estado de jogo e um jogador e avalia se o jogador ganhou o jogo. Para isso, e recorrendo a um findall, o predicado verifica se as peças do jogador encontram-se pelo menos em cima de três *water_holes*. 

![](https://i.imgur.com/LCT12Vh.png)


### Avaliação do Tabuleiro

Para determinar o fim do jogo foi criado o predicado: 

    ?-value(+GameState, +Move, +Player, -Value)
    
Este predicado avalia o estado do jogo na perspetiva de um jogador. Recorre então, ao predicado *position_pieces* para obter todas as peças pertencentes ao jogador e posteriormente formular um valor consoante as suas posições. Este valor será a soma de vários coeficientes que simbolizam as difentes situações nas quais uma peça pode estar tendo em conta as regras do jogo.    

### Jogada do Computador

Para determinar o fim do jogo foi criado o predicado: 

    ?-choose_move(+GameState, +Level, -Move)
    
O choose_move escolhe uma jogado tendo em conta o nível(fácil ou difícil) e o estado do jogo, unificando-a com a variável Move. No modo fácil é escolhida uma jogada numa posição aleatória da lista valid_moves. No modo difícil é escolhida uma jogada da lista *valid_moves* que vai levar a um maior valor do tabuleiro, utilizando para isso um algoritmo *greedy*. A lista é obtida do predicado *valid_moves*.  



## Conclusões

O jogo de tabuleiro "Barca" foi implementado com sucesso, seguindo todas as indicações dadas pelo enunciado do projeto. O jogo inclui vários modos, podendo ser jogado por um jogador contra outro jogador, um jogador contra o computador ou um computador contra outro computador. No modo jogador contra o computador, o utilizador pode escolher entre ser o jogador 1 ou 2 e ainda escolher qual da dificuldade do jogo (fácil ou difícil). 

No desenvolvimento do projeto, uma das principais dificuldades centrou-se na implementação de funções para verificar se um movimento era válido. Tendo em conta a complexidade do jogo escolhido, havia muitos fatores a ter em conta, o que tornou esta tarefa mais difícil.

Outra grande dificuldade foi desenvolver o algoritmo que permitia escolher os movimentos do computador no modo difícil. Visto que, para encontrar a melhor joagada através de um algoritmo greedy foi necessário definir o parâmetros de modo a valorizar todas as jogadas possiveis. 

Concluindo, para além de todas as funcionalidades implementadas no nosso jogo, acreditamos que este poderia ser melhorado na escolha da próxima posição do computador no modo díficil. Em vez de utilizar um algoritmo greedy que só tem em conta a melhor posição na próxima jogada, poderíamos utilizar um algoritmo que consiga criar uma estratégia.



## Bibliografia
- https://boardgamegeek.com/boardgame/69347/barca
- https://sicstus.sics.se/documentation.html


