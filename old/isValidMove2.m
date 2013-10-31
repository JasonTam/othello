function [couldB] = isValidMove2(b,coord,Tok)
%ISVALID Summary of this function goes here
%   Emitting from the coord in question
%   2 horz, 2 vert, 2\diag, 2/diag
  
% If the spot is already occupied
if (abs(b(coord(2),coord(1))))
    couldB = [];
    return
end

n = size(b,1);

rays = zeros([8,n-1]);

% Diagonals
d1 = diag(b,coord(1)-coord(2));
d2 = diag(fliplr(b),(n-coord(1)+1)-coord(2));


% %  Hard code is faster than computing this every time
% dq = repmat(1:n,[n 1]);
% dInds1 = tril(dq)'+tril(dq,-1);
% dInds2 = fliplr(dInds1);

dInds1 = [
     1     1     1     1     1     1     1     1
     1     2     2     2     2     2     2     2
     1     2     3     3     3     3     3     3
     1     2     3     4     4     4     4     4
     1     2     3     4     5     5     5     5
     1     2     3     4     5     6     6     6
     1     2     3     4     5     6     7     7
     1     2     3     4     5     6     7     8];

dInds2 = [
     1     1     1     1     1     1     1     1
     2     2     2     2     2     2     2     1
     3     3     3     3     3     3     2     1
     4     4     4     4     4     3     2     1
     5     5     5     5     4     3     2     1
     6     6     6     5     4     3     2     1
     7     7     6     5     4     3     2     1
     8     7     6     5     4     3     2     1];

dI1 = dInds1(coord(2),coord(1));
dI2 = dInds2(coord(2),coord(1));

%% Extracting the rays
% Padarray is slower than brute force concat
% fliplr/flipud is slower than reverse indexing
% Verts
rays(1,:) = [b(coord(2)-1:-1:1,coord(1)); zeros([n-coord(2) 1])];
rays(2,:) = [b(coord(2)+1:end,coord(1)); zeros([coord(2)-1 1])];
% Hors
rays(3,:) = [b(coord(2),coord(1)-1:-1:1), zeros([1 n-coord(1)])];
rays(4,:) = [b(coord(2),coord(1)+1:end), zeros([1 coord(1)-1])];
% Diag \
rays(5,:) = [d1(dI1-1:-1:1); zeros([n-dI1 1])];
rays(6,:) = [d1(dI1+1:end); zeros([n-numel(d1(dI1+1:end))-1 1])];
% Diag /
rays(7,:) = [d2(dI2-1:-1:1); zeros([n-dI2 1])];
rays(8,:) = [d2(dI2+1:end); zeros([n-numel(d2(dI2+1:end))-1 1])];

% Analyze if peices will be flipped
newrays = rayFlip2( rays, Tok );

% Replacements
rV = [newrays(1,coord(2)-1:-1:1), 0, newrays(2,1:n-coord(2))];
rH = [newrays(3,coord(1)-1:-1:1), 0, newrays(4,1:n-coord(1))];
rD1 = [newrays(5,dI1-1:-1:1), 0, newrays(6,1:numel(d1(dI1+1:end)))];
rD2 = [newrays(8,numel(d2(dI2+1:end)):-1:1), 0, newrays(7,1:dI2-1)]; % strange because of columnwise replacement later

drI1 = logical(diag(ones([numel(rD1) 1]),coord(1)-coord(2)));
drI2 = logical(fliplr(diag(ones([numel(rD2) 1]),(n-coord(1)+1)-coord(2))));

couldB = b;

couldB(:,coord(1)) = rV;
couldB(coord(2),:) = rH;
couldB(drI1) = rD1;
couldB(drI2) = rD2;

if couldB==b    % board has not changed -- invalid move
   couldB = []; 
else
    couldB(coord(2),coord(1)) = Tok;
end


end

