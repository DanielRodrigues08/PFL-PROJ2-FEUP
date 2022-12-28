:- consult('utils.pl').
  
%move(+GameState, +Move, -NewGameState)
move(GameState, Move, game_state(NewBoard, NewPlayer)) :-
    valid_move(GameState, Move),
    game_state(Board, Player) = Board,
    append([Player], [NewPlayer], [player1,player2]).





%move(GameState, InitialPos, FinalPos, -NewGameState)
move(game_state(Board, Player), pos(InitialRow, InitialColumn), pos(FinalRow, FinalColumn), game_state(NewBoard, NewPlayer)).
    


%valid_piece(+GameState, +Position)
%Verifica se a peça selecionada pelo jogador é válida
valid_piece(game_state(Board, Player), pos(InitialRow, InitialColumn)) :-
    get_element_board(Board, pos(InitialRow, InitialColumn), piece(_, Player1)),
    Player = Player1.

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


%fear(+Piece, +Piece)
%Verifica se uma peça(animal) tem medo de outra
fear(piece(mouse, Player1), piece(lion, Player2)) :-
    dif(Player1, Player2).
fear(piece(lion, Player1), piece(elephant, Player2)) :-
    dif(Player1, Player2).
fear(piece(elephant, Player1), piece(mouse, Player2)) :-
    dif(Player1, Player2).

%scared(+Position)
scared(Board, Position) :-
    List = [(-1,-1),(-1,0),(-1,1),(0,1),(1,1),(1,0),(1,-1),(0,-1)],
    get_element_board(Board, Position, Piece),
    scared_aux(Board, Position, Piece, List).

%scared_aux(+Position, +Piece, +ListOfPossibleDisplacement)
scared_aux(_,_,[]) :- fail.
scared_aux(Board, pos(NRow, NColumn), Piece, [(X, Y) | _]) :-
    NRow1 is NRow + X,
    NColumn1 is NColumn + Y,
    get_element_board(Board, pos(NRow1, NColumn1), Piece1),
    fear(Piece, Piece1),
    !.
scared_aux(Board, Position, Piece, [_ | T]) :-
    scared_aux(Board, Position, Piece, T).

valid_initial_positions(game_state(Board, Player), ListPostions) :-
    Elem = piece(_, Player),
    setof(pos(NRow, NColumn), (Sublist,Elem)^(nth0(NRow, Board, Sublist), member(Elem, Sublist), nth0(NColumn, Sublist, Elem), scared(Board, pos(NRow, NColumn))), ListPostions),
    \+length(ListPostions, 0).

valid_initial_positions(game_state(Board, Player), ListPostions) :-
    position_pieces(piece(_, Player), Board, ListPostions).