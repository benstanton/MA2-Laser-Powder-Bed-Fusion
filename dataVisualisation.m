%% 3d scatter plot of porisites
load('itpAmCaseStudyData5.mat')
close all

numPorosities = sum(trainClassificationTarget(:) == 1);
numNotPorosities = sum(trainClassificationTarget(:) == 0);

porosityCoords = zeros(numPorosities, 3);
nonPorosityCoords = zeros(numNotPorosities, 3);

pCount = 1;
nCount = 1;

for i = 1:length(trainClassificationTarget)
    if (trainClassificationTarget(i))
        porosityCoords(pCount, :) = [trainCubeCoordData(i, 2), trainCubeCoordData(i, 3), trainCubeCoordData(i, 4)];
        pCount = pCount + 1;
    else
        nonPorosityCoords(nCount, :) = [trainCubeCoordData(i, 2), trainCubeCoordData(i, 3), trainCubeCoordData(i, 4)];
        nCount = nCount + 1;
    end
end

scatter3(porosityCoords(:, 1), porosityCoords(:, 2), porosityCoords(:, 3), '*')
hold on
scatter3(nonPorosityCoords(:, 1), nonPorosityCoords(:, 2), nonPorosityCoords(:, 3), '.')
title('Porosities')
xlabel('x')
ylabel('y')
zlabel('z')

legend("Porosities", "Non Porsities")
% figure
% 
% title('Non Porosities')
% xlabel('x')
% ylabel('y')
% zlabel('z')