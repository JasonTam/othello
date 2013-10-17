function [ B ] = importBoard( filePath )
%IMPORTBOARD Loads a saved board state from a external file
%   Detailed explanation goes here

n = 8;

fileID = fopen(filePath);

formatSpec = repmat('%d',[1 n]);

B = textscan(fileID, formatSpec,'CollectOutput',true);
fclose(fileID);


B = cell2mat(B);
B = B(1:n,:);


% I use -1 instead of 2
B(B==2) = -1;



end

