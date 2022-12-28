% Clears the terminal screen
clear :- write('\e[2J').
clear:-
    write('\33\[2J').

/**
 * invalidDigit(+C)
 *
 * Checks if the char is an invalid digit and clears input if so
 */
invalidDigit(C) :-
    (C < 48 ; C > 57),
    skip_line.

validDigit(C) :- \+ invalidDigit(C), !.

/**
 * readNumber(-X)
 *
 * Reads a number from input
 */
readNumber(X) :- readNumber(X, 0).

readNumber(X, X) :-
    peek_code(10), !,
    skip_line.

readNumber(X, Acc) :-
    get_code(C),
    validDigit(C),
    Real is C - 48,
    Tmp is Acc * 10,
    Acc1 is Tmp + Real,
    readNumber(X, Acc1).

/**
 * read_until_between(+Message, +Min, +Max, -Value)
 *
 * Reads a number from input until the user inserts one between two values
 */
read_until_between(Message,Min, Max, Value) :-
    write(Message),
    format('[~d-~d]: ', [Min, Max]),
    readNumber(Value),
    between(Min, Max, Value), !.

read_until_between(Message,Min, Max, Value) :-
    format('Invalid option! Please choose between ~d and ~d~n', [Min, Max]),
    read_until_between(Message,Min, Max, Value).

choose_piece(game_state(Board, Player), pos(Xi, Yi)):-
    read_piece_pos(pos(Xi, Yi)),
    valid_piece(game_state(Board, Player), pos(Xi, Yi)), !.

choose_piece(game_state(Board, Player), pos(Xi, Yi)):-
    clear,
    display_game(game_state(Board, Player)),
    write('Invalid piece! Please choose another one'),
    nl,
    choose_piece(game_state(Board, Player), pos(Xi, Yi)).

choose_final_pos(game_state(Board,_),  pos(Xi, Yi), pos(Xf, Yf)):-
    read_final_piece_pos(pos(Xf, Yf)),
    nth0(Xi,Board,Row),
    nth0(Yi,Row,Elem),
    valid_moviment(pos(Xi, Yi),pos(Xf, Yf), Elem).

choose_final_pos(game_state(Board, Player), pos(Xi, Yi), pos(Xf, Yf)):-
    clear,
    display_game(game_state(Board, Player)),
    write('Invalid position! Please choose another one'),
    nl,
    choose_final_pos(game_state(Board, Player), pos(Xi, Yi), pos(Xf, Yf)).

choose_move(game_state(Board, Player), pos(Xi, Yi),pos(Xf, Yf)):-
    choose_piece(game_state(Board, Player), pos(Xi, Yi)),
    choose_final_pos(game_state(Board, Player), pos(Xi, Yi), pos(Xf, Yf)).


read_piece_pos(pos(Xi, Yi)):-
    write('Pick a piece.'),
    nl,
    read_until_between('Line?',0,9,Xi),
    read_until_between('Column?',0,9,Yi).

read_final_piece_pos(pos(Xf, Yf)):-
    write('Chose the next position.'),
    nl,
    read_until_between('Line?',0,9,Xf),
    read_until_between('Column?',0,9,Yf).



ask_board_size(BoardSize):-
    write('Please enter the size of the board.'),
    readNumber(BoardSize),
    BoardSize >= 10,
    BoardSize mod 2 =:= 0,!.

ask_board_size(BoardSize):-
    clear,
    write('Invalid size!'),
    nl,
    ask_board_size(BoardSize).

