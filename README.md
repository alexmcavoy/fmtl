# fmtl (fairness-mediated team learning)

Simulation code for the paper "Evolutionary (in)stability of selfish learning in repeated games" by Alex McAvoy, Julian Kates-Harbeck, Krishnendu Chatterjee, and Christian Hilbe. The details of these simulations may be found in the Methods section of the paper, available at [http://arxiv.org/abs/2105.06199](http://arxiv.org/abs/2105.06199).

## Instructions

To simulate, set parameters in `simulate.m` as desired and run
	
	>> simulate
	
from the MATLAB command line. By default, the parameters are

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

## Games

The following values of `[R, S, T, P]` are example values for `game_parameters`.

*Prisoner's Dilemma*

`[1, -1, 2, 0]` (variant with *2P<S+T<2R*)

`[3, -1, 9, 0]` (variant with *S+T>2R*)

`[4, 0, 5, 3]` (variant with *S+T<2P*)

*Snowdrift Game*

`[3, 0, 4, -1]` (variant with *S+T<2R*)

`[3, 0, 9, -1]` (variant with *S+T>2R*)

*Stag Hunt Game*

`[5, 1, 4, 2]` (variant with *S+T>2P*)

`[4, 0, 3, 2]` (variant with *S+T<2P*)

*Battle of the Sexes Game*

`[1, 3, 2, 0]`

## Contact information
Please direct questions to Alex McAvoy (`alexmcavoy@gmail.com`) or Christian Hilbe (`hilbe@evolbio.mpg.de`).