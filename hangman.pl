% Hangman - CS 312 Project 1
% Graham Brown, Tyler Young, Yasmeen Akbari

%%%%%%%% TODO: start_hangman(WordCharList, PlayerProgList, Lives) can just be start_hangman, but putting the vars there
%%%%%%%%		allows us to test the init values 

:- dynamic lives_remaining/1, won/1.

lives_remaining(6).
won(0).

start_hangman(WordCharList, PlayerProgList, Lives) :- init_word(WordCharList), init_player_view(WordCharList, PlayerProgList),
												get_lives(Lives), play_game(Lives, WordCharList, PlayerProgList).

% game loop
play_game(Lives, WordCharList, PlayerProgList) :-
    lives_remaining(L),
    retract(lives_remaining(L)),
    assert(lives_remaining(L-1)),
    
    write('Lives Remaining:'),
    write(lives_remaining(N)),
    play_game(Lives, WordCharList, PlayerProgList).



% Prompts user to enter a word, and creates a list with the chars of the word
%%%%%%%% TODO: is there a way to clear the console so player 2 can't see the input?
init_word(WordCharList) :- write('Please enter a word for player 2 to guess (can\'t start uppercase, end with .): '),
					read(Word), atom_chars(Word, WordCharList), is_alpha_list(WordCharList).
					
% Check the that the WordCharList is composed of only alpha chars
is_alpha_list([H|T]) :- char_type(H, alpha), is_alpha_list(T).
is_alpha_list([]).

% Create the list that displays player 2 progress
% Example: if the word list is ['c', 'a', 't'] then the progress list is ['_', '_', '_']
init_player_view(WordCharList, PlayerProgList) :- length(WordCharList, L), create_player_list(L, [], PlayerProgList). % maybe make copy and change it?

create_player_list(0, PlayerProgList, PlayerProgList).
create_player_list(L, R, PlayerProgList) :- L > 0, L1 is L-1, create_player_list(L1, ['_'|R], PlayerProgList).



