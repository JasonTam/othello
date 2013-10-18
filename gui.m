%% Jason Tam
% ECE 469 AI - Sable
% Fall 2013


% I had to overwrite the default ginput
% so that I could specify my own pointer
% (Note that with the original full crosshair, it would disappear)

% % TODO : 
% %  stop spamming guidata, only use it when necessary
% %  Need to make sure a player has valid moves
% % Need to check end game


function gui

%% Initialization
    addpath('draw')
    addpath('ai')
    addpath('fileio')
    set(0,'DefaultFigureWindowStyle','normal') 
    % global h
    h.n = 8;    % Size of board
    h.fig = figure;
    h.aiTime = 1;               % Seconds for AI move
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
    h.scorehead = text(1.06,0.34,'Black : White','FontSize',12);
    h.score = text(1.08,0.4,'2 : 2','FontSize',26);

    drawBoard(h,h.B(:,:,h.iter));

    guidata(h.fig,h)

    sideh = sideBar(h);

%% Choose Token Color
% Hard Code
%     h.pTok = -1;
%     h.cTok = 1;
%     Select
h.pTok = promptTokColor;
h.cTok = -h.pTok;
    guidata(h.fig,h)
    
%% Begin main game

    while ~all(all(h.B(:,:,h.iter)))
        h = guidata(h.fig);
        
%         fprintf('Outside iter = %d \n',h.iter)
        updateSide(sideh, h.iter);
        
%% [HUMAN MOVE]
        if (h.turn == h.pTok) % && there are valid moves for black
            set(h.indicator,'String','Black''s Move');
            set(h.indicator,'Color',[0 0 0]);

            [~, actions] = getAllValid( h.B(:,:,h.iter), h.pTok );
            if isempty(actions)
%                 The turn will swap back to h.cTok later
                h.iter = h.iter - 1;
                break 
            end
            drawValids(h,actions);

            % Have the player decide on a move to make
            try
                newB = [];
                while (isempty(newB))
                    guidata(h.fig,h);
                    % Game pauses here to get player input
                    pCoord = getPMoveCoord(h);
                    h = guidata(h.fig);     % Udate incase sidebar was used
                    if (isnan(pCoord))      % Massive workaround for loading while user input
                        % Need to pre-emptively negate effects later
                        newB = h.B(:,:,h.iter);
                        h.turn = -h.turn;
                        h.iter = h.iter - 1;
                        break 
                    end
                    newB = isValidMove2(h.B(:,:,h.iter),pCoord,h.pTok);

                    if (isempty(newB))
                        set(h.status,'String','Not a valid move');
                    end
                end    

            catch exception     % User force quit [X]
                disp('User exited')
                disp(exception.message)
                return
            end
            h.B(:,:,h.iter+1) = newB;
            guidata(h.fig,h);
            drawGrid(h) % Need this if we highlight valid moves for the player
%% [AI MOVE]
        elseif (h.turn == h.cTok)
            set(h.indicator,'String','White''s Move');
            set(h.indicator,'Color',[1 1 1]);
            
            [~, actions] = getAllValid( h.B(:,:,h.iter), h.cTok );
            if isempty(actions)
%                 The turn will swap back to h.pTok later
                h.iter = h.iter - 1;
                break 
            end
            tic     % Note that tic is global
            h.B(:,:,h.iter+1) = aiMove(h.B(:,:,h.iter), h.aiTime, h.cTok);
            toc
            guidata(h.fig,h);
        end
        
        h.iter = h.iter+1;
        h.turn = -h.turn;

        guidata(h.fig,h);
        drawBoard(h,h.B(:,:,h.iter));
        drawnow
        updateScore
    end
    
%% HANDLE ENDGAME    

    disp('GAME OVER')
    
    
    %% NESTED FUNCTIONS
    % Update the Score
    function updateScore
        board = h.B(:,:,h.iter);
        wS = sum(board(:)>0);
        bS = sum(board(:)<0);
        set(h.score,'String',...
            strcat(num2str(bS),' : ',num2str(wS)));
    end

    
end


%% MORE FUNCTIONS

% User Click Input
function clkCoord = getPMoveCoord(h)
    clkCoord = ceil(ginput(1)*h.n);     % [row, col]
    h = guidata(h.fig);     % Udate incase sidebar was used
    % x = clkCoord(1);
    % y = clkCoord(2);
    while (max(clkCoord)>h.n)&&(h.turn==h.pTok)
        h = guidata(h.fig);     % Udate incase sidebar was used
        set(h.status,'String','Click on the board');
        clkCoord = ceil(ginput(1)*h.n); % [row, col]
    end
    set(h.status,'String','');
    % If a different game was loaded while waiting for input
    if (h.turn~=h.pTok);clkCoord=nan;end;
end

% Update Sidebar
function updateSide(sB, iter)
    set(sB.eth_iter,'String',num2str(iter));
    set(sB.sh,'Value',iter);
end





