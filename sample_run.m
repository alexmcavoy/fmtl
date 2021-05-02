function [p_final, q_final] = sample_run(learning_rule_X, learning_rule_Y, ...
    p_initial, q_initial, game_parameters, discounting_factor, s, sig, ...
    convergence_threshold, error_threshold)
% SAMPLE_RUN
%     SAMPLE_RUN(learning_rule_X, learning_rule_Y, p_initial, q_initial,
%     game_parameters, discounting_factor, s, sig, convergence_threshold,
%     error_threshold) takes as input learning rules and initial strategies
%     for X and Y, as well as game parameters, a discounting factor, a
%     locality parameter for strategy mutations, s, a width parameter, sig,
%     for balancing fairness and efficiency when a learner uses FMTL, a
%     convergence threshold (number of steps with no update for the process
%     to terminate), and an error threshold, which quantifies the extent to
%     which a player is confident that a perceived increase in their
%     objective function is worth being treated as such (i.e. x>y is true
%     if and only if x>y+error_threshold). This function then simulates the
%     learning dynamics between the two players, returning final
%     strategies, p_final and q_final, for X and Y after termination.
    
    p = p_initial;
    q = q_initial;

    no_update_count = 0;
    while no_update_count<convergence_threshold
        [piX, piY] = payoff(p, q, game_parameters, discounting_factor);
        
        p_next = p;
        q_next = q;
        
        % update the strategy of player X
        p_test = mutate(p, s);
        [piX_test, piY_test] = payoff(p_test, q, game_parameters, discounting_factor);
        if strcmp(learning_rule_X, 'SELFISH')
            if piX_test>piX+error_threshold
                % accept if X improves its own payoff
                doneX = 0;
                p_next = p_test;
            else
                doneX = 1;
            end
        elseif strcmp(learning_rule_X, 'FMTL')
            if rand<gaussian(piX-piY, sig)
                % X aims to improve efficiency
                if piX_test+piY_test>piX+piY+error_threshold
                    % accept if X improves group payoff (efficiency)
                    doneX = 0;
                    p_next = p_test;
                else
                    doneX = 1;
                end
            else
                % X aims to improve fairness
                if abs(piX_test-piY_test)+error_threshold<abs(piX-piY)
                    % accept if X reduces inequality (increases fairness)
                    doneX = 0;
                    p_next = p_test;
                else
                    doneX = 1;
                end
            end
        else
            error('Unrecognized learning rule for player X.');
        end

        % update the strategy of player Y
        q_test = mutate(q, s);
        [piX_test, piY_test] = payoff(p, q_test, game_parameters, discounting_factor);
        if strcmp(learning_rule_Y, 'SELFISH')
            if piY_test>piY+error_threshold
                % accept if Y improves its own payoff
                doneY = 0;
                q_next = q_test;
            else
                doneY = 1;
            end
        elseif strcmp(learning_rule_Y, 'FMTL')
            if rand<gaussian(piX-piY, sig)
                % Y aims to improve efficiency
                if piX_test+piY_test>piX+piY+error_threshold
                    % accept if Y improves group payoff (efficiency)
                    doneY = 0;
                    q_next = q_test;
                else
                    doneY = 1;
                end
            else
                % Y aims to improve fairness
                if abs(piX_test-piY_test)+error_threshold<abs(piX-piY)
                    % accept if Y reduces inequality (increases fairness)
                    doneY = 0;
                    q_next = q_test;
                else
                    doneY = 1;
                end
            end
        else
            error('Unrecognized learning rule for player Y.');
        end
        
        if doneX==1 && doneY==1
            no_update_count = no_update_count + 1;
        else
            no_update_count = 0;
        end

        p = p_next;
        q = q_next;
    end
    
    % record final strategies
    p_final = p;
    q_final = q;
end  