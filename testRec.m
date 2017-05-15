pkg load image;
%picSource = imread('D:\Miku\MikuPic\025_eb08146f10263af180cb4a89.jpg');%0.3
%picSource = imread('D:\Miku\MikuPic\120_http__imgloadCA00W52D.jpg');%0.2
%picSource = imread('D:\Miku\MikuPic\033_9b12f8dec2546b7a95ee3729.jpg');%0.2
%picSource = imread('D:\Miku\MikuPic\5th\miku8ani.jpg');%0.1
%picSource = imread('D:\Miku\MikuPic\5th\e4e107f431adcbefb5f73a29adaf2edda2cc9fa5.jpg');%0.2no
%picSource = imread('D:\Miku\MikuPic\Collection2\bba1cd11728b4710aece7874c3cec3fdfd0323a0.jpg');%0.3
%picSource = imread('D:\Miku\MikuPic\Collection2\fd54743e6709c93dd84ae37b9f3df8dcd0005441.jpg');%0.2
%picSource = imread('D:\Miku\MikuPic\Collection2\Hello.Planet.full.998288.jpg');%0.1
%picSource = imread('D:\Miku\MikuPic\Miku\857638fa828ba61e24071a314134970a314e5982.jpg');%0.1 有干扰
%picSource = imread('D:\Miku\MikuPic\Collection2\Project DIVAss.png');%0.4
%picSource = imread('D:\Miku\MikuPic\172_50b59d52c75bf1230cf3e38d.jpg');%0.3
%picSource = imread('D:\Miku\MikuPic\Miku\5961444a20a44623a0b4c2029a22720e0cf3d713.jpg');
%d713 Model
%D:\Miku\MikuPic\PDF2ND\PDF2ND\42973596.jpg
%D:\Miku\MikuPic\Miku\5961444a20a44623a0b4c2029a22720e0cf3d713.jpg
%D:\Miku\MikuPic\PDF2ND\PDF2ND\43828787.jpg
%9411
%D:\Miku\MikuPic\Collection2\Hello.Planet.full.998288.jpg
load('Model.mat');

%filename = 'D:\Miku\MikuPic\PDF2ND\PDF2ND\42973596.jpg';
%filename = 'D:\Miku\MikuPic\Miku\5961444a20a44623a0b4c2029a22720e0cf3d713.jpg'
%filename = 'D:\Miku\MikuPic\PDF2ND\PDF2ND\43828787.jpg' 
filename = '~/wkcn/Miku/MikuPic/PDF2ND/PDF2ND/43828787.jpg'
%filename = 'D:\Miku\MikuPic\5th\miku8ani.jpg' 
%以下的可以展示干扰修正
%filename = 'D:\Miku\MikuPic\Miku\857638fa828ba61e24071a314134970a314e5982.jpg'

picSource = imread(filename);
sc = 480 / size(picSource,1);
picSource = imresize(picSource,sc);
sc = 640 / size(picSource,2);
picSource = imresize(picSource,sc);


%scale = 0.3;
line = 1;
si = size(picSource);
scale = 200 / si(1);
pic = imresize(picSource,scale);
%gray = rgb2gray(pic);


nn_params = [Theta1(:);Theta2(:)];

[height,width,~] = size(pic);

scaleMin = 30;
scaleMax = 80;
scaleStep = 10;
moveStep = 8;

bestX = 0;
bestY = 0;
bestSi = 0;
bestP = 0;

%bestBox = BuildBox(0,0,0);
%nowBox = BuildBox(0,0,0);

imshow(pic);

for si = scaleMin:scaleStep:scaleMax
    for y = 1:moveStep:height-si
        for x = 1:moveStep:width-si
            %(x,y)      (x+w,y)
            %(x+w,y+h)  (x+w,y+h)
            
            r = pic(y:y+si,x:x+si,1);
            g = pic(y:y+si,x:x+si,2);
            b = pic(y:y+si,x:x+si,3);
            
            r = imresize(r,[input_width,input_height]);
            g = imresize(g,[input_width,input_height]);
            b = imresize(b,[input_width,input_height]);
            
            da = im2double([r(:);g(:);b(:)]) / 255;  % column vector
            
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
            board = DrawBox(picSource,x/scale,y/scale,si/scale,line,[0,0,255]);
            board = DrawBox(board,bestX/scale,bestY/scale,bestSi/scale,line,[255,0,0]);
            %hold on;
            imshow(board);
            drawnow;
            %hold off;
            
        end
    end
    
    %Over
    board = DrawBox(picSource,bestX/scale,bestY/scale,bestSi/scale,line,[255,0,0]);
    imshow(board);
    drawnow;
    
end
