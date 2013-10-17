function buttonTest

h.fig = figure('position',[1100 30 210 60]);

h.button1 = uicontrol('style','pushbutton',...
    'position', [10 10 100 40],...
    'string', 'Add a button');

set(h.button1, 'callback', {@addButton, h});

end


function h = addButton(hObject, eventdata, h)

h.button2 = uicontrol('style','pushbutton',...
    'position', [100 10 100 40],...
    'string', 'Remove a button');

set(h.button2,'callback', {@removeButton,h});
set(h.button1,'enable','off');

end

function h = removeButton(hObject, eventdata, h)

delete(h.button2)
h = rmfield(h,'button2');
set(h.button1,'enable','on');

end