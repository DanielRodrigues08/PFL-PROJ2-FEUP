%clear 
%Limpa o terminal
clear :- write('\e[2J').
clear:-
    write('\33\[2J').

%invalidDigit(+Char)
%Verifica se o char é inválido. Se for limpa o input
invalidDigit(C) :-
    (C < 48 ; C > 57),
    skip_line.

%validDigit(+Char)
%Verifica se o char é válido.
validDigit(C) :- 
    \+ invalidDigit(C), !.

%read_number(-Number)
%Lê um número do input buffer
read_number(X) :- 
    read_number(X, 0).

read_number(X, X) :-
    peek_code(10), !,
    skip_line.

read_number(X, Acc) :-
    get_code(C),
    validDigit(C),
    Real is C - 48,
    Tmp is Acc * 10,
    Acc1 is Tmp + Real,
    read_number(X, Acc1).

%read_option(+Message, +Option, +Value)
% Escreve a Message no terminal. Após isto verifica se a opção escolhida pelo utilizador é igual à Option.   
read_option(Message,Option, Value) :-
    write(Message),
    read_number(Value),
    Option =:= Value, !.

read_option(Message,Option, Value) :-
    write('Invalid option!'),
    read_option(Message,Option, Value).

%read_until_between(+Message, +Min, +Max, -Value)
%Lê um número do input enquanto o utilizador não inserir um número que se situa entre o Min e o Max
read_until_between(Message,Min, Max, Value) :-
    write(Message),
    format('[~d-~d]: ', [Min, Max]),
    read_number(Value),
    between(Min, Max, Value), !.

read_until_between(Message,Min, Max, Value) :-
    format('Invalid option! Please choose between ~d and ~d~n', [Min, Max]),
    read_until_between(Message,Min, Max, Value).

%write_initial_positions(+GameState, +ListPositions)
%Imprime no ecrã as posições inicias válidas
write_initial_positions(game_state(Board, _),ListPositions) :-
    write('Valid pices you can move:'),
    nl, 
    write_initial_positions_aux(game_state(Board, _),ListPositions).

%write_initial_positions_aux(+GameState, +ListPositions)
%Predicado auxiliar do write_initial_positions
write_initial_positions_aux(game_state(_, _),[]).
write_initial_positions_aux(game_state(Board, _),[pos(Xi,Yi) | Positions]):-
    nth0(Xi,Board,Row),
    nth0(Yi,Row,Elem),
    print_elem(Elem, C, _,_),
    write(C),
    write(' - '),
    write(pos(Xi,Yi)),
    nl,
    write_initial_positions_aux(game_state(Board, _),Positions).


%human_move(+GameState, -Move)
%Mostra ao jogador as posições iniciais válidas e unifica o Move com o move escolhido 
human_move(game_state(Board, Player), pos(Xi, Yi),pos(Xf, Yf)):-
    valid_initial_positions(game_state(Board, Player), ListPositions),
    write_initial_positions(game_state(Board, Player),ListPositions),
    read_piece_pos(pos(Xi, Yi)),
    read_final_piece_pos(pos(Xf, Yf)).

%read_piece_pos(-InitialPiece)
% Lê a posição inicial da peça escolhida pelo utilizador
read_piece_pos(pos(Xi, Yi)):-
    write('Pick a piece.'),
    nl,
    read_until_between('Line?',0,9,Xi),
    read_until_between('Column?',0,9,Yi).

%read_final_piece_pos(-InitialPiece)
% Lê a posição final da peça pretendida pelo utilizador
read_final_piece_pos(pos(Xf, Yf)):-
    write('Chose the next position.'),
    nl,
    read_until_between('Line?',0,9,Xf),
    read_until_between('Column?',0,9,Yf).

%ask_board_size(-BoardSize)
%Pergunta ao jogador qual é o tamanho do tabuleiro que quer
ask_board_size(BoardSize):-
    write('Please enter the size of the board.'),
    nl,
    read_number(BoardSize),
    BoardSize >= 10,
    BoardSize mod 2 =:= 0,!.

ask_board_size(BoardSize):-
    clear,
    write('Invalid size!'),
    nl,
    ask_board_size(BoardSize).

