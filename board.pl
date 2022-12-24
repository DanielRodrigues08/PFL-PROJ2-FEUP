
board([[empty,empty,empty,empty,piece(black,elephant),piece(black,elephant),empty,empty,empty,empty],
    [empty,empty,empty,piece(black,lion),piece(black,mouse),piece(black,mouse),piece(black,lion),empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,piece(white,lion),piece(white,mouse),piece(white,mouse),piece(white,lion),empty,empty,empty],
    [empty,empty,empty,empty,piece(white,elephant),piece(white,elephant),empty,empty,empty,empty]]).

print_elem(' ',empty).
print_elem('m', piece(white,mouse)).
print_elem('M', piece(black,mouse)).
print_elem('e', piece(white,elephant)).
print_elem('E', piece(black,elephant)).
print_elem('l', piece(white,lion)).
print_elem('L', piece(black,lion)).


% print_n(+S, +N)
print_n(_,0).
print_n(S,N):-
    N > 0,
    write(S),
    N1 is N-1,
    print_n(S,N1).


display_board(Board):- 
    nl,nl, clear,
    write(' ************'),nl,
    display_lines(Board),
    write(' ************'),nl,nl.

display_lines([]).
display_lines([Line|Lines]):- 
    display_line(Line),
    display_lines(Lines).

display_line(Line):-
    write(' *'),
    display_elem(Line),
    write('*'), nl.

display_elem([]).
display_elem([E|T]):-
    print_elem(C,E),
    write(C),
    display_elem(T).