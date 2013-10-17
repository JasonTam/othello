function [ B ] = exportBoard( B, filePath )
%EXPORTBOARD Saves board state to an external file
%   Detailed explanation goes here

n = 8;

B(B==-1) = 2;   % Convert -1's back into 2's

% fileID = fopen(filePath);

dlmwrite(filePath,B,'delimiter',' ')

% fclose(fileID);

end

