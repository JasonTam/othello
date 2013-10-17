function iB = initBoard(n,wTok,bTok)
%INITBOARD Returns the initial board for Othello
%   n: size of the square board
%   wTok = value of white's tokens
%   bTok = value of black's tokens

%   00000000
%   00000000
%   00000000
%   000+-000
%   000-+000
%   00000000
%   00000000
%   00000000

% Default Values
if nargin<2
    wTok = 1;   % White is +1
    bTok = -1;  % Black is -1
    if nargin < 1
        n = 8;
    end
end

    iB = wTok*eye(n)+fliplr(bTok*eye(n));
    blankInd = logical(padarray(zeros(2),[n/2-1 n/2-1],1));
    iB(blankInd) = 0;

end