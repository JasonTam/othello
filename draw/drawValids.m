function drawValids(h,candy)
    [y,x] = ind2sub([h.n h.n],candy);

    xbox = [0 0 1/h.n 1/h.n]; % x loc of first box
    ybox = [0 1/h.n 1/h.n 0]; % y loc of first box
    for i = 1:numel(x)
        xoff = (x(i)-1) / h.n;
        yoff = (y(i)-1) / h.n;
        h.chkbd(x(i),y(i)) = fill(xoff+xbox,yoff+ybox,[0 .6 .5]);
    end
end

