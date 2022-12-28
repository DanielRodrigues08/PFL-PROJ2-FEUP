%position_pieces(+Elem, +Board, -Positions)
%Unifica Positions com a lista de todas as posições do Elem presente no Board 
position_pieces(Elem, Board, Positions) :-
    setof(pos(NRow, NColumn), (Sublist,Elem)^(nth0(NRow, Board, Sublist), member(Elem, Sublist), nth0(NColumn, Sublist, Elem)), Positions).

%change_board(+Board, +OldPositon, +NewPosition, +NewElem, -NewBoard)
%Altera a posição de um elemento do board verificando se esse elemento estava numa casa com uma "water_hole" 
change_board(Board, OldPosition, NewPosition, Elem, NewBoard) :-
    water_hole(Board, OldPosition),
    change_element(Board, OldPosition, water_hole, NewBoard1),
    change_element(NewBoard1, NewPosition, Elem, NewBoard).

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
change_element_aux(List, NColumn, NewElement, NewList) :-
    select(OldElement, List, NewElement, NewList),
    nth0(NColumn, List, OldElement).

%get_element_board(+Board, +Position, -Elem)
%Unifica o elemento que ocupa a posição Row-Column no tabuleiro com a variável Elem
get_element_board(Board, pos(NRow, NColumn), Elem) :-
    nth0(NRow, Board, Row),
    nth0(NColumn, Row, Elem).
