
play = 1;
while (play)
    gui;

    choice = questdlg('Play again?');
    % Handle response
    play = 0; % if[x] is pressed, no
    switch choice
        case 'No'
            play = 0;
        case 'Yes'
            play = 1;
            close all;
        case 'Cancel'
            play = 0;
        case ''
            play = 0;
    end
end
    