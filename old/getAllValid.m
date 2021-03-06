function [ nextBoards, actions] = getAllValid( b, tok )
%GETALLVALID Returns valid moves given a board and whose turn it is
%   actions: valid positions for moves
%   nextBoards: the new boards after candidate actions

% mode = 'matlab';
mode = 'c';

if strcmp(mode,'c')
%     [nextBoards, actions] = getAllValid_c(b, tok );
    [nextBoards, actions] = getAllValidint_c(int32(b), int32(tok) );
    nextBoards = double(nextBoards); actions = double(actions);
elseif strcmp(mode,'matlab')
    n = size(b,1);

    [y, x] = ndgrid(1:n,1:n);

    % Get indices of reasonable candidates (next to opponent's tokens)
    % boundInd = find(edgeDilate(b,tok));

    validMoves = zeros([n n numel(y)]);
    validInds = zeros([numel(y) 1]);

    % for i = boundInd'
    parfor i = 1:64
        coord = [x(i) y(i)];
        couldB = isValidMove2(b,coord,tok);
        if ~isempty(couldB) % if it is a valid move
            validMoves(:,:,i) = couldB;
            validInds(i) = i;
        end
    end

    actions = unique(validInds); actions(1) = [];
    nextBoards = validMoves(:,:,actions);
end


end

