function hFig = print_heatmap(p_strategies, q_strategies, ...
    game_parameters, discounting_factor, payoff_increment, filename)
% PRINT_HEATMAP
%     PRINT_HEATMAP(p_strategies, q_strategies, game_parameters,
%     discounting_factor, payoff_increment, filename) takes in a collection
%     of strategies for X and Y (of the same length), game parameters, a
%     discounting factor, a payoff increment, and a filename. The output is
%     a heatmap showing the distribution of payoffs based on these
%     parameters, with X's payoff on the vertical axis and Y's payoff on
%     the horizontal axis. The payoff increment (for the axes) and filename
%     are used for printing the final output to a PDF file.

    hFig = figure(1);
    hFig.Renderer = 'Painters';

    max_samples = size(p_strategies, 1);
    
    payoffs = zeros(2, max_samples);
    for sample=1:max_samples
        [payoffs(1, sample), payoffs(2, sample)] = payoff(p_strategies(sample, :), ...
            q_strategies(sample, :), game_parameters, discounting_factor);
    end

    game_min = min(game_parameters);
    game_max = max(game_parameters);
    
    margin = 0.25*((game_max-game_min)/3);

    mesh_size = (game_max-game_min)/1000;
    M = hist3([transpose(payoffs(2, :)), transpose(payoffs(1, :))], 'Ctrs', ...
        {game_min-margin:mesh_size:game_max+margin game_min-margin:mesh_size:game_max+margin});
    M = imgaussfilt(M, 10);

    image([game_min-margin, game_max+margin], [game_min-margin, game_max+margin], ...
        transpose(M), 'CDataMapping', 'scaled');
    hold on;

    load('colormap.mat', 'cmap'); colormap(cmap);

    set(gca,'YDir','normal');
    axis square; grid on;
    ax = gca;
    ax.GridColor = [1, 1, 1];
    
    X_ind = [1, 2, 3, 4];
    Y_ind = [1, 3, 2, 4];
    
    xx = [game_parameters(X_ind), game_parameters(1)];
    yy = [game_parameters(Y_ind), game_parameters(1)];

    k = convhull(xx, yy);
    self_min = min((xx(k)+yy(k))/2);
    self_max = max((xx(k)+yy(k))/2);

    xticks(game_min:payoff_increment:game_max);
    yticks(game_min:payoff_increment:game_max);

    plot(yy(k), xx(k), 'LineWidth', 0.5, 'Color', [0.7, 0.7, 0.7]);
    hold on;
    plot(self_min:0.1:self_max, self_min:0.1:self_max, '--', ...
        'LineWidth', 0.5, 'Color', [0.7, 0.7, 0.7]);

    set(gca, 'FontSize', 16);

    set(hFig, 'Units', 'Inches');
    pos = get(hFig, 'Position');
    set(hFig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', ...
        'PaperSize', [pos(3), pos(4)]);
    print(hFig, filename, '-dpdf', '-r0');
end