function board = DrawBox(board,x,y,si,line,rgb)
    x = int32(x);
    y = int32(y);
    si = int32(si);
    color = zeros(1,1,3);
    color(1,1,:) = rgb;
    
    [height,width,~] = size(board);
    
    up1 = max(1,y - line);
    up2 = max(1,y);
    left1 = max(1,x - line);
    left2 = max(1,x);
    right1 = min(width,x + si + line);
    right2 = min(width,x + si);
    down1 = min(height,y + si + line);
    down2 = min(height,y + si);
    
    board(up1:up2,left1:right1,:) = repmat(color,up2 - up1 + 1,right1 - left1 + 1);
    board(down2:down1,left1:right1,:) = repmat(color,down1 - down2 + 1,right1 - left1 + 1);
    board(up2:down2,left1:left2,:) = repmat(color,down2 - up2 + 1,left2 - left1 + 1);
    board(up2:down2,right2:right1,:) = repmat(color,down2 - up2 + 1,right1 - right2 + 1);
    
end