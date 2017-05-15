%Function No!
%This is False!

p = picSource(bestY/scale:(bestY+bestSi)/scale,bestX/scale:(bestX+bestSi)/scale,:);
files = dir(strcat('bad\','*.jpg'));
filename = ['bad\' num2str(length(files)+1) '.jpg'];
imwrite(p,filename);
