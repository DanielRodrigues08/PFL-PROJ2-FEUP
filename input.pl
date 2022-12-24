

% read_number(-X)
read_number(X):-
    read_number_aux(X,0).

read_number_aux(X,Acc):- 
    get_code(C),
    C >= 48,
    C =< 57,
    !,
    Acc1 is 10*Acc + (C - 48),
    read_number_aux(X,Acc1).
read_number_aux(X,X).

% clear_buffer.
% Clears the input buffer.
clear_buffer(0).
clear_buffer(N):-
    N1 is N-1,
    nl,
    clear_buffer(N1).

% read_until_between(+ Message, +Min, +Max, -Value)
read_until_between(Message,Min,Max,Value):-
    repeat, 
    write(Message),
    nl,
    read_number(Value),
    Value >= Min,
    Value =< Max,
    !.

read_piece_pos(Xi-Yi):-
    write('Pick a piece.'),
    nl,
    read_until_between('Line?',0,9,Xi),
    read_until_between('Column?',0,9,Yi).

read_final_piece_pos(Xf-Yf):-
    write('Chose the next position.'),
    nl,
    read_until_between('Line?',0,9,Xf),
    read_until_between('Line?',0,9,Yf).

clear:-
    write('\33\[2J').