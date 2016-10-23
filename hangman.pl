% Hangman - CS 312 Project 1
% Graham Brown, Tyler Young, Yasmeen Akbari

:- dynamic lives_remaining/1, won/1, word_char_list/1, player_prog_list/1, player_guess_list/1, cur_guess/1.

char_white_list(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']).
word_char_list([]).
player_prog_list([]).
player_guess_list([]).
lives_remaining(6).
won(0).
cur_guess('').

start_hangman :-
	write('\e[H\e[2J'),
    init_word(WCL),
    retract(word_char_list(_)),
    assert(word_char_list(WCL)),
    init_player_view(PPL),
    retract(player_prog_list(_)),
    assert(player_prog_list(PPL)),
	write('\e[H\e[2J'),
   
    play_game.
    
play_game :-
	\+win_condition,
    lives_remaining(L),
    L>0,
	write('Lives remaining: '),
	write(L),
	nl,
    write('Player 2, please enter your guess (single char, end with .):'),
    read(Guess),
    retract(cur_guess(_)),
    assert(cur_guess(Guess)),
    guess_check,
    cur_guess(CheckedGuess),
    update_progress(CheckedGuess),
	player_prog_list(P),
	player_guess_list(GL),
	nl,
	write('Your progress: '),
	write($P),
	nl,
	write('Your guesses: '),
	write($GL),
	nl,
    
    play_game.

play_game :-
	win_condition,
	player_prog_list(P),
	write($P),
	nl,
	write('You won!'),
	reset_start_values.

play_game :-
	word_char_list(WCL),
    write('You lost! The word was '),
	write($WCL),
	nl,
	reset_start_values.

guess_check :-
    cur_guess(Guess),
    atom_chars(Guess, GuessChars),
    length(GuessChars, Len),
    Len=1,
    char_white_list(AllowedChars),
    member(Guess, AllowedChars).

guess_check :-
    cur_guess(Guess),
    atom_chars(Guess, GuessChars),
    length(GuessChars, Len),
    Len=1,
    char_white_list(AllowedChars),
    \+member(Guess, AllowedChars),
    write('Guess is an unallowed character. Please enter a lowercase character from a to z:'),
    read(NewGuess),
    retract(cur_guess(_)),
    assert(cur_guess(NewGuess)),
    guess_check.

guess_check :-
    cur_guess(Guess),
    atom_chars(Guess, GuessChars),
    length(GuessChars, Len),
    Len>1,
    write('Guess is too long. Please enter a single character:'),
    read(NewGuess),
    retract(cur_guess(_)),
    assert(cur_guess(NewGuess)),
    guess_check.

reset_start_values :-
    retract(word_char_list(_)),
    retract(player_prog_list(_)),
    retract(lives_remaining(_)),
    retract(won(_)),
	retract(player_guess_list(_)),
	assert(word_char_list([])),
	assert(player_prog_list([])),
	assert(player_guess_list([])),
	assert(lives_remaining(6)),
	assert(won(0)),
    assert(guess('')).

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
	player_guess_list(PGL),
    member(Guess, WCL),
	\+member(Guess, PGL),
	change_progress_list(Guess, WCL, PPL, []),
	change_guess_list(Guess).

update_progress(Guess) :-
    word_char_list(WCL),
	player_guess_list(PGL),
    member(Guess, WCL),
	member(Guess, PGL),
	nl,
	write('You already guessed: '),
	write(Guess),
	nl,
	!.

update_progress(Guess) :-
    word_char_list(WCL),
	player_guess_list(PGL),
    \+member(Guess, WCL),
	\+member(Guess, PGL),
    lives_remaining(L),
    NL is L-1,
    retract(lives_remaining(L)),
    assert(lives_remaining(NL)),
	change_guess_list(Guess).
	
update_progress(Guess) :-
    word_char_list(WCL),
	player_guess_list(PGL),
    \+member(Guess, WCL),
	member(Guess, PGL),
	nl,
    write('You already guessed: '),
	write(Guess),
	nl,
	!.

change_guess_list(Guess) :-
	player_guess_list(GL),
	append([Guess], GL, GL1),
	retract(player_guess_list(_)),
	assert(player_guess_list(GL1)).
	
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
init_word(WordCharList) :- 
    write('Player1, please enter a word for player 2 to guess (can\'t start uppercase, end with .): '),
	nl,
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

