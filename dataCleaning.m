%% data cleaning

% consider removing cube number?
load('itpAmCaseStudyData5.mat')

% delete row 248 (z level >7)

% trainCubeCoordData(248, :) = [];
% trainClassificationTarget(248, :) = [];
% trainDataMatrix(248, :) = [];
% trainRegressionTarget(248, :) = [];

% cap z level to 7
trainCubeCoordData(248, 4) = 7;




% delete row 91 [m, i] = min(trainDataMatrix(:,5))

% row = 91;
%     trainCubeCoordData(row, :) = [];
%     trainClassificationTarget(row, :) = [];
%     trainDataMatrix(row, :) = [];
%     trainRegressionTarget(row, :) = [];

 