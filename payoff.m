function [piX, piY] = payoff(p, q, game_parameters, discounting_factor)
% PAYOFF
%     PAYOFF(p, q, game_parameters, discounting_factor) takes as input the
%     strategy of X, p, the strategy of Y, q, a vector game_parameters,
%     equal to [R, S, T, P] in the one-shot game, and a discounting factor.
%     The output is the mean payoff to X and Y, piX and piY, respectively.
    
    % build transition matrix for the Markov chain
    X_ind = [1, 2, 3, 4];
    Y_ind = [1, 3, 2, 4];
    M = zeros(4, 4);
    for i=1:4
    	M(i, 1) = p(X_ind(i))*q(Y_ind(i));
	    M(i, 2) = p(X_ind(i))*(1-q(Y_ind(i)));
	    M(i, 3) = (1-p(X_ind(i)))*q(Y_ind(i));
	    M(i, 4) = (1-p(X_ind(i)))*(1-q(Y_ind(i)));
    end
    
    % initial distribution of actions
    initial_distribution = [p(5)*q(5), p(5)*(1-q(5)), (1-p(5))*q(5), (1-p(5))*(1-q(5))];
    
    % final (long-run) distribution of actions
    action_distribution = initial_distribution/((eye(size(M))-discounting_factor*M)/(1-discounting_factor));
    
    % final (mean) payoffs to X and Y
    piX = dot(action_distribution, game_parameters(X_ind));
    piY = dot(action_distribution, game_parameters(Y_ind));
end