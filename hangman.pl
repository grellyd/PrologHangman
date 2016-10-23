% Hangman - CS 312 Project 1
% Graham Brown, Tyler Young, Yasmeen Akbari


start_hangman(WordCharList) :- init_word(WordCharList),play_game(WordCharList).
play_game(WordCharList). % Probably turn this line into our "loop"


% Prompts user to enter a word, and creates a list with the chars of the word
%%%%%%%% TODO: is there a way to clear the console so player 2 can't see the input?
init_word(WordCharList) :- write('Please enter a word for player 2 to guess (can\'t start uppercase, end with .): '),
					read(Word), atom_chars(Word, WordCharList), is_alpha_list(WordCharList).
					
% Check the that the WordCharList is composed of only alpha chars
is_alpha_list([H|T]) :- char_type(H, alpha), is_alpha_list(T).
is_alpha_list([]).



