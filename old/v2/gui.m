% Jason Tam

% I had to overwrite the default ginput
% so that I could specify my own pointer
% (Note that with the original full crosshair, it would disappear)

% % TODO : 
% %  stop spamming guidata, only use it when necessary
% %  Need to make sure a player has valid moves
% % Need to check end game


function gui

    addpath('draw')
    addpath('ai')
    set(0,'DefaultFigureWindowStyle','normal') 
    % global h
    h.n = 8;    % Size of board
    h.fig = figure;
    set(h.fig,'ToolBar','none');
    set(h.fig,'MenuBar','none');
    set(h.fig,'Units','Normalized');
    set(h.fig,'Name','Othello','NumberTitle','off');
    set(h.fig, 'Position', [0.1 0.1 .4 .5]);

    h.axes = axes('Position',[0 0 1 1],...
    'Color',[0.5 0.5 0.5],'Units','Normalized',...
    'Xtick',[],'Ytick',[]);
    axis([0 1.3 0 1]);          % to give some space for controls/msgs
    axis ij                     % flips the y axis

    hold on
    h.chkbd = zeros(h.n,h.n);
    h.occupied = zeros(h.n,h.n); % hold handles of pieces

    theta = linspace(0,2*pi,25);
    h.xcirc = 0.5/h.n + 0.05 * cos(theta); % circle pieces
    h.ycirc = 0.5/h.n + 0.05 * sin(theta); % circle pieces

    drawGrid(h);

    h.B = zeros([h.n h.n h .n^2-4]); % to store all possible past moves
    h.B(:,:,1) = initBoard(h.n);
    h.turn = -1;    % Dark goes first (h.turn contains a tok)
    h.iter = 1;
    h.indicator = text(1.05,0.5,'Black''s Move');
    h.status = text(1.05,0.6,'');

    drawBoard(h,h.B(:,:,h.iter));

    guidata(h.fig,h)

    sideh = sideBar(h);

    % % % Designate which player has which token
    pTok = -1;
    cTok = 1;

    for i = 2:32    % While not endgame
        h = guidata(h.fig);
        
%         fprintf('Outside iter = %d \n',h.iter)
        updateSide(sideh, h.iter);
        
%         if mod(i,2)==0 % TODO::: and black needs to have moves
% % % [HUMAN MOVE]
        if (h.turn == pTok) % && there are valid moves for black
            set(h.indicator,'String','Black''s Move');
            set(h.indicator,'Color',[0 0 0 ]);

            [~, actions] = getAllValid( h.B(:,:,h.iter), pTok );
            drawValids(h,actions);

    %         Have the player decide on a move to make
            try
                newB = [];
                while (isempty(newB))
                    guidata(h.fig,h);
%                     Game pauses here to get player input
                    pCoord = getPMoveCoord(h);
% Need to update incase sidebar was used
                    h = guidata(h.fig);
                    newB = isValidMove(h.B(:,:,h.iter),pCoord,pTok);
                    if (isempty(newB))
                        set(h.status,'String','Not a valid move');
                    end
                end    

            catch exception
    %             Catching user closing the figure via [X] button
    %               ignore the actual exception
                disp('User exited')
                return
            end
            h.B(:,:,h.iter+1) = newB;
            h.iter = h.iter+1;
            h.turn = -h.turn;
            guidata(h.fig,h);
            drawGrid(h) % Need this if we highlight valid moves for the player
        elseif (h.turn == cTok)
            set(h.indicator,'String','White''s Move');
            set(h.indicator,'Color',[1 1 1]);

    %         h.B(:,:,h.iter) = h.B(:,:,h.iter-1); % make computer do nothing
            
            h.B(:,:,h.iter+1) = aiMove(h.B(:,:,h.iter),cTok);
            h.iter = h.iter+1;
            h.turn = -h.turn;
            guidata(h.fig,h);
        end
        
% %         TODO: maybe pull down h.iter,h.turn updates down here
        guidata(h.fig,h);
        drawBoard(h,h.B(:,:,h.iter));
        drawnow
    end

end


% % % % % % % % % % % % % %  MORE FUNCTIONS

function clkCoord = getPMoveCoord(h)
    clkCoord = ceil(ginput(1)*h.n); % [row, col]
% x = clkCoord(1);
% y = clkCoord(2);
    while max(clkCoord)>h.n
        set(h.status,'String','Click on the board');
        clkCoord = ceil(ginput(1)*h.n); % [row, col]
    end
    set(h.status,'String','');
end

function updateSide(sB, iter)
    set(sB.eth,'String',num2str(iter));
    set(sB.sh,'Value',iter);
end





