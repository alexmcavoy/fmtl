% SIMULATE
%   main simulation script. example parameters can be changed as needed.

% learning rules for X and Y. must be either 'FMTL' or 'SELFISH'
learning_rule_X = 'FMTL';
learning_rule_Y = 'SELFISH';

% payoffs [R, S, T, P] for the one-shot game
game_parameters = [1, -1, 2, 0]; %donation game with b = 2 and c = 1

% discounting factor for the repeated game
discounting_factor = 0.999;

% locality parameter for mutating strategies
s = 0.1;

% width parameter determining the balance between fairness and effciency
% when a learner uses FMTL
sig = 0.1;

% number of steps without an update for either learner before termination
convergence_threshold = 1e4;

% threshold needed before x>y is meaningful. in other words, x>y is true if
% and only if x>y+error_threshold.
error_threshold = 1e-12;

% total number of sample runs to be considered
max_samples = 1e5;

% initial strategies for X and Y, respectively. since MATLAB starts
% indexing at 1, we place the initial actions, p0 and q0, at entry 5 of the
% strategy vector. the first four entries correspond to [p_CC, pCD, pDC,
% pDD] and [q_CC, qCD, qDC, qDD], respectively.
p_initial = random('beta', 0.5, 0.5, max_samples, 5);
q_initial = random('beta', 0.5, 0.5, max_samples, 5);

% final strategies for X and Y, respectively
p_final = zeros(max_samples, 5);
q_final = zeros(max_samples, 5);

% loop through examples. change 'parfor' to 'for' for serial loop.
tic
parfor sample=1:max_samples
    disp(sample);
    [p_final(sample, :), q_final(sample, :)] = sample_run(learning_rule_X, ...
            learning_rule_Y, p_initial(sample, :), q_initial(sample, :), ...
            game_parameters, discounting_factor, s, sig, convergence_threshold, error_threshold);
end
toc

% payoff increment on axes of heatmap
payoff_increment = 1;

% name of file to be printed
filename = 'DG'; %'DG' for 'donation game' in this example

% print heatmap based on payoffs at the final strategies (PDF format)
hFig = print_heatmap(p_final, q_final, ...
    game_parameters, discounting_factor, payoff_increment, filename);

% close figure
close(hFig);