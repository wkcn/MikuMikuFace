function [J,grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% X m x 400
% Theta1 25 x 401
% Theta2 10 x 26
Xo = [ones(m,1) X];%m x 401

z2 = Xo * Theta1';	% m x 25

a2 = sigmoid(z2);
a2o = [ones(m,1) a2];% m x 26
z3 = a2o * Theta2';	% m x 10
a3 = sigmoid(z3);

ty = repmat(1:num_labels,[m,1]) == repmat(y,[1,num_labels]);

reg = lambda / (2 * m) * (sum(sum(Theta1(:,2:end) .^ 2)) + sum(sum(Theta2(:,2:end) .^ 2)));
J = 1 / m * sum(sum(-ty .* log(a3) - (1 - ty) .* log(1 - a3))) + reg;

%find Theta1_grad and Theta2_grad
%     25 x 401    and 10 x 26

error3 = a3 - ty; % m x 10
c2 = error3 * Theta2(:,2:end); % m x 25
error2 = c2 .* sigmoidGradient(z2); % m x 25

%注意，这里不是矩阵相乘就能解决的，样本标签要对应
D1 = zeros(hidden_layer_size,input_layer_size + 1);
D2 = zeros(num_labels,hidden_layer_size + 1);

%�?��带偏差项
for i = 1:m
	D2 = D2 + error3(i,:)' * a2o(i,:);
	D1 = D1 + error2(i,:)' * Xo(i,:);
end

l1 = Theta1;
l2 = Theta2;
l1(:,1) = zeros(size(l1,1),1);
l2(:,1) = zeros(size(l2,1),1);

Theta1_grad = 1/m * D1 + lambda / m * l1;	% 25 x 400
Theta2_grad = 1/m * D2 + lambda / m * l2;	% 10 x 25













% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
