function [ tok ] = promptTokColor(  )
%PROMPTTOKCOLOR Summary of this function goes here
%   Detailed explanation goes here
    
choice = questdlg('', ...
	'Choose Token', ...
	'Black','White','Black');
% Handle response
switch choice
    case 'Black'
        tok = -1;
    case 'White'
        tok = 1;
end

if ~exist('tok','var'); tok = -1; end;

end

