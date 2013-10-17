function [ s ] = getScore( b )
%GETSCORE Gets the score of the boards
%   If boards is a 3D matrix of boards, different boards being on the 3rd
%   dimension, then corresponding scores will be on the 2nd dimension

%   [White1 Black1]
%     ...    ...  
%   [Whiten Blackn]

sW = sum(sum(b>0,1),2);
sB = sum(sum(b<0,1),2);

s = [sW sB];

end

