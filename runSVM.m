%Use SVM
input_width = 180;
input_height = 180;
color = 3;
input_layer_size  = 39;%input_width * input_height * color;  % Input Images of Digits
hidden_layer_size = 500;   % hidden units
num_labels = 2;          % labels
iter_times = 200;
lambda = 0;
n = 39; %特征数,不包括偏差项

m1 = 39;
X1 = LoadTraningSet('face\',m1,input_width,input_height,color);%约束到1
y1 = ones(m1,1) * 1;
m2 = 12;
X2 = LoadTraningSet('bad\',m2,input_width,input_height,color);
y2 = ones(m2,1) * 2;
tr = 51;    %拿X的前个训练

labelData = X1;
sigma = 0.01;
m = m1 + m2;


Xso = [X1;X2];
X = zeros(m,39);
for i = 1:m
    for j = 1:n
        X(i,j) = gaussianKernel(Xso(i,:),labelData(j,:),sigma);
    end
end
y = [y1;y2];

m = size(X,1);

re = randperm(m);
X = X(re,:);
y = y(re,:);

%save 'trainingSet.mat' X y;

%load('trainingSet.mat');




[Theta1,Theta2] = Train(X(1:tr,:),y(1:tr),[input_layer_size,hidden_layer_size,num_labels],iter_times,lambda);

u = 51;


z2 = [ones(m,1) X] * Theta1';
a2 = sigmoid(z2);
z3 = [ones(m,1) a2] * Theta2';
a3 = sigmoid(z3);
[c,i] = max(a3,[],2);
k = sum(i == y);
p = k / u;
fprintf('accurate:%f\n',p);


save 'ModelSVM.mat' Theta1 Theta2 labelData sigma input_width input_height color input_layer_size hidden_layer_size num_labels lambda ;