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
title('3D Scatter Plot of Coordinate Data and Label')
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

figure
subplot(5, 1, 1)
plot(trainDataMatrix(:, 3))
%title('Sintering Duration Sum')
title('Sintering Duration Sum (\mus)')
xlim('tight')
%xlabel('Sample')
ylim([0 250])

subplot(5, 1, 2)
plot(trainDataMatrix(:, 5))
%title('Laser Power Mean')
title('L1 Laserview Laser Power Measurement Mean')
%xlabel('Sample')
xlim('tight')

subplot(5, 1, 3)
plot(trainDataMatrix(:, 7))
%title('Melt Pool Mean')
title('M2 MeltView Melt Pool Measurement Mean')
%xlabel('Sample')
xlim('tight')

subplot(5, 1, 4)
plot(trainDataMatrix(:, 14))
%title('Laser Speed Mean')
title('Laser Speed Mean (m/s)')
%xlabel('Sample')
xlim('tight')

subplot(5, 1, 5)
plot(trainDataMatrix(:, 16))
%title('Energy Density Mean')
title('Energy Density Mean')
xlabel('Sample')
xlim('tight')


figure
%histogram(trainDataMatrix)
T = 5;
b = 4;
loopVar = 1;
titles = ["Cube Num", "Border Label", "Sinter Dur Sum", "Sinter Dur Mean", ...
    "L1 Mean", "M1 Mean", "M2 Mean", "L1 Var", "M1 Var", "M2 Var", "L1 Skew", ...
    "M1 Skew", "M2 Skew", "Laser Spd", "Hatch Spacing", "Engy Dens Mean", ...
    "Laser Spd Var", "Hatch Spacing Var", "Engy Dens Var"];
for v_T = 1:T
   for v_b = 1:b

       if loopVar ~= 20
            subplot(T,b, loopVar)
           
            histogram (trainDataMatrix(:, loopVar))
            title(titles(loopVar))
            loopVar = loopVar + 1;
       end
   end
end


X_scaled = normalize(trainDataMatrix,1); % standardize data 

figure
%histogram(trainDataMatrix)
T = 5;
b = 4;
loopVar = 1;
titles = ["Cube Num", "Border Label", "Sinter Dur Sum", "Sinter Dur Mean", ...
    "L1 Mean", "M1 Mean", "M2 Mean", "L1 Var", "M1 Var", "M2 Var", "L1 Skew", ...
    "M1 Skew", "M2 Skew", "Laser Spd", "Hatch Spacing", "Engy Dens Mean", ...
    "Laser Spd Var", "Hatch Spacing Var", "Engy Dens Var"];
for v_T = 1:T
   for v_b = 1:b

       if loopVar ~= 20
            subplot(T,b, loopVar)
           
            histogram (X_scaled(:, loopVar))
            title(titles(loopVar))
            loopVar = loopVar + 1;
       end
   end
end
