clear

% close everything including training windows
delete(findall(0));

filename = "C:\Users\benst\Documents\Msc Modules\MA2 Laser Powder Bed Fusion\trainingResults.txt";

seed = 15;
rng(seed,'twister');

lines = join(["New Test Set, seed = ", seed]);   
writelines(lines,filename,WriteMode="append")

% load data
run("dataCleaning.m")
run("calc_DTNC.m")
run("calc_HatchLength.m")

%% DTNC + hatchLength features

% shuffle data
dataWholeUnshuffled = [trainCubeCoordData(:, 2:4) DTNC_4 hatchLength trainDataMatrix trainClassificationTarget];

% Determine the number of rows in the matrix
n = size(dataWholeUnshuffled, 1);	% dim = 1 to specify rows
% Generate a random permutation of indices of rows of the matrix
R = randperm(n);
% Shuffle the rows of the matrix using random permutation
dataWholeShuffled = dataWholeUnshuffled(R, :);


X = [dataWholeShuffled(:, 1:(end-1))];  % inputs 
Y = categorical(dataWholeShuffled(:, end)); % outputs - class labels of human activity converted to categorical data

% pre-process data
X_scaled = normalize(X,1); % standardize data 

% perform CV 
cvMCR = crossval('mcr',X_scaled, Y,'Predfun',@neuralNetworkPrediction,'KFold',3, 'Stratify', Y);

% calculate accuracy from misclassification rate
cvAcc = 1-cvMCR;


%print acc to text file
text = ["CV with DTNC4 + hatchLength: " num2str(cvAcc)];
    disp(text);
    writelines(text,filename,WriteMode="append")

% function that creates and fits neural network
function yfit = neuralNetworkPrediction(X_train_unsplit,Y_train_unsplit,X_test)

    num_features = size(X_train_unsplit,2);        % number of features
    num_classes = length(unique(Y_train_unsplit));        % number of classes

    m = size(X_train_unsplit,1);                   % number of data samples
    %create randomised training and validation data
    r = randperm(m);                 % set of m random indices from 1 to m
    trainSplitIndex = cast(m/2, "int32");

    X_train = X_train_unsplit(r(1:trainSplitIndex),:);  % training input data
    X_val = X_train_unsplit(r(trainSplitIndex+1:m),:);  % validation input data
    Y_train = Y_train_unsplit(r(1:(trainSplitIndex)),:);         % training output data
    Y_val = Y_train_unsplit(r(trainSplitIndex+1:m),:);         % validation output data
    
     % design network - note the dropout layer at the end
    layers = [
        featureInputLayer(num_features) % input layer
    
        fullyConnectedLayer(256)         % FC layer
        batchNormalizationLayer         % Batch normalisation
        reluLayer                       % ReLU activation function
        dropoutLayer(0.5) 
    
        fullyConnectedLayer(128)          % FC layer
        batchNormalizationLayer         % Batch normalisation
        reluLayer                       % ReLU activation function
        dropoutLayer(0.5) 
    
        fullyConnectedLayer(128)          % FC layer
        batchNormalizationLayer         % Batch normalisation
        reluLayer                       % ReLU activation function
        dropoutLayer(0.5) 
    
        fullyConnectedLayer(64)          % FC layer
        batchNormalizationLayer         % Batch normalisation
        reluLayer                       % ReLU activation function      
        dropoutLayer(0.5)               % Dropout layer - prob=0.2
        
        fullyConnectedLayer(num_classes) % Fully connected layer
        softmaxLayer                    % softmax output
        classificationLayer]; 
    
    % training options - note the L2Regularization option
    options = trainingOptions("adam", ...
        "MiniBatchSize",128, ...
        "MaxEpochs",128, ...
        "InitialLearnRate",1e-3, ...
        "L2Regularization",0.0001, ...
        "ValidationData",{X_val,Y_val}, ...
        "Plots","training-progress", ...
        "ExecutionEnvironment","cpu");


    net = trainNetwork(X_train,Y_train,layers,options);
    [yfit,~] = classify(net,X_test);
   

end


