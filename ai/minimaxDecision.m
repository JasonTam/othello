function [ newB ] = minimaxDecision( curBoard, curTok, aiTime, limit )
%MINIMAX Summary of this function goes here
%   Detailed explanation goes here
%     c: children 
%       with alpha beta pruning

% %  TODO:: pass only the action rather than the entire boards
    global t_thresh; t_thresh = aiTime/40+0.02;
    global cTok; cTok = curTok;
    alpha = -Inf;
    beta = +Inf;

    [ c, ~] = getAllValid( curBoard, curTok );
    nCandy = size(c,3);     % # children for root
    if (nCandy>1)
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
        
    else%if (nCandy==1)
        % If there's only one move, take it
        newB = c(:,:,1);
    end
end


% % % % % % Could probably do something clever with anonymous functs here
%% MAXVALUE
% Max's Move
function v = maxValue(board,tok,alpha,beta,aiTime,limit)
global t_thresh;
global cTok;
if (toc>=aiTime-t_thresh)
%     fprintf('Partial Depth: %d\n',limit);
    v = nan;
    return;
end

% Decision tree to avoid extra calculations
    if (limit==0) || all(board(:))
            v = utility_c(board,cTok);
    else
        [ c, ~] = getAllValid( board, tok );
        if isempty(c)   % Max has no moves
%             v = utility(board);
            v = -Inf;
            v = max([v minValue(board,-tok,alpha,beta,aiTime,limit-1)]);
            if (v>beta); return; end
            alpha = max(alpha,v);
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
% Min's Move
function v = minValue(board,tok,alpha,beta,aiTime,limit)
global t_thresh;
global cTok;
if (toc>=aiTime-t_thresh)
%     fprintf('Partial Depth: %d\n',limit);
    v = nan;
    return;
end

% Decision tree to avoid extra calculations
    if (limit==0) || all(board(:))
            v = utility_c(board,cTok);
    else
        [ c, ~] = getAllValid( board, tok );
        if isempty(c)   % Min has no moves
%             v = utility(board);
            v = +Inf;
            v = min([v maxValue(board,-tok,alpha,beta,aiTime,limit-1)]);
            if (v<alpha); return; end
            beta = min([beta v]);
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
