function [couldB] = isValidMove(b,coord,Tok)
%ISVALID Summary of this function goes here
%   Emitting from the coord in question
%   2 horz, 2 vert, 2\diag, 2/diag
  
% If the spot is already occupied
if (abs(b(coord(2),coord(1))))
    couldB = [];
    return
end

n = size(b,1);

rays = cell(8,1);

% Vertical
rays{1} = flipud(b(1:coord(2)-1,coord(1)));
rays{2} = b(coord(2)+1:end,coord(1));
% Horizontal
rays{3} = flipud(b(coord(2),1:coord(1)-1).');
rays{4} = b(coord(2),coord(1)+1:end).';

% Diagonals
d1 = diag(b,coord(1)-coord(2));
d2 = diag(fliplr(b),(n-coord(1)+1)-coord(2));

dq = repmat(1:n,[n 1]);
dInds1 = tril(dq)'+tril(dq,-1);
dInds2 = fliplr(dInds1);
dI1 = dInds1(coord(2),coord(1));
dI2 = dInds2(coord(2),coord(1));

rays{5} = flipud(d1(1:dI1-1));
rays{6} = d1(dI1+1:end);

rays{7} = flipud(d2(1:dI2-1));
rays{8} = d2(dI2+1:end);

testRay = @(r) rayFlip(r,Tok);

newRays = cellfun(testRay,rays,'UniformOutput',0);

% %  Make the flips

% Replacements
rV = [flipud(newRays{1}); 0; newRays{2}];
rH = [flipud(newRays{3}); 0; newRays{4}];
rD1 = [flipud(newRays{5}); 0; newRays{6}];
rD2 = [flipud(newRays{7}); 0; newRays{8}];

drI1 = logical(diag(ones([numel(rD1) 1]),coord(1)-coord(2)));
drI2 = logical(fliplr(diag(ones([numel(rD2) 1]),(n-coord(1)+1)-coord(2))));

couldB = b;

couldB(:,coord(1)) = rV;
couldB(coord(2),:) = rH;
couldB(drI1) = rD1;
couldB(drI2) = flipud(rD2);

if couldB==b    % board has not changed -- invalid move
   couldB = []; 
else
    couldB(coord(2),coord(1)) = Tok;
end


end

