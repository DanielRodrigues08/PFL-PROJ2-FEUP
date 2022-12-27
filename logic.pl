
%move(GameState, InitialPos, FinalPos, -NewGameState)
move(game_state(Board, Player), pos(InitialRow, InitialColumn), pos(FinalRow, FinalColumn), game_state(NewBoard, NewPlayer)).


%valid_moviment(+InitialPosition, +FinalPosition, +Piece)
%Verifica se o movimento de um determinado animal é válido
valid_moviment(InitialPosition, FinalPosition, piece(mice,_)) :-
    type_of_moviment(InitialPosition, FinalPosition, horizontal, _),
    !.
valid_moviment(InitialPosition, FinalPosition, piece(mice,_)) :-
    type_of_moviment(InitialPosition, FinalPosition, vertical, _),
    !.
valid_moviment(InitialPosition, FinalPosition, piece(lion,_)) :-
    type_of_moviment(InitialPosition, FinalPosition, horizontal, _),
    !.
valid_moviment(InitialPosition, FinalPosition, piece(elephant,_)) :-
    type_of_moviment(InitialPosition, FinalPosition, horizontal, _),
    !.
valid_moviment(InitialPosition, FinalPosition, piece(elephant,_)) :-
    type_of_moviment(InitialPosition, FinalPosition, vertical, _),
    !.
valid_moviment(InitialPosition, FinalPosition, piece(elephant,_)) :-
    type_of_moviment(InitialPosition, FinalPosition, diagonal, _),
    !.

%jump_animals(+Board, +InitialPos, +FinalPos)
%Verifica se o movimento de um animal implica passar por cima de outro animal
%jump_animals(Board, pos(InitialRow, InitialColumn), pos(InitialRow, FinalColumn)).
jump_animals(Board, pos(InitialRow, InitialColumn), FinalPosition, pos(DisplacementRow, DisplacementColumn)) :-
    InitialRow1 is InitialRow + DisplacementRow,
    InitialColumn1 is InitialColumn + DisplacementColumn,
    jump_animals_aux(Board, pos(InitialRow1, InitialColumn1), FinalPosition, pos(DisplacementRow, DisplacementColumn)).

%jump_animals_aux(+Board, +CurrentPos, +FinalPos, +typeOfMovement)
%Functor auxilar do jump_animals
jump_animals_aux(Board, pos(FinalRow, FinalColumn), pos(FinalRow, FinalColumn), _) :-
    \+get_element_board(Board, pos(FinalRow, FinalColumn), piece(_,_)).
jump_animals_aux(Board, pos(CurrentRow, CurrentColumn), FinalPosition, pos(DisplacementRow, DisplacementColumn)) :-
    \+get_element_board(Board, pos(CurrentRow, CurrentColumn), piece(_,_)),
    CurrentRow1 is CurrentRow + DisplacementRow,
    CurrentColumn1 is CurrentColumn + DisplacementColumn,
    jump_animals_aux(Board, pos(CurrentRow, CurrentColumn), FinalPosition, pos(DisplacementRow, DisplacementColumn)).

%get_element_board
%Retorna o elemento que ocupa a posição Row-Column no tabuleiro
get_element_board(Board, pos(NRow, NColumn), Elem) :-
    nth0(Board, NRow, Row),
    nth0(Row, NColumn, Elem).

%type_of_moviment(+InitialPos, +FinalPos, -TypeOfMoviment, +Displacement)
%Retorna o tipo de movimento(horizontal, vertical ou na diagonal) dada a posição inicial e final 
type_of_moviment(pos(InitialRow, InitialColumn), pos(InitialRow, FinalColumn), horizontal, pos(0, DisplacementColumn)) :-
    dif(InitialColumn, FinalColumn),
    DisplacementColumnAux is FinalColumn - InitialColumn,
    DisplacementColumn is DisplacementColumnAux / abs(DisplacementColumnAux),
    !.

type_of_moviment(pos(InitialRow, InitialColumn), pos(FinalRow, InitialColumn), vertical, pos(DisplacementRow, 0)) :-
    dif(InitialRow, FinalRow),
    DisplacementRowAux is FinalRow - InitialRow,
    DisplacementRow is DisplacementRowAux / abs(DisplacementRowAux),
    !.

type_of_moviment(pos(InitialRow, InitialColumn), pos(FinalRow, FinalColumn), diagonal, pos(DisplacementRow, DisplacementColumn)) :-
    DisplacementRowAux is FinalRow - InitialRow,
    DisplacementColumnAux is FinalColumn - InitialColumn,
    DisplacementRow is DisplacementRowAux / abs(DisplacementRowAux),
    DisplacementColumn is DisplacementColumnAux / abs(DisplacementColumnAux),
    DisplacementColumnAux =:= DisplacementRowAux,
    !.