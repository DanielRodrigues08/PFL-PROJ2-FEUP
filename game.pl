game_init(BoardSize, Mode) :-
    initial_state(BoardSize, GameState),
    display_game(GameState),
    game_loop(GameState, Mode).

game_loop(GameState, _) :-
    game_over(GameState, Winner),
    !.
    
% Human - Human
game_loop(GameState, 1) :-
    human_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, 1), 
    !.


% Human - Computer - Easy

game_loop(GameState, 2) :-
    human_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    choose_move(NewGameState, easy , Move),
    move(NewGameState, Move, ComputerGameState),
    display_game(ComputerGameState),
    sleep(3),
    game_loop(ComputerGameState,2),
    !.

% Computer - Human - Easy

game_loop(GameState, 3) :-
    choose_move(GameState, easy , Move),
    move(GameState, Move, ComputerGameState),
    display_game(ComputerGameState),
    sleep(3),
    human_move(ComputerGameState, InitialPosition ,FinalPosition),
    move(ComputerGameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState,3),!.


% Human - Computer - Difficult

game_loop(GameState, 4) :-
    human_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    sleep(3),
    choose_move(NewGameState, difficult , Move),
    move(NewGameState, Move, ComputerGameState),
    display_game(ComputerGameState),
    game_loop(ComputerGameState, 4),!.

% Computer - Human - Difficult

game_loop(GameState, 5) :-
    choose_move(GameState, difficult , Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    human_move(NewGameState, InitialPosition ,FinalPosition),
    move(NewGameState, move_position(InitialPosition, FinalPosition), ComputerGameState),
    display_game(ComputerGameState),
    sleep(3),
    game_loop(ComputerGameState, 5),!.



% Computer - Computer

game_loop(GameState,6) :-
    choose_move(GameState, difficult, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    sleep(3),
    game_loop(NewGameState,6),!.

game_loop(GameState,Mode) :-
    clear,
    display_game(GameState),
    write('Invalid move!'),
    game_loop(GameState,Mode),!.

game_over(game_state(Board, _), Player) :-
    setof(pos(NRow, NColumn), (Sublist,Elem)^(nth0(NRow, Board, Sublist), member(Elem, Sublist), nth0(NColumn, Sublist, piece(_, Player)), water_hole(Board, pos(NRow, NColumn))), Positions),
    length(Positions, N),
    N > 2.
