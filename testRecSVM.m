load('modelSVM.mat');
n = 39;

%pic = imread('D:\Miku\MikuPic\025_eb08146f10263af180cb4a89.jpg');%0.3
%pic = imread('D:\Miku\MikuPic\120_http__imgloadCA00W52D.jpg');%0.2
pic = imread('D:\Miku\MikuPic\033_9b12f8dec2546b7a95ee3729.jpg');%0.2
%pic = imread('D:\Miku\MikuPic\5th\miku8ani.jpg');%0.1
%pic = imread('D:\Miku\MikuPic\5th\e4e107f431adcbefb5f73a29adaf2edda2cc9fa5.jpg');%0.2
%pic = imread('D:\Miku\MikuPic\Collection2\bba1cd11728b4710aece7874c3cec3fdfd0323a0.jpg');%0.3
%pic = imread('D:\Miku\MikuPic\Collection2\fd54743e6709c93dd84ae37b9f3df8dcd0005441.jpg');%0.2
%pic = imread('D:\Miku\MikuPic\Collection2\Hello.Planet.full.998288.jpg');%0.1
%pic = imread('D:\Miku\MikuPic\Miku\857638fa828ba61e24071a314134970a314e5982.jpg');%0.1 ÓÐ¸ÉÈÅ

pic = imresize(pic,0.2);

[width,height,~] = size(pic);

scaleMin = 30;
scaleMax = 80;
scaleStep = 10;
moveStep = 8;

bestX = 0;
bestY = 0;
bestSi = 0;
bestP = 0;

bestBox = BuildBox(0,0,0);
nowBox = BuildBox(0,0,0);

imshow(pic);

for si = scaleMin:scaleStep:scaleMax
    for x = 1:moveStep:width-si
        for y = 1:moveStep:height-si
            %(x,y)      (x+w,y)
            %(x+w,y+h)  (x+w,y+h)
            
            r = pic(x:x+si,y:y+si,1);
            g = pic(x:x+si,y:y+si,2);
            b = pic(x:x+si,y:y+si,3);
            
            r = imresize(r,[input_width,input_height]);
            g = imresize(g,[input_width,input_height]);
            b = imresize(b,[input_width,input_height]);
            
            daso = im2double([r(:);g(:);b(:)]) / 255;  % column vector
            %SVM
            da = zeros(39,1);
            for j = 1:n
                da(j) = gaussianKernel(daso,labelData(j,:),sigma);
            end
            
            z2 = Theta1 * [1;da];
            a2 = sigmoid(z2);
            z3 = Theta2 * [1;a2];
            a3 = sigmoid(z3);
            p = a3(1);
            
            if p > bestP
                bestX = x;
                bestY = y;
                bestSi = si;
                bestP = p;
            end
            
            fprintf('nowP:%f   bestP:%f\n',p,bestP);
            
            
            %rgb
            drawPic = pic;
            drawPic(bestX:bestX + bestSi,bestY,1) = 255;
            drawPic(bestX + bestSi,bestY:bestY + bestSi,1) = 255;
            drawPic(bestX:bestX + bestSi,bestY + bestSi,1) = 255;
            drawPic(bestX,bestY:bestY + bestSi,1) = 255;
            
            drawPic(bestX:bestX + bestSi,bestY,2) = 0;
            drawPic(bestX + bestSi,bestY:bestY + bestSi,2) = 0;
            drawPic(bestX:bestX + bestSi,bestY + bestSi,2) = 0;
            drawPic(bestX,bestY:bestY + bestSi,2) = 0;
            
            drawPic(bestX:bestX + bestSi,bestY,3) = 0;
            drawPic(bestX + bestSi,bestY:bestY + bestSi,3) = 0;
            drawPic(bestX:bestX + bestSi,bestY + bestSi,3) = 0;
            drawPic(bestX,bestY:bestY + bestSi,3) = 0;
            
            
            
            drawPic(x:x + si,y,1) = 0;
            drawPic(x + si,y:y + si,1) = 0;
            drawPic(x:x + si,y + si,1) = 0;
            drawPic(x,y:y + si,1) = 0;
            
            drawPic(x:x + si,y,2) = 0;
            drawPic(x + si,y:y + si,2) = 0;
            drawPic(x:x + si,y + si,2) = 0;
            drawPic(x,y:y + si,2) = 0;
            
            drawPic(x:x + si,y,3) = 255;
            drawPic(x + si,y:y + si,3) = 255;
            drawPic(x:x + si,y + si,3) = 255;
            drawPic(x,y:y + si,3) = 255;
            
            hold on;
            imshow(drawPic);
            drawnow;
            hold off;
            
        end
    end
end