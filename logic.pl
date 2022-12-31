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
    get_element_board(Board, InitialPos, Piece),
    scared_animal(Board, Piece, FinalPos).

valid_move(GameState, Move) :-
    move_position(InitialPos, FinalPos) = Move,
    valid_initial_positions(GameState, ValidInitialPositions),
    member(InitialPos, ValidInitialPositions),
    game_state(Board, _) = GameState,
    get_element_board(Board, InitialPos, Piece),
    valid_type_move(Move, Piece),
    \+jump_animals(Board, Move),
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
    adjacent_position(Position, Position2, TypeOfMoviment),
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

%jump_animals(+Board, +Move)
%Verifica se o movimento de um animal implica passar por cima de outro animal
jump_animals(Board, Move) :-
    type_of_move(Move, _, pos(DisplacementRow, DisplacementColumn)),
    move_position(pos(InitialRow, InitialColumn), FinalPosition) = Move,
    InitialRow1 #= InitialRow + DisplacementRow,
    InitialColumn1 #= InitialColumn + DisplacementColumn,
    \+jump_animals_aux(Board, pos(InitialRow1, InitialColumn1), FinalPosition, pos(DisplacementRow, DisplacementColumn)).

%jump_animals_aux(+Board, +CurrentPos, +FinalPos, +typeOfMovement)
%Predicado auxilar do jump_animals
jump_animals_aux(Board, pos(FinalRow, FinalColumn), pos(FinalRow, FinalColumn), _) :-
    \+get_element_board(Board, pos(FinalRow, FinalColumn), piece(_,_)).

jump_animals_aux(Board, pos(CurrentRow, CurrentColumn), FinalPosition, pos(DisplacementRow, DisplacementColumn)) :-
    \+get_element_board(Board, pos(CurrentRow, CurrentColumn), piece(_,_)),
    CurrentRow1 #= CurrentRow + DisplacementRow,
    CurrentColumn1 #= CurrentColumn + DisplacementColumn,
    jump_animals_aux(Board, pos(CurrentRow1, CurrentColumn1), FinalPosition, pos(DisplacementRow, DisplacementColumn)).




coefficient(scared,0.2).
coefficient(notScared,0.3).
coefficient(inWaterHole,0.5).
coefficient(trapped,0.1).

%value(+GameState, +Player, -Value)
value(game_state(Board, Player), NPlayer, Value):-
    position_pieces(piece(_, NPlayer), Board, ListPositions),
    value_aux(Board, ListPositions,Value,0).

%value_aux(+Board, +Positions, -Value, +Aux)
value_aux(_, [], Value, Aux):-
    Value is Aux/6.
value_aux(Board, [Pos|Positions], Value, Aux):-
    findall(C, coefficient_at_position(Board, Pos, C), Coefficients),
    sum_list(Coefficients, CoefficientSum),
    NewAux is Aux + CoefficientSum,
    value_aux(Board, Positions, Value, NewAux).

coefficient_at_position(Board, Pos, C) :-
    water_hole(Board, Pos),
    coefficient(inWaterHole, C).
coefficient_at_position(Board, Pos, C) :-
    trap_animal(Board, Pos),
    coefficient(trapped, C).
coefficient_at_position(Board, Pos, C) :-
    scared_animal(Board, Pos),
    coefficient(scared, C).
coefficient_at_position(_, _, C) :-
    coefficient(notScared, C).









/*

%%%% Computer algortihms %%%%

%% choose_move(+GameState, +Level, -Move)
%
% Chooses a computer move. For level 1 chooses a random valid play.
% Larger level values are met with the minimax algorithm with depth
%   minimum depth 1. 
%
% @param Game state
% @param Inteligence level
% @param Move to make
choose_move([CP,CB,_], 1, M):-
    valid_moves([CP,CB,_], L),
    random_member(M, L).
choose_move([CP,CB,_], L, M):-
    L > 1,
    D is L - 1,
    minimax(D, [CP,CB,_], M).

%% minimax(+Depth, +GameState, -Move)
%
% Uses the minimax algorith with the given depth to determine the best move.
%
% @param Depth of the algorithm
% @param Game state
% @param Resultant move
minimax(D, [CP,CB,OB], M):-
    minimax_aux(D, -9999, 9999, [CP,CB,OB], M-_).

%% base case: game is over
minimax_aux(Depth, _, _, [CP, CB, OB], _-PE):-
    game_over([CP, CB, OB], _), !,
    board_evaluation([CP, CB, OB], E),
    (E > 0 -> PE is E + Depth; PE is E - Depth). % prefer quicker game wins

%% base case: depth 0
minimax_aux(0, _, _, [CP, CB, OB], _-E):-
    board_evaluation([CP, CB, OB], E).

%% recursive case
minimax_aux(Depth, Alpha, Beta, [CP, CB, _], M-E):-
    Depth > 0,
    valid_moves([CP, CB, _], ValidMoves),
    maplist(move([CP, CB, _]), ValidMoves, NewGameStates),
    NewDepth is Depth - 1,
    map_minimax(CP, NewDepth, Alpha, Beta, NewGameStates, [], Evals_),
    reverse(Evals_, Evals),
    (CP = w -> max_element(Evals, Index, E); min_element(Evals, Index, E)),
    nth0(Index, ValidMoves, M).

map_minimax(_, _, Alpha, Beta, _, Acc, Acc):-
    Alpha >= Beta, !.
map_minimax(_, _, _, _, [], Acc, Acc).
map_minimax(Player, Depth, Alpha, Beta, [GS|T], Acc, EvalsList):-
    minimax_aux(Depth, Alpha, Beta, GS, _-E),
    (Player = w -> Nbeta is Beta; Nalpha is Alpha),
    (Player = w ->
        (E > Alpha -> Nalpha is E; Nalpha is Alpha);
        (E < Beta -> Nbeta is E; Nbeta is Beta)
    ),
    map_minimax(Player, Depth, Nalpha, Nbeta, T, [E|Acc], EvalsList).

    */