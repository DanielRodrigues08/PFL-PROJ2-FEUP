
%menu
%Main menu
menu :-
    repeat,
    display_menu,
    read_until_between('Pick an option.', 0,7, Option),
    option_selected(Option).

% option_selected(+Option)
% Seleciona o mmenu indicado pela opção
option_selected(0) :- 
    display_end.

option_selected(7):- 
    display_instructions, 
    go_back.

option_selected(Num):-
    ask_board_size(BoardSize),
    game_init(BoardSize, Num). 

% display_end
% Mostra a mensagem de despedida e encerra o jogo
display_end:-
        nl,nl, clear,
        write(' **************************************************************'),nl,
        write('*                   ######  ##   ##  #####                    *'),nl,
        write('*                   ##      ###  ##  ##   ##                  *'),nl,
        write('*                   ####    ## # ##  ##   ##                  *'),nl,
        write('*                   ##      ##  ###  ##   ##                  *'),nl,
        write('*                   ######  ##   ##  #####                    *'),nl,
        write('*                                                             *'),nl,
        write('*                   Thanks for playing Barca                  *'),nl,
        write('***************************************************************'),nl.
    

% display_menu
% Mostra o menu principal
display_menu :-
    nl,nl, clear,
    write(' ******************************************************************'),nl,
    write('*                                                                 *'),nl,
    write('*        #####       #####    #######    ######    #####          *'),nl,
    write('*        ##   ##    #     #   ##    ##  ##        #     #         *'),nl,
    write('*        ##   ##   ##     ##  ##    ##  ##       ##     ##        *'),nl,
    write('*        #####     #########  ######    ##       #########        *'),nl,
    write('*        ##   ##   ##     ##  ##    ##  ##       ##     ##        *'),nl,
    write('*        ##   ##   ##     ##  ##    ##  ##       ##     ##        *'),nl,
    write('*        #####     ##     ##  ##    ##   ######  ##     ##        *'),nl,
    write('*******************************************************************'),nl,
    write('*                                                                 *'),nl,
    write('*        [1]  Human vs Human                                      *'),nl,
    write('*        [2]  Human vs Computer - Easy Mode                       *'),nl,
    write('*        [3]  Computer vs Human - Easy Mode                       *'),nl,
    write('*        [4]  Human vs Computer - Difficult Mode                  *'),nl,
    write('*        [5]  Computer vs Human - Difficult Mode                  *'),nl,
    write('*        [6]  Computer vs Computer                                *'),nl,
    write('*        [7]  Instructions                                        *'),nl,
    write('*        [0]  Exit                                                *'),nl,
    write('*                                                                 *'),nl,
    write('*******************************************************************'),nl,nl.

% display_end_game
% Mostra a mensagem de end game indicando o vencedor
display_end_game(Winner):-
    nl,nl, clear,
    write(' **************************************************************'),nl,
    write('*                   ######  ##   ##  #####                    *'),nl,
    write('*                   ##      ###  ##  ##   ##                  *'),nl,
    write('*                   ####    ## # ##  ##   ##                  *'),nl,
    write('*                   ##      ##  ###  ##   ##                  *'),nl,
    write('*                   ######  ##   ##  #####                    *'),nl,
    write('*                                                             *'),nl,
    write('*               ###      ###    ###   ###  ######             *'),nl,
    write('*             ##   #    #   #   ##  #  ##  ##                 *'),nl,
    write('*             ##       #######  ##     ##  ####               *'),nl,
    write('*             ##   ##  ##   ##  ##     ##  ##                 *'),nl,
    write('*              #####   ##   ##  ##     ##  ######             *'),nl,
    write('*                                                             *'),nl,
    write('*                       WINNER : '),write(Winner),write('                      *'),nl,
    write('*                                                             *'),nl,
    write('***************************************************************'),nl,
    go_back.

%go_back
% Pergunta ao utilizador se quer voltar ao 
go_back:-
    read_option('\nPress [0] to go back to menu.',0, _),
    back_menu(0).

%back_menu
%Volta ao menu principal
back_menu(0):-
    menu.

%display_instructions
%Mostra as instruções do jogo
display_instructions :-
    write('------------------------------ Game Board ------------------------------'),nl,
    nl,nl,
    write('The board is an NxN squared board, where N is an odd number between'),nl,
    write('11 and 19. The board has a checkered pattern of black and white spaces.'),nl,
    write('The elephants are placed in the center of each player´s back row, the'),nl,
    write('mice in front of the elephants and the lions to the sides of the mice'),nl,
    write('Watering holes are near the center of the game board. Animals are never'),nl,
    write('removed from the game board.'),nl,
    nl,nl,

    write('------------------------------- Gameplay -------------------------------'),nl,
    nl,nl,
    write('In this game, mice can only move horizontally or vertically, while lions'),nl,
    write('can only move diagonally. Elephants, on the other hand, can move in any'),nl,
    write('direction (horizontally, vertically, or diagonally). Players can move'),nl,
    write('their animals to any number of empty squares in a single direction, as'),nl,
    write('long as they do not jump over other animals. It is possible for a'),nl,
    write('player´s animals to be adjacent to each other, but mice are afraid of'),nl,
    write('lions, lions are afraid of elephants, and elephants are afraid of mice.'),nl,
    write('This means that an animal cannot be moved next to the animal it fears,'),nl,
    write('except if the animal is trapped and has no other options. An animal is'),nl,
    write('considered scared when it is next to the animal it fears, and in case,'),nl,
    write('it must move to a safe location before other animals can be moved. If'),nl,
    write('multiple animals are scared, the player must choose one to move.'),nl,

    nl,nl,

    write('------------------------------ How to Win ------------------------------'),nl,
    nl,nl,
    write('The winner is the first player to get 3 of their animals on the watering'),nl,  
    write('holes at the same time. A player can still win if animals are scared or'),nl,
    write('trapped.'),nl.
