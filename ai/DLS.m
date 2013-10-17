% % % % % % % ERR NOT USED

function [ ret ] = DLS( node, problem, limit )
%DLS Summary of this function goes here
%   Detailed explanation goes here

    if isGoal(node)
        ret = node;
    elseif (limit==0)   % cutoff
        ret = NaN;
    else 
        for c = candies
            ret = DLS(c,problem,limit-1);
        end
    end

end

