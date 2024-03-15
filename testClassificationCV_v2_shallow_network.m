% testClassificationV2 doesn't separate the inner k-fold data further into
% testing/validation sets - all k-1 folds are used as training data, and
% validation is only done at the end using the left out fold.

clear

% close everything including training windows
%delete(findall(0));

filename = "C:\Users\benst\Documents\Msc Modules\MA2 Laser Powder Bed Fusion\trainingResultsCV_shallow.txt";

seed = 16;
rng(seed,'twister');

lines = join(["New Test Set, seed = ", seed]);   
writelines(lines,filename,WriteMode="append")

% load data
run("dataCleaning.m")
run("calc_DTNC.m")
run("calc_HatchLength.m")

%% DTNC_5 + hatchLength features

% shuffle data
% 1-3 coord
% 4-8 DNTC5
% 9 HL
% 10-27 input data 
dataWholeUnshuffled = [trainCubeCoordData(:, 2:4) DTNC_5 hatchLength trainDataMatrix trainClassificationTarget];

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
cvMCR_DNTC5_HL = crossval('mcr',X, Y,'Predfun',@neuralNetworkPrediction,'kFold',5, 'Stratify', Y);

% calculate accuracy from misclassification rate
cvAcc_DNTC5_HL = 1-cvMCR_DNTC5_HL;

%print acc to text file
text = join(["5-Fold CV with DTNC5 + hatchLength: " num2str(cvAcc_DNTC5_HL)]);
    disp(text);
    writelines(text,filename,WriteMode="append")

%% DNTC_4 + hatchlength

data_DNTC4_HL = X;
data_DNTC4_HL(:, 8) = []; % delete DNTC 5 value

cvMCR_DNTC4_HL = crossval('mcr',data_DNTC4_HL, Y,'Predfun',@neuralNetworkPrediction,'kFold',5, 'Stratify', Y);

% calculate accuracy from misclassification rate
cvAcc_DNTC4_HL = 1-cvMCR_DNTC4_HL;

%print acc to text file
text = join(["5-Fold CV with DTNC4 + hatchLength: " num2str(cvAcc_DNTC4_HL)]);
    disp(text);
    writelines(text,filename,WriteMode="append")

%% No DNTC + hatchlength

data_NoDNTC_HL = X;
data_NoDNTC_HL(:, 4:8) = []; % delete DNTC values

cvMCR_NoDNTC_HL = crossval('mcr',data_NoDNTC_HL, Y,'Predfun',@neuralNetworkPrediction,'kFold',5, 'Stratify', Y);

% calculate accuracy from misclassification rate
cvAcc_NoDNTC_HL = 1-cvMCR_NoDNTC_HL;

%print acc to text file
text = join(["5-Fold CV with No DTNC + hatchLength: " num2str(cvAcc_NoDNTC_HL)]);
    disp(text);
    writelines(text,filename,WriteMode="append")

%% DNTC_5 + No hatchlength

data_DNTC5_NoHL = X;
data_DNTC5_NoHL(:, 9) = []; % delete HL values

cvMCR_DNTC5_NoHL = crossval('mcr',data_DNTC5_NoHL, Y,'Predfun',@neuralNetworkPrediction,'kFold',5, 'Stratify', Y);

% calculate accuracy from misclassification rate
cvAcc_DNTC5_NoHL = 1-cvMCR_DNTC5_NoHL;

%print acc to text file
text = join(["5-Fold CV with DTNC5 + No hatchLength: " num2str(cvAcc_DNTC5_NoHL)]);
    disp(text);
    writelines(text,filename,WriteMode="append")

%% DNTC_4 + No hatchlength

data_DNTC4_NoHL = X;
data_DNTC4_NoHL(:, 9) = []; % delete HL values
data_DNTC4_NoHL(:, 8) = []; % delete DNTC5 values


cvMCR_DNTC4_NoHL = crossval('mcr',data_DNTC4_NoHL, Y,'Predfun',@neuralNetworkPrediction,'kFold',5, 'Stratify', Y);

% calculate accuracy from misclassification rate
cvAcc_DNTC4_NoHL = 1-cvMCR_DNTC4_NoHL;

%print acc to text file
text = join(["5-Fold CV with DTNC4 + No hatchLength: " num2str(cvAcc_DNTC4_NoHL)]);
    disp(text);
    writelines(text,filename,WriteMode="append")

%% No DNTC_4 + No hatchlength

data_NoDNTC4_NoHL = X;
data_NoDNTC4_NoHL(:, 9) = []; % delete HL values
data_NoDNTC4_NoHL(:, 4:8) = []; % delete DNTC values

cvMCR_NoDNTC_NoHL = crossval('mcr',data_NoDNTC4_NoHL, Y,'Predfun',@neuralNetworkPrediction,'KFold',5, 'Stratify', Y);

% calculate accuracy from misclassification rate
cvAcc_NoDNTC_NoHL = 1-cvMCR_NoDNTC_NoHL;

%print acc to text file
text = join(["5-Fold CV with No DTNC + No hatchLength: " num2str(cvAcc_NoDNTC_NoHL)]);
    disp(text);
    writelines(text,filename,WriteMode="append")


% function that creates and fits neural network
function yfit = neuralNetworkPrediction(X_train,Y_train,X_test)

    X_train_scaled = normalize(X_train,1); % standardize data 
    X_test_scaled = normalize(X_test,1);

    num_features = size(X_train,2);        % number of features
    num_classes = length(unique(Y_train));        % number of classes

     % design network 
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
        "ExecutionEnvironment","cpu");


    net = trainNetwork(X_train_scaled,Y_train,layers,options);
    [yfit,~] = classify(net,X_test_scaled);
   

end


