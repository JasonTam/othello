function slider_gui_appdata
fh = figure('Position',[250 250 350 350],...
            'MenuBar','none','NumberTitle','off',...
            'Name','Sharing Data with Application Data');
sh = uicontrol(fh,'Style','slider',...
               'Max',100,'Min',0,'Value',25,...
               'SliderStep',[0.05 0.2],...
               'Position',[300 25 20 300],...
               'Callback',@slider_callback);
eth = uicontrol(fh,'Style','edit',...
               'String',num2str(get(sh,'Value')),...
               'Position',[30 175 240 20],...
               'Callback',@edittext_callback);
sth = uicontrol(fh,'Style','text','String',...
               'Enter a value or click the slider.',...
               'Position',[30 215 240 20]);
number_errors = 0;
slider_data.val = 25;
% Create appdata with name 'slider'.
setappdata(fh,'slider',slider_data); 
% ----------------------------------------------------
% Set the value of the edit text component String property
% to the value of the slider.
   function slider_callback(hObject,eventdata)
      % Get 'slider' appdata.
      slider_data = getappdata(fh,'slider'); 
      slider_data.previous_val = slider_data.val;
      slider_data.val = get(hObject,'Value');
      set(eth,'String',num2str(slider_data.val));
      sprintf('You changed the slider value by %6.2f percent.',...
              abs(slider_data.val - slider_data.previous_val))
      % Save 'slider' appdata before returning.
      setappdata(fh,'slider',slider_data) 
end
% ----------------------------------------------------
% Set the slider value to the number the user types in 
% the edit text or display an error message.
   function edittext_callback(hObject,eventdata)
      % Get 'slider' appdata.
      slider_data = getappdata(fh,'slider');
      slider_data.previous_val = slider_data.val;
      slider_data.val = str2double(get(hObject,'String'));
      % Determine whether val is a number between the 
      % slider's Min and Max. If it is, set the slider Value.
      if isnumeric(slider_data.val) && ...
            length(slider_data.val) == 1 && ...
         slider_data.val >= get(sh,'Min') && ...
         slider_data.val <= get(sh,'Max')
         set(sh,'Value',slider_data.val);
         sprintf('You changed the slider value by %6.2f percent.',...
             abs(slider_data.val - slider_data.previous_val))
      else
      % Increment the error count, and display it.
         number_errors = number_errors+1;
         set(hObject,'String',...
             ['You have entered an invalid entry ',...
             num2str(number_errors),' times.']);
         slider_data.val = slider_data.previous_val;
      end
      % Save appdata before returning.
      setappdata(fh,'slider',slider_data); 
   end
end