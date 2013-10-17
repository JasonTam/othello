function [ newMorays ] = rayFlip2( morays, pTok )
%RAYFLIP Summary of this function goes here
%   Detailed explanation goes here

% [i, j] = find(diff(morays,1,2)==(2*pTok))

[mv, mi] = max(abs(diff(morays,1,2)),[],2);
first = logical(mv).*mi;
all_inds = 1:size(morays,1);
r_ind = all_inds(logical(mv));

newMorays = morays;
for r = r_ind
    i = first(r);
    ray = morays(r,:);
%     i = find(abs(diff(ray)),1);


    newRay = ray;

    if ~isempty(ray(i+1))&&~isempty(ray(i))
        if (ray(i+1)==pTok)&&(abs(ray(i)))
            %    score_q += i 
            % Do the actual flipping
            newRay(1:i) = pTok;
        end
    end
    newMorays(r,:) = newRay;
end



end

