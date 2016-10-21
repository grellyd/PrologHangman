% pl_number(Num) --> { integer(Num) }.
% pl_number([H]) --> [H], pl_number(H).
% pl_number(Num) --> { float(Num) }.


%% this rule doesnt compile
% pl_neg_number(NegNum) --> 
%     [H|Num], numberCodes(NegNum),
%     True_neg_code = char_code('-'),
%     Unknown_code = char_code(H),
%     True_neg_code = Unknown_code,
%     pl_number(Num).

    
% Testing...
% phrase(pl_number(Num), [5]).
% phrase(pl_number([H]), [5]).

pl_number([H|T]) --> [H], {integer(H)}, pl_number(T).
pl_number([]) --> [].