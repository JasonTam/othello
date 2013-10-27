function [ newB ] = aiMove( b, aiTime, cTok, d_max )
%AIMOVE Summary of this function goes here
%   Detailed explanation goes here
%   aiTime = time allowed for AI to make a move

%% TODO:: THE QQ PREV VALUE THING IS MESSED UP 

%% Random Move AI
% Use this incase of a an initial fallback required
[validMoves, candy] = getAllValid(b,cTok);
choice = randi(numel(candy));
fallBack = validMoves(:,:,choice);


%% MiniMax
if nargin < 4   % go on to depth 20 if no depth limit given
    d_max = 20;
end

% Perhaps make a vector to hold the move of each depth
% incase we want to examine the differences
for d = 1:d_max     % Iterative Deepening
    if exist('newB','var'); fallBack = newB; end     % Previous value
    newB = minimaxDecision(b,cTok,aiTime,d);
    toc
    if isnan(newB)
        newB = fallBack;
        return;     % return result
    else
        fprintf('Depth Complete: %d\n',d)
    end
end  



end

