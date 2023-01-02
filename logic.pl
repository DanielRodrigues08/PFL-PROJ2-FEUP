%move(+GameState, +Move, -NewGameState)
%Move uma peça de uma posição para outra retorndo um novo game_state (caso o "move" seja válido)
move(game_state(Board, player1), move_position(InitialPos, FinalPos), game_state(NewBoard, player2)) :-
    valid_move(game_state(Board, player1), move_position(InitialPos, FinalPos)),
    change_board(Board, InitialPos, FinalPos, NewBoard).

move(game_state(Board, player2), move_position(InitialPos, FinalPos), game_state(NewBoard, player1)) :-
    valid_move(game_state(Board, player2), move_position(InitialPos, FinalPos)),
    change_board(Board, InitialPos, FinalPos, NewBoard).

%valid_move(+GameState, +Move)
%Verifica se o Move é válido seguindo as regras do jogo

%se o animal escolhido estiver preso
vaild_move(GameState, move_position(InitialPos, FinalPos)) :-
    valid_initial_positions(GameState, ValidInitialPositions),
    member(InitialPos, ValidInitialPositions),
    trap_animal(Board, InitialPos),
    \+get_element(Board, FinalPos, piece(_,_)),
    get_element_board(Board, InitialPos, Piece),
    scared_animal(Board, Piece, FinalPos).

valid_move(GameState, Move) :-
    move_position(InitialPos, FinalPos) = Move,
    valid_initial_positions(GameState, ValidInitialPositions),
    member(InitialPos, ValidInitialPositions),
    game_state(Board, _) = GameState,
    get_element_board(Board, InitialPos, Piece),
    type_of_move(Move, TypeOfMove, Displacement),
    type_of_moviment(Piece, TypeOfMove),
    \+jump_animals(Board, Move, Displacement),
    \+scared_animal(Board, Piece, FinalPos).


%trap_animal(+Board, +Position)
%Verifica se o animal presente na posição Position está preso
trap_animal(Board, Position) :-
    scared_animal(Board, Position),
    trap_animal_aux(Board, Position).

%trap_animal_aux(+Board, +Position)
%Predicado auxiliar.
trap_animal_aux(Board, Position) :-
    get_element_board(Board, Position, piece(Animal, _)),
    type_of_moviment(piece(Animal,_), TypeOfMoviment),
    
    (Position, Position2, TypeOfMoviment),
    adjacent_animals(Board, Position, Position2, _),
    !.

%fear(+Piece1, +Piece2)
%Verifica se uma peça(animal) tem medo de outra
fear(piece(mouse, Player1), piece(lion, Player2)) :-
    dif(Player1, Player2).
fear(piece(lion, Player1), piece(elephant, Player2)) :-
    dif(Player1, Player2).
fear(piece(elephant, Player1), piece(mouse, Player2)) :-
    dif(Player1, Player2).

%scared_animal(+Board, +Piece, +Position)
%Verifica se a peça Piece situada na posição Position da tabuleiro está assustada
scared_animal(Board, Piece, Position) :-
    adjacent_animals(Board, Position, _, Piece1),
    fear(Piece, Piece1).

scared_animal(Board, Position) :-
    get_element_board(Board, Position, Piece),
    adjacent_animals(Board, Position, _, Piece1),
    fear(Piece, Piece1).

%adjacent_animals(+Board, +Position, ?Position2, -Piece)
%Unifica a position2 e piece com as posições e animais, respetivamente, adjacentes ao animal que se encontra na posição Position. Também pode verficar se duas posições são adjacentes.
adjacent_animals(Board, Position1, Position2, piece(Animal, Player)) :-
    adjacent_position(Position1, Position2),
    get_element_board(Board, Position2, piece(Animal,Player)).

%valid_initial_positions(+GameState, -ListPositions)
%Unifica ListPositions com uma lista das posições das peças que o utilizador pode mover
valid_initial_positions(game_state(Board, Player), ListPositions) :-
    position_pieces(piece(_, Player), Board, L1),
    findall(Pos,(member(Pos, L1), scared_animal(Board, Pos)), ListPositions),
    \+length(ListPositions, 0),
    !. 

valid_initial_positions(game_state(Board, Player), ListPositions) :-
    position_pieces(piece(_, Player), Board, ListPositions).

%valid_type_move(+InitialPosition, +FinalPosition, +Piece)
%Verifica se o movimento de um determinado animal é válido
valid_type_move(Move, Piece) :-
    type_of_move(Move, TypeOfMove, _),
    type_of_moviment(Piece, TypeOfMove),
    !.

%jump_animals(+Board, +Move, +TypeOfMove)
%Verifica se o movimento de um animal implica passar por cima de outro animal
%jump_animals(+Board, +Move)
%Verifica se o movimento de um animal implica passar por cima de outro animal
jump_animals(Board, Move, pos(DisplacementRow, DisplacementColumn)) :-
    move_position(pos(InitialRow, InitialColumn), FinalPosition) = Move,
    InitialRow1 #= InitialRow + DisplacementRow,
    InitialColumn1 #= InitialColumn + DisplacementColumn,
    jump_animals_aux(Board, pos(InitialRow1, InitialColumn1), FinalPosition, pos(DisplacementRow, DisplacementColumn)).

%jump_animals_aux(+Board, +CurrentPos, +FinalPos, +typeOfMovement)
%Predicado auxilar do jump_animals
jump_animals_aux(Board, pos(FinalRow, FinalColumn), pos(FinalRow, FinalColumn), _) :-
    !, get_element_board(Board, pos(FinalRow, FinalColumn), piece(_,_)).

jump_animals_aux(Board, pos(CurrentRow, CurrentColumn), FinalPosition, _) :-
    get_element_board(Board, pos(CurrentRow, CurrentColumn), piece(_,_)), !.

jump_animals_aux(Board, pos(CurrentRow, CurrentColumn), FinalPosition, pos(DisplacementRow, DisplacementColumn)) :-
    CurrentRow1 is CurrentRow + DisplacementRow,
    CurrentColumn1 is CurrentColumn + DisplacementColumn,
    jump_animals_aux(Board, pos(CurrentRow1, CurrentColumn1), FinalPosition, pos(DisplacementRow, DisplacementColumn)).

