function box = BuildBox(x,y,si)
    box = zeros(4,2);
    box(1,:) = [x,y];
    box(2,:) = [x+si,y];
    box(3,:) = [x+si,y+si];
    box(4,:) = [x,y+si];
end