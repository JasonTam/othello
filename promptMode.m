function [ mode ] = promptMode(  )
%PROMPTMODE Summary of this function goes here
%   Detailed explanation goes here
    
choice = questdlg('', ...
	'Choose Mode', ...
	'Human vs AI','AI vs AI','Human vs AI');
% Handle response
switch choice
    case 'Human vs AI'
        mode = 0;
    case 'AI vs AI'
        mode = 1;
end

if ~exist('mode','var'); mode = 0; end;

end

