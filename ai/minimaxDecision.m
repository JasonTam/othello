function [ newB ] = minimaxDecision( curBoard, curTok, aiTime, limit )
%MINIMAX Summary of this function goes here
%   Detailed explanation goes here
%     c: children 
%       with alpha beta pruning

% %  TODO:: pass only the action rather than the entire boards
    global t_thresh; t_thresh = 0.02;
    alpha = -Inf;
    beta = +Inf;

    [ c, ~] = getAllValid( curBoard, curTok );
    nCandy = size(c,3);     % # children for root
    vals = zeros([1, nCandy]);
    for i = 1:nCandy;
        vals(i) = minValue(c(:,:,i),-curTok,alpha,beta, aiTime, limit-1);
        if isnan(vals(i)); newB = nan; return; end;
    end
    [v, aInd] = max(vals);
    % Break ties randomly
    indC = find(vals==v); aInd = indC(randi(numel(indC)));
    
    newB = c(:,:,aInd);
    
    if isnan(v)
        disp('Cutoff was reached')
        % remember to use the best candidate from the previous depth
    else
%         fprintf('Heuristic Val: %f\n',v)
    end
%     toc
end


% % % % % % Could probably do something clever with anonymous functs here
%% MAXVALUE
function v = maxValue(board,tok,alpha,beta,aiTime,limit)
global t_thresh;
if (toc>=aiTime-t_thresh)
    fprintf('Partial Depth: %d\n',limit);
    v = nan;
    return;
end

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
                v = max([v minValue(c(:,:,i),-tok,alpha,beta,aiTime,limit-1)]);
                if (v>beta); return; end
                alpha = max(alpha,v);                    
            end
        end
    end
end
%% MINVALUE
function v = minValue(board,tok,alpha,beta,aiTime,limit)
global t_thresh;
if (toc>=aiTime-t_thresh)
    fprintf('Partial Depth: %d\n',limit);
    v = nan;
    return;
end

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
                v = min([v maxValue(c(:,:,i),-tok,alpha,beta,aiTime,limit-1)]);
                if (v<alpha); return; end
                beta = min([beta v]);
            end
        end
    end
end
