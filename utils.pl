%get_element_board(+Board, +Position, -Elem)
%Unifica o elemento que ocupa a posição Row-Column no tabuleiro com a variável Elem
get_element_board(Board, pos(NRow, NColumn), Elem) :-
    nth0(NRow, Board, Row),
    nth0(NColumn, Row, Elem).

%position_pieces(+Elem, +Board, -Positions)
%Unifica Positions com a lista de todas as posições do Elem presente no Board 
position_pieces(Elem, Board, Positions) :-
    setof(pos(NRow, NColumn), (Sublist,Elem)^(nth0(NRow, Board, Sublist), member(Elem, Sublist), nth0(NColumn, Sublist, Elem)), Positions).

%change_board(+Board, +OldPositon, +NewPosition, -NewBoard)
%Altera a posição de um elemento do board verificando se esse elemento estava numa casa com uma "water_hole" 
change_board(Board, InitialPosition, NewPosition, NewBoard) :-
    water_hole(Board, InitialPosition),
    get_element_board(Board, InitialPosition, Elem),
    change_element(Board, InitialPosition, water_hole, BoardAux),
    change_element(BoardAux, NewPosition, Elem, NewBoard).

change_board(Board, InitialPosition, NewPosition, NewBoard) :-
    get_element_board(Board, InitialPosition, Elem),
    change_element(Board, InitialPosition, empty, BoardAux),
    change_element(BoardAux, NewPosition, Elem, NewBoard).

%change_element(+ListOfLists, +Position, +NewElement, -NewListOfLists)
%Altera o elemento que se encontra na posição Positon para NewElement unificando a lista resultante com o NewListOfLists
change_element([H|T], pos(0, NColumn), NewElement, [NewH | T]) :-
    change_element_aux(H, NColumn, NewElement, NewH).
change_element([H|T], pos(NRow, NColumn), NewElement, [H|R]) :-
    NRow > 0,
    NRow1 is NRow - 1,
    change_element(T, pos(NRow1, NColumn), NewElement, R).

%change_element_aux(+List, +NColumn, +NewElement, -NewList)
%Predicado auxiliar do chanhe_element. Responsável por substituir o elemento que ocupa a posição NColumn de uma lista.
change_element_aux([_|T], 0, NewElement, [NewElement | T]).
change_element_aux([H|T], NColumn, NewElement, [H|R]) :-
    NColumn > 0,
    NColumn1 is NColumn - 1,
    change_element_aux(T, NColumn1, NewElement, R).

abs(X, X) :- X #> 0.
abs(X, Y) :- X #< 0, Y #= -X.
abs(0,0).    

%type_of_move(+Move, -TypeOfMoviment, +Displacement)
%Indica o tipo de movimento(horizontal, vertical ou na diagonal) dada a posição inicial e final 
type_of_move(move_position(pos(InitialRow, InitialColumn), pos(FinalRow, FinalColumn)), diagonal, pos(DisplacementRow, DisplacementColumn)) :-
    DisplacementRowAux #= FinalRow - InitialRow,
    DisplacementColumnAux #= FinalColumn - InitialColumn,
    abs(DisplacementRowAux, DisplacementRowAux1),
    abs(DisplacementColumnAux, DisplacementColumnAux1),
    DisplacementColumnAux1 #= DisplacementRowAux1,
    DisplacementRow #= DisplacementRowAux / DisplacementRowAux1,
    DisplacementColumn #= DisplacementColumnAux / DisplacementColumnAux1,
    !.

type_of_move(move_position(pos(InitialRow, InitialColumn), pos(InitialRow, FinalColumn)), horizontal, pos(0, DisplacementColumn)) :-
    dif(InitialColumn, FinalColumn),
    DisplacementColumnAux #= FinalColumn - InitialColumn,
    abs(DisplacementColumnAux,DisplacementColumnAux1),
    DisplacementColumn #= DisplacementColumnAux / DisplacementColumnAux1,
    !.

type_of_move(move_position(pos(InitialRow, InitialColumn), pos(FinalRow, InitialColumn)), vertical, pos(DisplacementRow, 0)) :-
    dif(InitialRow, FinalRow),
    DisplacementRowAux #= FinalRow - InitialRow,
    abs(DisplacementRowAux,DisplacementRowAux1),
    DisplacementRow #= DisplacementRowAux / DisplacementRowAux1,
    !.


sum_list([], 0).
sum_list([X|Xs], Sum) :-
    sum_list(Xs, Sum1),
    Sum is X + Sum1.

%adjacent_position(+Pos1, ?Pos2)
%Verifica se as posições Pos1 e Pos2 são adjacentes. Também pode unificar a Pos2 com uma posição adjacente a Pos1
adjacent_position(pos(NRow1, NColumn1), pos(NRow2, NColumn2)) :-
    dif(pos(NRow1, NColumn1), pos(NRow2, NColumn2)),
    DisplacementRow #= NRow2 - NRow1,
    DisplacementColumn #= NColumn2 - NColumn1,
    DisplacementColumn #< 2,
    DisplacementColumn #> -2,
    DisplacementRow #< 2,
    DisplacementRow #> -2.


%adjacent_position(+Pos1, ?Pos2, +Type)
%Muito semalhante ao predicado adjacent_position/2 sendo que neste predicado podemos especificar as posições onde tem de procurar
adjacent_position(pos(NRow, NColumn1), pos(NRow, NColumn2), horizontal) :-
    dif(NColumn1,NColumn2),
    DisplacementColumn #= NColumn2 - NColumn1,
    DisplacementColumn #< 2,
    DisplacementColumn #> -2.

adjacent_position(pos(NRow1, NColumn), pos(NRow2, NColumn), vertical) :-
    dif(NRow1,NRow2),
    DisplacementRow #= NRow2 - NRow1,
    DisplacementRow #< 2,
    DisplacementRow #> -2.

adjacent_position(pos(NRow1, NColumn1), pos(NRow2, NColumn2), diagonal) :-
    dif(NRow1,NRow2),
    dif(NColumn1, NColumn2),
    DisplacementRow #= NRow2 - NRow1,
    DisplacementColumn #= NColumn2 - NColumn1,
    DisplacementColumn #< 2,
    DisplacementColumn #> -2,
    DisplacementRow #< 2,
    DisplacementRow #> -2.

%type_of_movimento(?Piece, ?TypeOfMoviment)
%Associa os animais com os tipos de deslocamentos que podem no tabuleiro
type_of_moviment(piece(mouse,_), horizontal).
type_of_moviment(piece(mouse,_), vertical).
type_of_moviment(piece(lion,_), diagonal).
type_of_moviment(piece(elephant,_), horizontal).
type_of_moviment(piece(elephant,_), vertical).
type_of_moviment(piece(elephant,_), diagonal).


