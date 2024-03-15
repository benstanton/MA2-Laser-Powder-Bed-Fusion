

filename = "C:\Users\benst\Documents\Msc Modules\MA2 Laser Powder Bed Fusion\trainingResults.txt";



% initialise the random number generator seed for repeatable results
seed = 15;
rng(seed,'twister');

lines = ["New Test Set, seed = ", seed];   
writelines(lines,filename,WriteMode="append")


% load data
run("dataCleaning.m")
run("calc_DTNC.m")
run("calc_HatchLength.m")


%% DTNC + hatchLength features

% input-output data
X = [trainCubeCoordData(:, 2:4) DTNC_4 trainDataMatrix];  % inputs 
Y = categorical(trainClassificationTarget); % outputs - class labels of human activity converted to categorical data

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

    fullyConnectedLayer(256)         % FC layer
    batchNormalizationLayer         % Batch normalisation
    reluLayer                       % ReLU activation function
    dropoutLayer(0.5) 

    fullyConnectedLayer(num_classes) % Fully connected layer
    softmaxLayer                    % softmax output
    classificationLayer]; 

% training options - note the L2Regularization option
options = trainingOptions("adam", ...
    "MiniBatchSize",512, ...
    "MaxEpochs",64, ...
    "InitialLearnRate",1e-3, ...
    "L2Regularization",0.0001, ...
    "ValidationData",{X_val,Y_val}, ...
    "Plots","training-progress", ...
    "ExecutionEnvironment","cpu");
    

%train network
net = trainNetwork(X_train,Y_train,layers,options);

summary(net)

% evaluate model on test data

% classify the validation output using the trained network
[YPred,~] = classify(net,X_val);
accuracy = 100*mean(YPred == Y_val); % accuracy
text = ["with DTNC5 + hatchLength: " num2str(accuracy) "%"];
disp(text);
writelines(text,filename,WriteMode="append")

figure;
plotconfusion(Y_val,YPred)



