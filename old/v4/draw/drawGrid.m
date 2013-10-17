function drawGrid(h)
    xbox = [0 0 1/h.n 1/h.n]; % x loc of first box
    ybox = [0 1/h.n 1/h.n 0]; % y loc of first box
    
    for jj=1:h.n
        xoff = (jj-1) / h.n;
        for kk=1:h.n
            yoff = (kk-1) / h.n;
            h.chkbd(jj,kk) = fill(xoff+xbox,yoff+ybox,[0 .6 0]);
        end
    end
    
end