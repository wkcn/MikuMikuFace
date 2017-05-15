input_width = 90;
input_height = 90;
color = 3;
input_layer_size  = input_width * input_height * color;  % Input Images of Digits
hidden_layer_size = 300;   % hidden units
num_labels = 2;          % labels
iter_times = 20;
lambda = 0;

X1 = LoadTraningSet('face\',input_width,input_height,color);%约束到1
m1 = size(X1,1);
y1 = ones(m1,1) * 1;
X2 = LoadTraningSet('bad\',input_width,input_height,color);
m2 = size(X2,2);
y2 = ones(m2,1) * 2;
%tr = 52;    %拿X的前个训练

X = [X1;X2];
y = [y1;y2];

m = size(X,1);

re = randperm(m);
X = X(re,:);
y = y(re,:);

%save 'trainingSet.mat' X y;

%load('trainingSet.mat');




[Theta1,Theta2] = Train(X,y,[input_layer_size,hidden_layer_size,num_labels],iter_times,lambda);


z2 = [ones(m,1) X] * Theta1';
a2 = sigmoid(z2);
z3 = [ones(m,1) a2] * Theta2';
a3 = sigmoid(z3);
[c,i] = max(a3,[],2);
k = sum(i == y);
p = k / m;
%fprintf('accurate:%f\n',p);
%i为预测值，y为实际值
tt = (y == 1);
ff = (y == 2);

tp = sum(i(tt) == 1);
fn = sum(i(tt) == 2);
fp = sum(i(ff) == 1);
tn = sum(i(ff) == 2);
P = tp / (tp + fp);
R = tp / (tp + fn);
F = 2 * P * R / (P + R);
fprintf('Precision: %f, Recall: %f, FScore: %f\n',P,R,F);



save 'Model.mat' Theta1 Theta2  input_width input_height color input_layer_size hidden_layer_size num_labels lambda;