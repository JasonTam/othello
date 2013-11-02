othello
=======

Running the Program
===================

Classic Reversi game with AI

All .c files should be compiled with mex first. You can do this in the MATLAB command window:

	mex getAllValid.c
	mex utility_c.c
  
Then you can run the main program by running:

	main.m

You will then be asked to choose between
"Human vs AI" or "AI vs AI"

If you choose "Human vs AI", you the have the choice between playing as black or white.

The sidebar gives you access to certain game settings and options. You can load game states or save the current game state. The game timeline can be altered by moving the iteration slider or changing the iteration number text box. The allotted for the AI to think can also be changed here. By default, the AI is given 1 second to think, but you can change that at any point in the game. The current score of the game is also displayed on the sidebar.

When the game finishes, you will be prompted to either play again or not. If "Yes" is chosen, a new game is start. If "No" or "cancel" is chosen, the current end game will just stay put. You can then review the game by changing the move iteration slider or text box.

Implementation
==============

I chose to implement this in MATLAB mostly because I thought it would be interesting. Another reason, is that I wanted to learn how to build C code into MATLAB functions using MEX. 

The boards are represented as matrices  where 0 represents an empty spot, -1: a black token, and 1: a white token. Initially, finding all valid moves was implemented in MATLAB using image dilation techniques using a 3x3 ones matrix. However, profiling showed that this was too slow. So finding all valid moves was implemented in C code. This was done using an array of function pointers representing the eight rays emanating from a candidate move position. Candidate locations are empty and a neighbor of an enemy token. Candidates that produced a nonzero number of flips are returned as a vector of actions. Their corresponding resultant boards are also returned as a 3D matrix of valid next-boards.

The AI itself is implemented using a minimax decision with alpha-beta pruning. The heuristic is calculated based on a weighted sum of score, number of corners, and mobility. The heuristic is zero-sum, so Min's benefits are subtracted from Max's benefits etc. The heuristic function is meant to be calculated quickly as well, so this was another function I implemented in C and built back into MATLAB using MEX.

Concluding Remarks
==================

In hindsight, I would definitely never make a professional release-ready game in MATLAB (or for any final product). However, it was a fun experience and I definitely learned a lot from having to use MEX.
