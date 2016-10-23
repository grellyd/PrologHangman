% Hangman - CS 312 Project 1
% Graham Brown, Tyler Young, Yasmeen Akbari

%%%%%%%% TODO: start_hangman(WordCharList, PlayerProgList, Lives) can just be start_hangman, but putting the vars there
%%%%%%%%		allows us to test the init values 

get_lives(N) :- N is 6. % The number of wrong guesses Player 2 can make
start_hangman(WordCharList, PlayerProgList, Lives) :- init_word(WordCharList), init_player_view(WordCharList, PlayerProgList),
												get_lives(Lives), play_game(Lives, WordCharList, PlayerProgList).

% This is the main loop
% Ask Player 2 for a guess, check if it's right or wrong, update lives appropriately
% Keeps prompting Player 2 until Lives reaches 0, or player has guessed the word
%%%%%%%% TODO: check for winning conditions, probably compare WordCharList and PlayerProgList
play_game(Lives, WordCharList, PlayerProgList) :- Lives > 0, write('Player 2, please enter your guess (single char, end with .):'), read(Guess),
												update_progress(Lives, LivesAfter, WordCharList, PlayerProgListBefore, PlayerProgListAfter, Guess), 
												play_game(LivesAfter, WordCharList,PlayerProgList).
play_game(0, WordCharList, PlayerProgList) :- write('You lost!').

update_progress(LivesBefore, LivesAfter, WordCharList, PlayerProgListBefore, PlayerProgListAfter, Guess):- member(Guess, WordCharList), LivesAfter is LivesBefore.
update_progress(LivesBefore, LivesAfter, WordCharList, PlayerProgListBefore, PlayerProgListAfter, Guess):- \+ member(Guess, WordCharList), 
																											LivesAfter is LivesBefore-1.


% Prompts user to enter a word, and creates a list with the chars of the word
%%%%%%%% TODO: is there a way to clear the console so player 2 can't see the input?
init_word(WordCharList) :- write('Player1, please enter a word for player 2 to guess (can\'t start uppercase, end with .): '),
					read(Word), atom_chars(Word, WordCharList), is_alpha_list(WordCharList).
					
% Check the that the WordCharList is composed of only alpha chars
is_alpha_list([H|T]) :- char_type(H, alpha), is_alpha_list(T).
is_alpha_list([]).

% Create the list that displays player 2 progress
% Example: if the word list is ['c', 'a', 't'] then the progress list is ['_', '_', '_']
init_player_view(WordCharList, PlayerProgList) :- length(WordCharList, L), create_player_list(L, [], PlayerProgList). % maybe make copy and change it?

create_player_list(0, PlayerProgList, PlayerProgList).
create_player_list(L, R, PlayerProgList) :- L > 0, L1 is L-1, create_player_list(L1, ['_'|R], PlayerProgList).



