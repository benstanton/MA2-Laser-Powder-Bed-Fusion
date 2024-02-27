%clear all
%% no new features
% initialise the random number generator seed for repeatable results
rng(1,'twister');

% load data
load itpAmCaseStudyData5.mat

% input-output data
X = [trainCubeCoordData(:, 2:4) trainDataMatrix];  % inputs 
Y = categorical(trainClassificationTarget); % outputs - class labels of human activity converted to categorical data


X(end, :) = [];
Y(end, :) = [];

% pre-process data
X_scaled = normalize(X,1);              % standardize data 
num_features = size(X_scaled,2);        % number of features
num_classes = length(unique(Y));        % number of classes
m = size(X_scaled,1);                   % number of data samples

% create randomised training and validation data
r = randperm(m);                 % set of m random indices from 1 to m
X_train = X_scaled(r(1:m/2),:);  % training input data
X_val = X_scaled(r(m/2+1:m),:);  % validation input data
Y_train = Y(r(1:m/2),:);         % training output data
Y_val = Y(r(m/2+1:m),:);         % validation output data

% design network - note the dropout layer at the end
layers = [
    featureInputLayer(num_features) % input layer

    fullyConnectedLayer(12)         % FC layer
    batchNormalizationLayer         % Batch normalisation
    reluLayer                       % ReLU activation function

    fullyConnectedLayer(8)          % FC layer
    batchNormalizationLayer         % Batch normalisation
    reluLayer                       % ReLU activation function

    dropoutLayer(0.2)               % Dropout layer - prob=0.2
    fullyConnectedLayer(num_classes) % Fully connected layer
    softmaxLayer                    % softmax output
    classificationLayer]; 

% training options - note the L2Regularization option
options = trainingOptions("adam", ...
    "MiniBatchSize",32, ...
    "MaxEpochs",10, ...
    "InitialLearnRate",1e-3, ...
    "L2Regularization",0.0001, ...
    "ValidationData",{X_val,Y_val}, ...
    "Plots","training-progress");

% train network
net = trainNetwork(X_train,Y_train,layers,options);


% evaluate model on test data

% classify the validation output using the trained network
[YPred,probs] = classify(net,X_val);
accuracy = 100*mean(YPred == Y_val); % accuracy
disp(["without DTNC Validation Accuracy: " num2str(accuracy) "%"]);

figure;
plotconfusion(Y_val,YPred)

%% new features

% input-output data
X = [trainCubeCoordData(:, 2:4) DTNC_4 trainDataMatrix];  % inputs 
Y = categorical(trainClassificationTarget); % outputs - class labels of human activity converted to categorical data

X(end, :) = [];
Y(end, :) = [];

% pre-process data
X_scaled = normalize(X,1);              % standardize data 
num_features = size(X_scaled,2);        % number of features
num_classes = length(unique(Y));        % number of classes
m = size(X_scaled,1);                   % number of data samples

% create randomised training and validation data
r = randperm(m);                 % set of m random indices from 1 to m
X_train = X_scaled(r(1:m/2),:);  % training input data
X_val = X_scaled(r(m/2+1:m),:);  % validation input data
Y_train = Y(r(1:m/2),:);         % training output data
Y_val = Y(r(m/2+1:m),:);         % validation output data

% design network - note the dropout layer at the end
layers = [
    featureInputLayer(num_features) % input layer

    fullyConnectedLayer(12)         % FC layer
    batchNormalizationLayer         % Batch normalisation
    reluLayer                       % ReLU activation function

    fullyConnectedLayer(8)          % FC layer
    batchNormalizationLayer         % Batch normalisation
    reluLayer                       % ReLU activation function

    dropoutLayer(0.2)               % Dropout layer - prob=0.2
    fullyConnectedLayer(num_classes) % Fully connected layer
    softmaxLayer                    % softmax output
    classificationLayer]; 

% training options - note the L2Regularization option
options = trainingOptions("adam", ...
    "MiniBatchSize",32, ...
    "MaxEpochs",10, ...
    "InitialLearnRate",1e-3, ...
    "L2Regularization",0.0001, ...
    "ValidationData",{X_val,Y_val}, ...
    "Plots","training-progress");

% train network
net = trainNetwork(X_train,Y_train,layers,options);


% evaluate model on test data

% classify the validation output using the trained network
[YPred,probs] = classify(net,X_val);
accuracy = 100*mean(YPred == Y_val); % accuracy
disp(["with DTNC Validation Accuracy: " num2str(accuracy) "%"]);

figure;
plotconfusion(Y_val,YPred)
