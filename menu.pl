
% main menu
menu :-
    displayMenu,
    read_until_between('Pick an option.', 0,4, Option),
    option_selected(Option).

% case option ir exit
option_selected(0) :-
    /*exit program upon input 0 in main menu.*/
    write('\n| Thanks for playing Barca |\n\n').

option_selected(1). 
option_selected(2). 
option_selected(3). 
option_selected(4). 



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
    write('*        [0]  Exit                                                *'),nl,
    write('*                                                                 *'),nl,
    write('*******************************************************************'),nl,nl.


/*goToMenu(Input):-
    write('\nPress [0] to go back to MAIN MENU.\n\n'),
    read(Input),
    travelBack(Input).

travelBack(0):-
    return to menu function
    menu.
*/