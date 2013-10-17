function [ nextBoards, actions] = getAllValid( b, tok )
%GETALLVALID Returns valid moves given a board and whose turn it is
%   actions: valid positions for moves
%   nextBoards: the new boards after candidate actions

n = size(b,1);

[y, x] = ndgrid(1:n,1:n);

% Get indices of reasonable candidates (next to opponent's tokens)
boundInd = find(edgeDilate(b,tok));

validMoves = zeros([n n numel(y)]);
validInds = zeros([numel(y) 1]);

for i = boundInd'
    coord = [x(i) y(i)];
    couldB = isValidMove(b,coord,tok);
    if ~isempty(couldB) % if it is a valid move
        validMoves(:,:,i) = couldB;
        validInds(i) = i;
    end
end

actions = unique(validInds); actions(1) = [];
nextBoards = validMoves(:,:,actions);

end

