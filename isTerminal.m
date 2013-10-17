function [ ret ] = isTerminal( board, tok )
%ISTERMINAL Summary of this function goes here
%   Detailed explanation goes here
    [ c, ~] = getAllValid( board, tok );
    ret = false;
    if isempty(c)||all(board(:))
        ret = true;
    end

end

