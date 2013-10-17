function [ action ] = minimaxDecision( curBoard, curTok, limit )
%MINIMAX Summary of this function goes here
%   Detailed explanation goes here
%     c: children boards

% %  TODO:: pass only the action rather than the entire boards

    [ c, ~] = getAllValid( curBoard, curTok );
    nCandy = size(c,3);     % # children for root
    vals = zeros([1, nCandy]);
    for i = 1:nCandy;
        vals(i) = minValue(c(:,:,i),-curTok,limit-1);
    end
    [v, aInd] = max(vals);
    action = c(:,:,aInd);
    
    if isnan(v)
        disp('Cutoff was reached')
    else
        disp(v)
    end
    toc
end



% % % % % % COuld probably do something clever with anonymous functs here
%% MAXVALUE
function v = maxValue(board,tok,limit)
% Decision tree to avoid extra calculations
    if (limit==0) || all(board(:))
            v = utility(board);
    else
        [ c, ~] = getAllValid( board, tok );
        if isempty(c)
            v = utility(board);
        else
            v = -Inf;
            nCandy = size(c,3);     % # children for root 
            for i = 1:nCandy
                v = max([v minValue(c(:,:,i),-tok,limit-1)]);
            end
        end
    end
end
%% MINVALUE
function v = minValue(board,tok,limit)
% Decision tree to avoid extra calculations
    if (limit==0) || all(board(:))
            v = utility(board);
    else
        [ c, ~] = getAllValid( board, tok );
        if isempty(c)
            v = utility(board);
        else
            v = +Inf;
            nCandy = size(c,3);     % # children for root 
            for i = 1:nCandy
                v = min([v maxValue(c(:,:,i),-tok,limit-1)]);
            end
        end
    end
end
