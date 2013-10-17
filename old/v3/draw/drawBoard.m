function drawBoard(h,b)
    [rb, cb] = find(b<0);    % Neg is black
    [rw, cw] = find(b>0);    % Pos is white

    for p = [rb cb]'
        y = p(1); x = p(2);
        xoff = (x-1)/h.n;
        yoff = (y-1)/h.n;
        h.occupied(x,y) = ...
            patch(xoff+h.xcirc,yoff+h.ycirc,'black');
%         set(h.occupied(jj,kk),'EdgeColor','b','Linewidth',2);
    end
    for p = [rw cw]'
        y = p(1); x = p(2);
        xoff = (x-1)/h.n;
        yoff = (y-1)/h.n;
        h.occupied(x,y) = ...
            patch(xoff+h.xcirc,yoff+h.ycirc,'white');
%         set(h.occupied(jj,kk),'EdgeColor','b','Linewidth',2);
    end
end