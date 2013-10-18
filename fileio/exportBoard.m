function [ B ] = exportBoard( h, filePath )
%EXPORTBOARD Saves board state to an external file
%   Detailed explanation goes here

B = h.B(:,:,h.iter);
B(B==-1) = 2;   % Convert -1's back into 2's

% Write the actual board
dlmwrite(filePath,B,'delimiter',' ');
fileID = fopen(filePath,'a');   % Append
% Write turn (I use -1 instead of 2)
fprintf(fileID,'%d\n',(3-h.turn)/2);
% Write AI time
fprintf(fileID,'%d\n',h.aiTime);
fclose(fileID);

end