function [ newB ] = aiMove( b, aiTime, cTok )
%AIMOVE Summary of this function goes here
%   Detailed explanation goes here



%% Random Move AI
if 0
    [validMoves, candy] = getAllValid(b,cTok);
    choice = randi(numel(candy));
    newB = validMoves(:,:,choice);
end

%% MiniMax
d_max = 20;

% Perhaps make a vector to hold the move of each depth
% incase we want to examine the differences
for d = 1:d_max     % Iterative Deepening
    if exist('newB','var') qq = newB; end     % Previous value
    newB = minimaxDecision(b,cTok,aiTime,d);
    toc
    if isnan(newB)
        newB = qq;
        return;     % return result
    end
    fprintf('Depth Complete: %d\n',d)
end  



end

