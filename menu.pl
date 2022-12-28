
% main menu
menu :-
    repeat,
    display_menu,
    read_until_between('Pick an option.', 0,4, Option),
    option_selected(Option).

% case option ir exit
option_selected(0) :-
    /*exit program upon input 0 in main menu.*/
    write('\n| Thanks for playing Barca |\n\n').

option_selected(1):-
    ask_board_size(BoardSize),
    game_init(BoardSize). 
option_selected(2). 
option_selected(3). 
option_selected(4). 

exitGame :-
    clear, nl,
    menuFill,
    menuText('Thanks for playing!'),
    menuFill.

instructions :-
    clear,
    menuTitle('Instructions'),
    menuEmptyLine,
    displayInstructions,
    menuEmptyLine,

    menuFill, nl,
    write('Press Enter to go back to the Main Menu'),
    skip_line,
    fail. % Go back to menu


% display menu
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
    write('*        [3]  Human vs Computer - Difficult Mode                  *'),nl,
    write('*        [4]  Computer vs Computer                                *'),nl,
    write('*        [5]  Instructions                                        *'),nl,
    write('*        [0]  Exit                                                *'),nl,
    write('*                                                                 *'),nl,
    write('*******************************************************************'),nl,nl.

% display winner
display_winner :-
    nl,nl, clear,
    write(' ************************************************************************'),nl,
    write('*                                                                       *'),nl,
    write('*       ##        ##  ####  ##    ##  ##    ##  #######  #######        *'),nl,
    write('*       ##   ##   ##   ##   ###   ##  ###   ##  ##       ##    ##       *'),nl,
    write('*       ##   ##   ##   ##   ## #  ##  ## #  ##  ##       ##    ##       *'),nl,
    write('*       ##   ##   ##   ##   ##  # ##  ##  # ##  #####    ######         *'),nl,
    write('*       ##   ##   ##   ##   ##   ###  ##   ###  ##       ##    ##       *'),nl,
    write('*       ##   ##   ##   ##   ##    ##  ##    ##  ##       ##    ##       *'),nl,
    write('*        ####  ####   ####  ##     #  ##    ##  #######  ##    ##       *'),nl,
    write('*************************************************************************'),nl,
    write('*                                                                       *'),nl,
    write('*        [1]  Play Again                                                *'),nl,
    write('*        [0]  Exit                                                      *'),nl,
    write('*                                                                       *'),nl,
    write('*************************************************************************'),nl,nl.

% display game over
display_game_over :-
    nl,nl, clear,
    write(' **************************************************************'),nl,
    write('*               ###      ###    ###   ###  ######             *'),nl,
    write('*             ##   #    #   #   ##  #  ##  ##                 *'),nl,
    write('*             ##       #######  ##     ##  ####               *'),nl,
    write('*             ##   ##  ##   ##  ##     ##  ##                 *'),nl,
    write('*              #####   ##   ##  ##     ##  ######             *'),nl,
    write('*                                                             *'),nl,
    write('*               ####    ##   ##  ######  ######               *'),nl,
    write('*              ##   ##  ##   ##  ##      ##   ##              *'),nl,
    write('*              ##   ##  ##   ##  ####    ######               *'),nl,
    write('*              ##   ##   #   #   ##      ##   ##              *'),nl,
    write('*               ####      ###    ######  ##   ##              *'),nl,
    write('***************************************************************'),nl,
    write('*                                                             *'),nl,
    write('*        [1]  Try Again                                       *'),nl,
    write('*        [0]  Exit                                            *'),nl,
    write('*                                                             *'),nl,
    write('***************************************************************'),nl,nl.


/*goToMenu(Input):-
    write('\nPress [0] to go back to MAIN MENU.\n\n'),
    read(Input),
    travelBack(Input).

travelBack(0):-
    return to menu function
    menu.
*/

displayInstructions :-
    menuText('------------------------ Game Board ------------------------'),
    menuEmptyLine,
    menuText('The board is an NxN squared board, where N is an'),
    menuText('odd number between 11 and 19. The board has a checkered'),
    menuText('pattern of black and white spaces, with the four'),
    menuText('corners all being white. It starts off empty.'),
    menuEmptyLine,

    menuText('------------------------ Gameplay ------------------------'),
    menuEmptyLine,
    menuText('The players are Black and White, with Black going first.'),
    menuText('Each has a supply of stones in their color.'),
    menuText('On each turn, a player can take one of the following actions:'),
    menuEmptyLine,
    menuText('->Drop a stone of his color onto a black square. A stone'),
    menuText('may never be placed in a white square.'),
    menuText('->Shift a stone of his color already on the board, in a black'),
    menuText('square, to an adjacent white square.'),
    menuEmptyLine,

    menuText('------------------------ How to Win ------------------------'),
    menuEmptyLine,
    menuText('The winner is the first player to get five of their stones in a row'),
    menuText('horizontally or vertically, or four stones in row diagonally on white'),
    menuText('spaces. Stones on black spaces cannot win with a diagonal line.').