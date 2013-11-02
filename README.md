othello
=======

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
