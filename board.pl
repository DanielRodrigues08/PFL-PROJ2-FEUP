:- use_module(library(lists)).

%initial_state(+Size, -GameState)
% Esta função verifica o size (tem de ser par e superior a 10) e chama a função responsável pela criação do tabuleiro.
% Retorna o estado do jogo, que consiste num termo composto game_state que tem o estado atual do tabuleiro e a vez do jogador (player1 ou player2)
initial_state(Size, game_state(Board, player1)) :-
    Size >= 10,
    Size mod 2 =:= 0,
    create_board(Size, Board).

%create_board(+Size, -Board)
% Esta função é responsável pela criação do tabuleiro
% Recorre a uma funcção auxiliar permitindo a "tail recursion" aumentando a eficiência
create_board(Size, Board) :-
    create_board_aux(Size, Size, [], Board).

%create_board_aux(+Size, ?NRow, ?Acc, -Board)
%Função auxiliar da create_board
create_board_aux(_, 0, Acc, Acc) :- !.
create_board_aux(Size, NRow, Acc, Board) :-
    NRow > 0,
    create_row(Size, NRow, Row),
    NRow1 is NRow - 1,
    create_board_aux(Size, NRow1, [Row | Acc], Board).

%create_row(+Size, ?NRow, -Row)
%% Recorre a uma funcção auxiliar permitindo a "tail recursion" aumentando a eficiência
create_row(Size, NRow, Row) :-
    create_row_aux(Size, NRow, Size, [], Row).

%create_row_aux(+Size, +NRow, ?NColumn, ?Acc, -Row)
%Função auxiliar da create_row
create_row_aux(_, _, 0, Acc, Acc) :- !.
create_row_aux(Size, NRow, NColumn, Acc, Row) :-
    NColumn > 0,
    decide_piece(Size, NRow, NColumn, Piece),
    NColumn1 is NColumn - 1,
    create_row_aux(Size, NRow, NColumn1, [Piece | Acc], Row).

%decide_piece(+Size, +NRow, +NColumn, -Piece)
%Função que retorna o tipo de peça que ocupa uma determinada posição do tabuleiro no estado inicial
decide_piece(Size, 1, NColumn, piece(elephant, player1)) :-
    NColumn =:= Size // 2,
    !.
decide_piece(Size, 1, NColumn, piece(elephant, player1)) :-
    NColumn =:= Size // 2 + 1,
    !.
decide_piece(Size, 2, NColumn, piece(mouse, player1)) :-
    NColumn =:= Size // 2,
    !.
decide_piece(Size, 2, NColumn, piece(mouse, player1)) :-
    NColumn =:= Size // 2 + 1,
    !.
decide_piece(Size, 2, NColumn, piece(lion, player1)) :-
    NColumn =:= Size // 2 + 2,
    !.
decide_piece(Size, 2, NColumn, piece(lion, player1)) :-
    NColumn =:= Size // 2 - 1,
    !.
decide_piece(Size, Size, NColumn, piece(elephant, player2)) :-
    NColumn =:= Size // 2,
    !.
decide_piece(Size, Size, NColumn, piece(elephant, player2)) :-
    NColumn =:= Size // 2 + 1,
    !.
decide_piece(Size, NRow, NColumn, piece(mouse, player2)) :-
    NRow =:= Size - 1, 
    NColumn =:= Size // 2,
    !.
decide_piece(Size, NRow, NColumn, piece(mouse, player2)) :-
    NRow =:= Size - 1,
    NColumn =:= Size // 2 + 1,
    !.
decide_piece(Size, NRow, NColumn, piece(lion, player2)) :-
    NRow =:= Size - 1,
    NColumn =:= Size // 2 + 2,
    !.
decide_piece(Size, NRow, NColumn, piece(lion, player2)) :-
    NRow =:= Size - 1,
    NColumn =:= Size // 2 - 1,
    !.
decide_piece(Size, NRow, NColumn, water_hole) :-
    NColumn =:= Size // 2 - 1, 
    NRow =:= Size // 2 - 1,
    !.
decide_piece(Size, NRow, NColumn, water_hole) :-
    NColumn =:= Size // 2 + 2, 
    NRow =:= Size // 2 - 1,
    !.
decide_piece(Size, NRow, NColumn, water_hole) :-
    NColumn =:= Size // 2 - 1, 
    NRow =:= Size // 2 + 2,
    !.
decide_piece(Size, NRow, NColumn, water_hole) :-
    NColumn =:= Size // 2 + 2, 
    NRow =:= Size // 2 + 2,
    !.
decide_piece(_,_,_,empty).

%color_square(+NRow, +NColumn, -Color)
%Dada a posição de um quadrado de um tabuleiro retorna a sua cor(preto ou branco)
color_square(NRow, NColumn, white) :-
    NRow mod 2 =:= 0,
    NColumn mod 2 =:= 0,
    !.

color_square(NRow, NColumn, white) :-
    NRow mod 2 =:= 1,
    NColumn mod 2 =:= 1,
    !.

color_square(_, _, black).

%print_elen()
print_elem(empty, ' ').
print_elem(piece(mouse,player1), 'm').
print_elem(piece(mouse,player2), 'M').
print_elem(piece(elephant,player1), 'e').
print_elem(piece(elephant,player2), 'E').
print_elem(piece(elephant,player1), 'l').
print_elem(piece(elephant,player2), 'L').


% print_n(+S, +N)
print_n(_,0).
print_n(S,N):-
    N > 0,
    write(S),
    N1 is N-1,
    print_n(S,N1).


display_board(Board):- 
    nl,nl, clear,
    write(' ************'),nl,
    display_lines(Board),
    write(' ************'),nl,nl.

display_lines([]).
display_lines([Line|Lines]):- 
    display_line(Line),
    display_lines(Lines).

display_line(Line):-
    write(' *'),
    display_elem(Line),
    write('*'), nl.

display_elem([]).
display_elem([E|T]):-
    print_elem(C,E),
    write(C),
    display_elem(T).
