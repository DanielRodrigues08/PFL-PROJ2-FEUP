:- use_module(library(lists)).

%initial_state(+Size, -GameState)
% Esta Functor verifica o size (tem de ser par e superior a 10) e chama a Functor responsável pela criação do tabuleiro.
% Retorna o estado do jogo, que consiste num termo composto game_state que tem o estado atual do tabuleiro e a vez do jogador (player1 ou player2)
initial_state(Size, game_state(Board, player1)) :-
    Size >= 10,
    Size mod 2 =:= 0,
    create_board(Size, Board).

%create_board(+Size, -Board)
% Esta Functor é responsável pela criação do tabuleiro
% Recorre a uma funcção auxiliar permitindo a "tail recursion" aumentando a eficiência
create_board(Size, Board) :-
    create_board_aux(Size, Size, [], Board).

%create_board_aux(+Size, ?NRow, ?Acc, -Board)
%Functor auxiliar da create_board
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
%Functor auxiliar da create_row
create_row_aux(_, _, 0, Acc, Acc) :- !.
create_row_aux(Size, NRow, NColumn, Acc, Row) :-
    NColumn > 0,
    decide_piece(Size, NRow, NColumn, Piece),
    NColumn1 is NColumn - 1,
    create_row_aux(Size, NRow, NColumn1, [Piece | Acc], Row).

%decide_piece(+Size, +NRow, +NColumn, -Piece)
%Functor que retorna o tipo de peça que ocupa uma determinada posição do tabuleiro no estado inicial
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

%water_hole(+Board, +NRow, +NColumn)
%Dada uma posição no tabuleiro verifica se essa posição contém uma "water_hole"
water_hole(Board, NRow, NColumn) :-
    length(Board, Size),
    NColumn =:= Size // 2 - 2, 
    NRow =:= Size // 2 - 2,
    !.

water_hole(Board, NRow, NColumn) :-
    length(Board, Size),
    NColumn =:= Size // 2 - 2, 
    NRow =:= Size // 2 + 1,
    !.

water_hole(Board, NRow, NColumn) :-
    length(Board, Size),
    NColumn =:= Size // 2 + 1, 
    NRow =:= Size // 2 - 2,
    !.

water_hole(Board, NRow, NColumn) :-
    length(Board, Size),
    NColumn =:= Size // 2 + 1, 
    NRow =:= Size // 2 + 1,
    !.


elem_color(white,' ').
elem_color(black,'#').
%print_elem()
print_elem(empty, C,RowNum,ColNum):-
    color_square(RowNum,ColNum,Color),
    elem_color(Color,C).
print_elem(piece(mouse,player1), 'm',_,_).
print_elem(piece(mouse,player2), 'M',_,_).
print_elem(piece(elephant,player1), 'e',_,_).
print_elem(piece(elephant,player2), 'E',_,_).
print_elem(piece(lion,player1), 'l',_,_).
print_elem(piece(lion,player2), 'L',_,_).
print_elem(water_hole, 'W',_,_).



% print_n(+S, +N)
print_n(_,0).
print_n(S,N):-
    N > 0,
    write(S),
    N1 is N-1,
    print_n(S,N1).

display_fist_line(Col,Col).

display_fist_line(Col,Num):-
    write(' | '),
    write(Num),
    Num1 is Num + 1,
    display_fist_line(Col,Num1).




% A predicate to display the board to the user
display_game(game_state(Board, _)) :-
  nl,nl, clear,
  nth0(0, Board,Elem),
  length(Elem , Col),
  write(' '),
  display_fist_line(Col, 0), nl,
  write('--'),
  display_ln(Col,0),    
  display_board_aux(Board, 0).

display_ln(Length,Length).
display_ln(Length,Num):-
    write(' ---'),
    Num1 is Num + 1,
    display_ln(Length,Num1).

display_board_aux([], _).
display_board_aux([Row|Rest], RowNum) :-
  nl,
  write(RowNum), write(' | '),
  length(Row , Length),
  display_row(Row, RowNum,0),
  nl,
  write('--'), 
  display_ln(Length,0),
  NextRowNum is RowNum + 1,
  display_board_aux(Rest, NextRowNum).


display_row([],_,_).
display_row([Cell|Rest],RowNum,ColNum) :-
  print_elem(Cell,C,RowNum,ColNum),
  write(C), write(' | '),
  NextColNum is ColNum+1,
  display_row(Rest,RowNum,NextColNum).
