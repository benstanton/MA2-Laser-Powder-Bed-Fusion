num_features = size(X_scaled,2);        % number of features
num_classes = length(unique(Y));        % number of classes

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

  lgraph = layerGraph(layers);

analyzeNetwork(lgraph)

figure
plot(lgraph);

title("Preliminary Neural Network with 4 hidden layers")