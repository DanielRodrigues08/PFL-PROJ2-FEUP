%move(GameState, InitialPos, FinalPos, -NewGameState)
move(game_state(Board, Player), pos(InitialRow, InitialColumn), pos(FinalRow, FinalColumn), game_state(NewBoard, NewPlayer)).

valid_move(game_state(Board, Player), pos)
 
 