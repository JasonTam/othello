function [ utilScore ] = utility( board )
%UTILITY Summary of this function goes here
%   Calculates the heuristic of the current state

    utilScore = sum(board(:));

end

