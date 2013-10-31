function [ newMorays ] = rayFlip2( morays, pTok )
%RAYFLIP Summary of this function goes here
%   Detailed explanation goes here

q = diff(morays,1,2);
[~, inq] = max(abs(logical(q)),[],2);
[reqV, reqI] = max(q==(2*pTok),[],2);
[~, req2I] = max(morays==pTok,[],2);

valid = logical(inq==reqI).*logical(req2I>1).*logical(reqV);
r_ind = find(valid);

newMorays = morays;

for r = r_ind'
    i = reqI(r);
    newRay = morays(r,:);

    % Do the actual flipping
    newRay(1:i) = pTok;
    newMorays(r,:) = newRay;
end

end

