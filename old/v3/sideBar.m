% % % % % SIDEBAR
function sB = sideBar(h)

    parent = h.fig;
    
%% Load Game
    sB.buttonLoad = uicontrol(...    % Load game state from file
        'Parent', parent,...
        'style','pushbutton',...
        'Units','Normalized',...
        'position', [.9 .9 .08 .05],...
        'string', 'Load',...
        'Callback', @loadBoard);
    
    sB.buttonSave = uicontrol(...    % Save game state from file
        'Parent', parent,...
        'style','pushbutton',...
        'Units','Normalized',...
        'position', [.8 .9 .08 .05],...
        'string', 'Save',...
        'Callback', @saveBoard);

    function loadBoard(buttonHandle, eventdata)
        [filename, pathname] = ...
            uigetfile({'*.txt';'*.*'},'Choose Board');
        if ~(filename); return; end;
        h = guidata(h.fig); % Get GUI data.
        h.B(:,:,h.iter) = importBoard(strcat(pathname,filename));
% % % % % % TODO: should count the # of tokens o the board to determine iter 
%             Should probably find out who pTok is now
        [~, actions] = getAllValid( h.B(:,:,h.iter), h.turn );
        drawGrid(h);    % Clear the previous higlighted moved
        drawValids(h,actions);
        drawBoard(h,h.B(:,:,h.iter));
        guidata(h.fig,h) % Save GUI data before returning.
    end

    function saveBoard(buttonHandle, eventdata)
        [filename, pathname] = ...
            uiputfile({'*.txt';'*.*'},'Choose Board');
        if ~(filename); return; end;
        h = guidata(h.fig); % Get GUI data.
        B = h.B(:,:,h.iter);
        exportBoard(B, strcat(pathname,filename));

    end

%% Set AI Time Limit

% % Edit text box AI Time Limit
    sB.etl = text(1.06,0.28,'AI Time','FontSize',14);
    sB.eth = uicontrol('Parent', parent,...
        'Style','edit',...
        'String', h.aiTime,...
        'Units','Normalized',...
        'position', [.93 .70 .05 .05],...
        'Callback',@editAITime_callback);
    
    % ----------------------------------------------------
    % Set the AI Time
    % the edit text or display an error message.
    function editAITime_callback(hObject,eventdata)
        h = guidata(h.fig); % Get GUI data.
        et_dbl = str2double(get(hObject,'String'));
        if isnan(et_dbl)||(et_dbl<1)
            disp('Bad value')
            return
        end
        
        h.aiTime = et_dbl;
        guidata(h.fig,h)
    end


%%  [<[[[[[[[[[[[[[[SLIDER]]]]]]]]]]]]]]]]]>]

    sB.sh = uicontrol('Parent', parent,...
        'Style','slider',...
        'Max',size(h.B,3),'Min',1,'Value',h.iter,...
        'SliderStep',[1/size(h.B,3) 10/size(h.B,3)],...
        'Units','Normalized',...
        'position', [.8 .75 .18 .05],...
        'Callback',@slider_callback);
% % Edit text box iter
    sB.etl = text(1.06,0.18,'Iteration #','FontSize',14);
    sB.eth = uicontrol('Parent', parent,...
        'Style','edit',...
        'String',num2str(get(sB.sh,'Value')),...
        'Units','Normalized',...
        'position', [.93 .8 .05 .05],...
        'Callback',@edittext_callback);

    % ----------------------------------------------------
    % Set the value of the edit text component String property
    % to the value of the slider.
        function slider_callback(hObject,eventdata)
            h = guidata(h.fig); % Get GUI data.
            slider.val = round(get(hObject,'Value'));
            set(sB.eth,'String',num2str(slider.val));
            old_iter = h.iter;
            h.iter = slider.val;
            
            d_iter = h.iter - old_iter;
            h.turn = (-1)^(mod(d_iter,2))*h.turn;

%             [validMoves, candy] = getAllValid( h.B(:,:,h.iter), pTok );
            [~, actions] = getAllValid( h.B(:,:,h.iter), h.turn );
            drawGrid(h);    % Clear the previous higlighted moved
            drawValids(h,actions);
            drawBoard(h,h.B(:,:,h.iter));

            guidata(h.fig,h) % Save GUI data before returning.
        end
    % ----------------------------------------------------
    % Set the slider value to the number the user types in 
    % the edit text or display an error message.
        function edittext_callback(hObject,eventdata)
            h = guidata(h.fig); % Get GUI data.
            et_dbl = str2double(get(hObject,'String'));
            disp(et_dbl)
            if isnan(et_dbl)||(et_dbl<1)||(et_dbl>h.n^2)
                disp('Bad value')
                return
            end
            slider.val = et_dbl;
            % Determine whether slider.val is a number between the 
            % slider's Min and Max. If it is, set the slider Value.
            if isnumeric(slider.val) && length(slider.val) == 1 && ...
                slider.val >= get(sB.sh,'Min') && ...
                slider.val <= get(sB.sh,'Max')
                set(sB.sh,'Value',slider.val);
            else
             set(hObject,'String',...
                 'Move # out of bounds');
            end
            old_iter = h.iter;
            h.iter = slider.val;
            d_iter = h.iter - old_iter;
            h.turn = (-1)^(mod(d_iter,2))*h.turn;
%             [validMoves, candy] = getAllValid( h.B(:,:,h.iter), pTok );
            [~, actions] = getAllValid( h.B(:,:,h.iter), h.turn );
            drawGrid(h);    % Clear the previous higlighted moved
            drawValids(h,actions);
            drawBoard(h,h.B(:,:,h.iter));

            guidata(h.fig,h)
        end

end

