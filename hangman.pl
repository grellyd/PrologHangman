% Hangman - CS 312 Project 1
% Graham Brown, Tyler Young, Yasmeen Akbari

%%%%%%%% TODO: start_hangman(WordCharList, PlayerProgList, Lives) can just be start_hangman, but putting the vars there
%%%%%%%%		allows us to test the init values 

:- dynamic lives_remaining/1, won/1, word_char_list/1, player_prog_list/1.

word_char_list([]).
player_prog_list([]).
lives_remaining(6).
won(0).

start_hangman :-
    init_word(WCL),
    retract(word_char_list(_)),
    assert(word_char_list(WCL)),
    init_player_view(PPL),
    retract(player_prog_list(_)),
    assert(player_prog_list(PPL)),
   
    play_game.
    
play_game :-
    lives_remaining(L),
    L>0,
    write('Player 2, please enter your guess (single char, end with .):'),
    read(Guess),
    update_progress(Guess),
	player_prog_list(P),
	\+ win_condition,
	nl,
	write('Your progress: '),
	write($P),
	nl,
    
    play_game.
	
play_game :-
	win_condition,
	player_prog_list(P),
	write($P),
	nl,
	write('You won!'),
    retract(word_char_list(_)),
    retract(player_prog_list(_)),
    retract(lives_remaining(_)),
    retract(won(_)),
	assert(word_char_list([])),
	assert(player_prog_list([])),
	assert(lives_remaining(6)),
	assert(won(0)).	

play_game :-
    write('You lost!'),
	nl,
    retract(word_char_list(_)),
    retract(player_prog_list(_)),
    retract(lives_remaining(_)),
    retract(won(_)),
	assert(word_char_list([])),
	assert(player_prog_list([])),
	assert(lives_remaining(6)),
	assert(won(0)).

win_condition :-	
    word_char_list(WCL),
	player_prog_list(PPL),
	length(WCL, WCL_L),
	length(PPL, PPL_L),
	WCL_L == PPL_L,
	intersection(WCL, PPL, L),
	length(L, L_L),
	WCL_L == L_L.
	
	
update_progress(Guess) :-
    word_char_list(WCL),
	player_prog_list(PPL),
    member(Guess, WCL),
	change_progress_list(Guess, WCL, PPL, []).

update_progress(Guess) :-
    word_char_list(WCL),
    \+member(Guess, WCL),
    lives_remaining(L),
    NL is L-1,
    retract(lives_remaining(L)),
    assert(lives_remaining(NL)).
	
change_progress_list(Guess, [H_WCL|T_WCL], [_|T_PPL], NewPPL) :-
	Guess == H_WCL, 
	append(NewPPL, [Guess], NewPPL1), 
	change_progress_list(Guess, T_WCL, T_PPL, NewPPL1).
	

change_progress_list(Guess, [H_WCL|T_WCL], [H_PPL|T_PPL], NewPPL) :-
	Guess \== H_WCL,
	append(NewPPL, [H_PPL], NewPPL1),
	change_progress_list(Guess, T_WCL, T_PPL, NewPPL1).

change_progress_list(_, [], [], NewPPL):-
	retract(player_prog_list(_)),
	assert(player_prog_list(NewPPL)).
	
% Prompts user to enter a word, and creates a list with the chars of the word
%%%%%%%% TODO: is there a way to clear the console so player 2 can't see the input?
init_word(WordCharList) :- 
    write('Player1, please enter a word for player 2 to guess (can\'t start uppercase, end with .): '),
    read(Word),
    atom_chars(Word, WordCharList), 
    is_alpha_list(WordCharList).
					
% Check the that the WordCharList is composed of only alpha chars
is_alpha_list([H|T]) :- char_type(H, alpha), is_alpha_list(T).
is_alpha_list([]).

% Create the list that displays player 2 progress
% Example: if the word list is ['c', 'a', 't'] then the progress list is ['_', '_', '_']
init_player_view(PlayerProgList) :- 
    word_char_list(WordCharList), 
    length(WordCharList, L),
    create_player_list(L, [], PlayerProgList). % maybe make copy and change it?

create_player_list(0, PlayerProgList, PlayerProgList).
create_player_list(L, R, PlayerProgList) :- 
    L > 0,
    L1 is L-1,
    create_player_list(L1, ['_'|R], PlayerProgList).


% start_hangman(WordCharList, PlayerProgList, Lives) :- init_word(WordCharList), init_player_view(WordCharList, PlayerProgList),
% 												get_lives(Lives), play_game(Lives, WordCharList, PlayerProgList).
% 
% % game loop
% play_game(Lives, WordCharList, PlayerProgList) :-
%     lives_remaining(L),
%     retract(lives_remaining(L)),
%     assert(lives_remaining(L-1)),
%     
%     write('Lives Remaining:'),
%     write(lives_remaining(N)),
%     play_game(Lives, WordCharList, PlayerProgList).
% 
% =======

% get_lives(N) :- N is 6. % The number of wrong guesses Player 2 can make
% start_hangman(WordCharList, PlayerProgList, Lives) :- 
%     init_word(WordCharList),
%     init_player_view(WordCharList, PlayerProgList),
%     get_lives(Lives),
%     play_game(Lives, WordCharList, PlayerProgList).
% 
% % This is the main loop
% % Ask Player 2 for a guess, check if it's right or wrong, update lives appropriately
% % Keeps prompting Player 2 until Lives reaches 0, or player has guessed the word
% %%%%%%%% TODO: check for winning conditions, probably compare WordCharList and PlayerProgList
% play_game(Lives, WordCharList, PlayerProgList) :- 
%     Lives > 0,
%     write('Player 2, please enter your guess (single char, end with .):'),
%     read(Guess),
%     update_progress(Lives, LivesAfter, WordCharList, PlayerProgListBefore, PlayerProgListAfter, Guess), 
%     play_game(LivesAfter, WordCharList,PlayerProgList).
% 
% play_game(0, WordCharList, PlayerProgList) :- write('You lost!').
% 
% update_progress(LivesBefore, LivesAfter, WordCharList, PlayerProgListBefore, PlayerProgListAfter, Guess):- 
%     member(Guess, WordCharList), 
%     LivesAfter is LivesBefore.
% 
% update_progress(LivesBefore, LivesAfter, WordCharList, PlayerProgListBefore, PlayerProgListAfter, Guess):- 
%     \+ member(Guess, WordCharList), 
%     LivesAfter is LivesBefore-1.
% 
% % Prompts user to enter a word, and creates a list with the chars of the word
% %%%%%%%% TODO: is there a way to clear the console so player 2 can't see the input?
% init_word(WordCharList) :- write('Player1, please enter a word for player 2 to guess (can\'t start uppercase, end with .): '),
% 					read(Word), atom_chars(Word, WordCharList), is_alpha_list(WordCharList).
% 					
% % Check the that the WordCharList is composed of only alpha chars
% is_alpha_list([H|T]) :- char_type(H, alpha), is_alpha_list(T).
% is_alpha_list([]).
% 
% % Create the list that displays player 2 progress
% % Example: if the word list is ['c', 'a', 't'] then the progress list is ['_', '_', '_']
% init_player_view(WordCharList, PlayerProgList) :- length(WordCharList, L), create_player_list(L, [], PlayerProgList). % maybe make copy and change it?
% 
% create_player_list(0, PlayerProgList, PlayerProgList).
% create_player_list(L, R, PlayerProgList) :- L > 0, L1 is L-1, create_player_list(L1, ['_'|R], PlayerProgList).



