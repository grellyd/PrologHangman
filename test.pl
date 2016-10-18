% pl_number(num) --> ['5'].
pl_number(num) --> {integer(num)}.
pl_number([H]) --> { integer(H)}.
% pl_number(num) --> { integer(num) }.
% pl_number(num) --> { float(num) }.

%% this rule doesnt compile
%% pl_neg_number(negNum) --> 
%% 
%%     [H|num] = numberCodes(negNum),
%%     true_neg_code = char_code('-'),
%%     unknown_code = char_code(H),
%%     true_neg_code = unknown_code,
%%     pl_number(num).

    
% Testing...
% phrase(pl_number(num), [5]).
% phrase(pl_number([H]), [5]).
