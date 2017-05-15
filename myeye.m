res = [0.999999999;0.000000001];
a3 = res;
z3 = -log(1 ./ a3 - 1);
p2 = pinv(Theta2);
a2 = p2 * z3;
a2 = a2(2:end);
z2 = -log(1 ./ a2 - 1);
p1 = pinv(Theta1);
a1 = p1 * z2;
x = a1(2:end);%column vector
x = uint8(x * 255);

si = input_width * input_height;
%pic = zeros(input_width,input_height,3);
pic = reshape(x,[input_width,input_height,3]);
imshow(pic);