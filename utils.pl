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

find_water_holes(Board, [pos(Aux1, Aux2), pos(Aux2, Aux1), pos(Aux1, Aux1), pos(Aux2, Aux2)]):-
    length(Board, Size),
    Aux1 is Size // 2 - 2,
    Aux2 is Size // 2 + 1.