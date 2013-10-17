
        sB.buttonLoad = uicontrol(...    % Load game state from file
            'Parent', parent,...
            'style','pushbutton',...
            'Units','Normalized',...
            'position', [.8 .9 .15 .05],...
            'string', 'Load Game',...
            'Callback', @loadBoard);
        
        sB.buttonBck = uicontrol(...    % Move game state back
            'Parent', parent,...
            'style','pushbutton',...
            'Units','Normalized',...
            'position', [.8 .8 .05 .05],...
            'string', '<<',...
            'Callback', @iterBck);
        sB.buttonFwd = uicontrol(...    % Move game state forward
            'Parent', parent,...
            'style','pushbutton',...
            'Units','Normalized',...
            'position', [.9 .8 .05 .05],...
            'string', '>>',...
            'Callback', @iterFwd);

%         if h.iter<=1
%             set(sB.buttonBck,'enable','off');
%         end
    % %     uhhh, >> should be disabled..when?!


        function loadBoard(buttonHandle, eventdata)
            [filename, pathname] = ...
                uigetfile({'*.txt';'*.*'},'Choose Board');
            h.B(:,:,h.iter) = importBoard(strcat(pathname,filename));
            
%             Should probably find out who pTok is now
            [validMoves, candy] = getAllValid( h.B(:,:,h.iter), pTok );
            drawGrid(h);    % Clear the previous higlighted moved
            drawValids(h,candy);
            drawBoard(h,h.B(:,:,h.iter));
        end
    
        function iterBck(buttonHandle, eventdata)
            disp('<<-');
            drawGrid(h)
            h = guidata(h.fig);
            if h.iter >1
                h.iter = h.iter-1;
            end
%             guidata(buttonHandle, h);
            fprintf('sB iter = %d \n',h.iter)
            drawBoard(h,h.B(:,:,h.iter));
    %         May also need to change the message of whose turn it is
            guidata(h.fig,h); % to save data again

        end

        function iterFwd(buttonHandle, eventdata)
            disp('->>');
            drawGrid(h)     % shouldn't need this for going fwd
            h = guidata(h.fig);
            h.iter = h.iter+1;
%             guidata(buttonHandle, h);
            fprintf('sB iter = %d \n',h.iter)
            drawBoard(h,h.B(:,:,h.iter));
    %         May also need to change the message of whose turn it is
            guidata(h.fig,h); % to save data again
        end
        