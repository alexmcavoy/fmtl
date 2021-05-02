function mutated_strategy = mutate(current_strategy, s)
% MUTATE
%   MUTATE(current_strategy, s) takes in a player's current strategy, a
%   non-negative real number, s, and perturbs the strategy by adding a
%   random number in [-s, s], chosen uniformly at random, to each
%   coordinate independently. the result is then truncated at 0 and 1 to
%   ensure that all coordinates of the output are between 0 and 1
    
    % mutate current strategy based on locality parameter, s
    mutated_strategy = s*(2*rand(size(current_strategy))-1);
    mutated_strategy = mutated_strategy + current_strategy;
    
    % project mutated strategy onto the unit cube so that it remains viable
    mutated_strategy = min(max(mutated_strategy, 0), 1);
end