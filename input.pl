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

write_initial_positions(game_state(Board, _),ListPositions) :-
    write('Valid pices you can move:'),
    nl, 
    write_initial_positions_aux(game_state(Board, _),ListPositions).

write_initial_positions_aux(game_state(Board, _),[]).
write_initial_positions_aux(game_state(Board, _),[pos(Xi,Yi) | Positions]):-
    nth0(Xi,Board,Row),
    nth0(Yi,Row,Elem),
    print_elem(Elem, C, _,_),
    write(C),
    write(' - '),
    write(pos(Xi,Yi)),
    nl,
    write_initial_positions_aux(game_state(Board, _),Positions).


%choose_move(+GameState, +Player,+Level, -Move)
human_move(game_state(Board, Player), pos(Xi, Yi),pos(Xf, Yf)):-
    valid_initial_positions(game_state(Board, Player), ListPositions),
    write_initial_positions(game_state(Board, Player),ListPositions),
    read_piece_pos(pos(Xi, Yi)),
    read_final_piece_pos(pos(Xf, Yf)).


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


ask_player(Number):-
    write('Which player do you want to be? (1 or 2)'),
    nl,
    readNumber(Number),
    Number >= 1,
    Number < 3, !.

ask_player(Number):-
    clear,
    write('Invalid number!'),
    nl,
    ask_player(Number).


ask_board_size(BoardSize):-
    write('Please enter the size of the board.'),
    nl,
    readNumber(BoardSize),
    BoardSize >= 10,
    BoardSize mod 2 =:= 0,!.

ask_board_size(BoardSize):-
    clear,
    write('Invalid size!'),
    nl,
    ask_board_size(BoardSize).

