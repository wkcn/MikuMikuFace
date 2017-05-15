function [Theta1,Theta2] = Train(X,y,layer,iter_times,lambda)

input_layer_size = layer(1);
hidden_layer_size = layer(2);
num_labels = layer(3);

fprintf('\nTraining Neural Network... \n')
options = optimset('MaxIter', iter_times);

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

 % debug!!
initial_Theta1 = randInitializeWeights(hidden_layer_size,input_layer_size+1);
initial_Theta2 = randInitializeWeights(num_labels,hidden_layer_size+1);
% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)]; 
% debug OK!
                                   
% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

fprintf('Training Over. Cost:%f\n',cost);

end