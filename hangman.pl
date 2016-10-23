% Hangman - CS 312 Project 1
% Graham Brown, Tyler Young, Yasmeen Akbari

%%%%%%%% TODO: start_hangman(WordCharList, PlayerProgList) can just be start_hangman, but putting the vars there
%%%%%%%%		allows us to see the results for now
start_hangman(WordCharList, PlayerProgList) :- init_word(WordCharList), init_player_view(WordCharList, PlayerProgList), play_game(WordCharList, PlayerProgList).

play_game(WordCharList, PlayerProgList). % Probably turn this line into our "loop"


% Prompts user to enter a word, and creates a list with the chars of the word
%%%%%%%% TODO: is there a way to clear the console so player 2 can't see the input?
init_word(WordCharList) :- write('Please enter a word for player 2 to guess (can\'t start uppercase, end with .): '),
					read(Word), atom_chars(Word, WordCharList), is_alpha_list(WordCharList).
					
% Check the that the WordCharList is composed of only alpha chars
is_alpha_list([H|T]) :- char_type(H, alpha), is_alpha_list(T).
is_alpha_list([]).

% Create the list that displays player 2 progress
init_player_view(WordCharList, PlayerProgList) :- length(WordCharList, L), create_player_list(L, [], PlayerProgList). % maybe make copy and change it?

create_player_list(0, PlayerProgList, PlayerProgList).
create_player_list(L, R, PlayerProgList) :- L > 0, L1 is L-1, create_player_list(L1, ['_'|R], PlayerProgList).



