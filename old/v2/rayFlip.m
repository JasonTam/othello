function [ newRay ] = rayFlip( ray, pTok )
%RAYFLIP Summary of this function goes here
%   Detailed explanation goes here

i = find(abs(diff(ray)),1);
newRay = ray;

if ~isempty(ray(i+1))&&~isempty(ray(i))
    if (ray(i+1)==pTok)&&(abs(ray(i)))
        %    score_q += i 
        % Do the actual flipping
        newRay(1:i) = pTok;
    end
end
end

