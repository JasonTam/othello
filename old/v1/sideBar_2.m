% % % % % SIDEBAR
function sB = sideBar(h)

    parent = h.fig;
%     h.iter = guidata(h.fig);
    
    sB.buttonLoad = uicontrol(...    % Load game state from file
        'Parent', parent,...
        'style','pushbutton',...
        'Units','Normalized',...
        'position', [.8 .9 .15 .05],...
        'string', 'Load Game',...
        'Callback', @loadBoard);

    function loadBoard(buttonHandle, eventdata)
        [filename, pathname] = ...
            uigetfile({'*.txt';'*.*'},'Choose Board');
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

% % % % % % % % %  [<[[[[[[[[[[[[[[SLIDER]]]]]]]]]]]]]]]]]>]


    sB.sh = uicontrol('Parent', parent,...
        'Style','slider',...
        'Max',size(h.B,3),'Min',1,'Value',h.iter,...
        'SliderStep',[1/size(h.B,3) 10/size(h.B,3)],...
        'Units','Normalized',...
        'position', [.8 .75 .18 .05],...
        'Callback',@slider_callback);

    sB.eth = uicontrol('Parent', parent,...
        'Style','edit',...
        'String',num2str(get(sB.sh,'Value')),...
        'Units','Normalized',...
        'position', [.8 .8 .18 .05],...
        'Callback',@edittext_callback);


    % % % % % % % % % % % % % 

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
            slider.val = str2double(get(hObject,'String'));
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
%               guidata(fh,slider); % Save the changes as GUI data.
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

