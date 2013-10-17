% % % % % % % ERR NOT USED

function [ ret ] = IDS( node, tok )
%IDS Summary of this function goes here
%   Detailed explanation goes here

for depth = 0:60
    result = DLS(problem,depth);
    if result ~= cutoff
        break;  % return result
    end
end  


[ validMoves, candy] = getAllValid( node, tok );



end

