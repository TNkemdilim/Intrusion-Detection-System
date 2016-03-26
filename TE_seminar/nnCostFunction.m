function [J grad] = nnCostFunction(nn_params, ...
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
D2=zeros(size(Theta2));
D1=zeros(size(Theta1));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
%disp((y));
disp(size(y));
a1=X;
a1=[ones(m,1) a1];
z2=a1*Theta1';
a2=sigmoid(z2);
a2=[ones(size(a2,1),1) a2];
z3=a2*Theta2';
a3=sigmoid(z3);
h=a3;
h=h';
disp(size(h));


yMatrix = zeros(num_labels, m);

for i=1:num_labels,
    yMatrix(i,:) = (y==i);
end

Theta1R=Theta1(:,2:end);
Theta2R=Theta2(:,2:end);

J = (sum( sum( -1*yMatrix.*log(h) - (1 - yMatrix).*log(1-h) ) ))/m;

reg=lambda*(sum(sum(Theta1R.^2))+sum(sum(Theta2R.^2)))/(2*m);

J=J+reg;
% Part 2: Implement the backpropagation algdorithm to compute the gradients
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
X = [ones(m,1) X];
for t=1:m
    a1=X(t,:);
    z2=Theta1*a1';
   
    a2=sigmoid(z2);
    a2=[1; a2];
    z3=Theta2*a2;
    a3=sigmoid(z3);
    d3=a3-yMatrix(:,t);

    z2 = [1 ; z2];
    d2=(Theta2'*d3).*sigmoidGradient(z2);
    
    d2=d2(2:end);
    
    D2=D2+d3*a2';
   % fprintf "size";
    %disp(size(d2))
   % disp(size(a1));
    %pause;
    D1=D1+d2*a1;
    
    
end
Theta1_grad(:,1)=D1(:,1)/m;
Theta2_grad(:,1)=D2(:,1)/m;

Theta1_grad(:,2:end)=(D1(:,2:end)/m)+(lambda*Theta1(:,2:end)/m);

Theta2_grad(:,2:end)=(D2(:,2:end)/m)+(lambda*Theta2(:,2:end)/m);

%Theta1_grad = D1/m;
%Theta2_grad =   D2/m;

% Part 3: Implement regularization with the cost function and
% gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%



% -----------------------------------------------
% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
