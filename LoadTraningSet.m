function X = LoadTraningSet(name,width,height,color)
    files = dir(strcat(name,'*.jpg'));
    m = length(files);
    X = zeros(m,width * height * color);
    for i = 1:m
        filename = strcat(name,files(i).name);
        pic = imread(filename);
        small = imresize(pic,[width,height]);
        %gray = rgb2gray(pic);
        %small = imresize(gray,[width,height]);
        r = small(:,:,1);
        g = small(:,:,2);
        b = small(:,:,3);
        X(i,:) = im2double([r(:)' g(:)' b(:)'])  / 255.0;
    end
end