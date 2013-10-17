function [ edge ] = edgeDilate( board, tok )
%EDGEDILATE Summary of this function goes here
%   We know that candidate moves need to be at least
%   touching an existing enemy token
%   and not on an existing token's position

%     se = strel('square',3);
    se = ones(3);
    edge = imdilate(board==-tok,se) - abs(board);

end

