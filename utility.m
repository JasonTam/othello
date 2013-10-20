function [ utilScore ] = utility( board )
%UTILITY Summary of this function goes here
%   Calculates the heuristic of the current state

n= 8;
if nargin<2
    type = 2;
end

% % Need to fix stuff depending on which token is Max/Min
% % Right now we assume computer (Max) is White (+1)

type = 2;    
    switch type
        case 1
            utilScore = sum(board(:));
        case 2
            
            % Parity
            h_par = sum(board(:))/sum(abs(board(:)));
            
            % Mobility
            [ ~, aMax] = getAllValid( board, 1 );
            [ ~, aMin] = getAllValid( board, -1 );
            h_mob = (numel(aMax)-numel(aMin))/(numel(aMax)+numel(aMin));
%             h_mob = 0;
            % Corners
            corners = board([1 n],[1 n]);
            h_cor = sum(corners(:))/sum(abs(corners(:)));
            h_cor(isnan(h_cor)) = 0;
            
            % Stability
            h_s = 0;
            
            % Weights
            w_p = 10;
            w_m = 80;
            w_c = 800;
            w_s = 200;
            w = [w_p;w_m;w_c;w_s];
            
            % Total
            h = [h_par;h_mob;h_cor;h_s];
            utilScore = dot(w,h);
            
%             disp(h)
            
    end
    

end

