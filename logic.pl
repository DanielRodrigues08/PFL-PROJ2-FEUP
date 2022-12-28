%move(+GameState, +Move, -NewGameState)
%Move uma peça de uma posição para outra retorndo um novo game_state (caso o "move" seja válido)
move(GameState, Move, game_state(NewBoard, NewPlayer)) :-
    valid_move(GameState, Move),
    game_state(Board, Player) = Board,
    move_position(OldPosition, NewPosition) = Move,
    change_board(Board, OldPosition, NewPosition, NewBoard),
    append([Player], [NewPlayer], [player1,player2]).

%valid_move(+GameState, +Move)
%Verifica se o Move é válido seguindo as regras do jogo

%se o animal escolhido estiver preso
vaild_move(GameState, Move) :-
    valid_initial_positions(GameState, ValidInitialPositions),
    member(Move, ValidInitialPositions),
    move_position(InitialPos, FinalPos) = Move,
    trap_animal(Board, InitialPos),
    get_element_board(Board, InitialPos, Piece),
    scared_animal(Board, Piece, FinalPos).

valid_move(GameState, Move) :-
    valid_initial_positions(GameState, ValidInitialPositions),
    member(Move, ValidInitialPositions),
    game_state(Board, _) = GameState,
    move_position(InitialPos, FinalPos) = Move,
    get_element_board(Board, InitialPos, Piece),
    valid_type_move(Move, Piece),
    jump_animals(Board, Move),
    \+scared_animal(Board, Piece, FinalPos).


trap_animal(Board, Position) :-
    scared_animal(Board, Position),
    trap_animal_aux(Board, Position).

trap_animal_aux(Board, Position) :-
    get_element_board(Board, Position, piece(Animal, _)),
    type_of_moviment(piece(Animal,_), TypeOfMoviment),
    adjacent_position(Position, Position2, TypeOfMoviment),
    adjacent_animals(Board, Position, Position2, _),
    !.

%fear(+Piece, +Piece)
%Verifica se uma peça(animal) tem medo de outra
fear(piece(mouse, Player1), piece(lion, Player2)) :-
    dif(Player1, Player2).
fear(piece(lion, Player1), piece(elephant, Player2)) :-
    dif(Player1, Player2).
fear(piece(elephant, Player1), piece(mouse, Player2)) :-
    dif(Player1, Player2).


scared_animal(Board, Piece, Position) :-
    adjacent_animals(Board, Position, _, Piece1),
    fear(Piece, Piece1).

scared_animal(Board, Position) :-
    get_element_board(Board, Position, Piece),
    adjacent_animals(Board, Position, _, Piece1),
    fear(Piece, Piece1).

adjacent_animals(Board, Position1, Position2, piece(Animal, Player)) :-
    adjacent_position(Position1, Position2),
    get_element_board(Board, Position2, piece(Animal,Player)).

valid_initial_positions(GameState, ListPositions) :-
    setof(Position, scared_animal(GameState, Positon), ListPositions),
    \+length(ListPositions, 0).

valid_initial_positions(game_state(Board, Player), ListPositions) :-
    position_pieces(piece(_, Player), Board, ListPositions).

%valid_type_move(+InitialPosition, +FinalPosition, +Piece)
%Verifica se o movimento de um determinado animal é válido
valid_type_move(Move, Piece) :-
    type_of_move(Move, TypeOfMove, _),
    type_of_moviment(Piece, TypeOfMove),
    !.

%jump_animals(+Board, +InitialPos, +FinalPos)
%Verifica se o movimento de um animal implica passar por cima de outro animal
%jump_animals(Board, pos(InitialRow, InitialColumn), pos(InitialRow, FinalColumn)).
jump_animals(Board, Move) :-
    type_of_move(Move, _, pos(DisplacementRow, DisplacementColumn)),
    move_position(pos(InitialRow, InitialColumn), FinalPosition) = Move,
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
    jump_animals_aux(Board, pos(CurrentRow1, CurrentColumn1), FinalPosition, pos(DisplacementRow, DisplacementColumn)).