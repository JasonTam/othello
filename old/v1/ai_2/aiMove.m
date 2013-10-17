function [ newB ] = aiMove( b, cTok )
%AIMOVE Summary of this function goes here
%   Detailed explanation goes here



%% Random Move AI
if 0
    [validMoves, candy] = getAllValid(b,cTok);
    choice = randi(numel(candy));
    newB = validMoves(:,:,choice);
end

%% MiniMax
d = 3;  % Depth limit 
tic
newB = minimaxDecision(b,cTok,d);

end

