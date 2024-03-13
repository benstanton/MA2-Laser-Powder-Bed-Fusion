%% data cleaning
load('itpAmCaseStudyData5.mat')

% delete row 248 (z level >7)

trainCubeCoordData(248, :) = [];
trainClassificationTarget(248, :) = [];
trainDataMatrix(248, :) = [];
trainRegressionTarget(248, :) = [];
