%%% Distance to nearest contour 

% TODO
% include vertical face
% 1 feature distance to nearest face? 
% compress 4 features to 2?
% 

load('itpAmCaseStudyData5.mat')


DTNC_4 = zeros(4733, 4);

for i = 1:length(trainCubeCoordData(:, 1))
    DTNC_4(i, :) = calc_DTNC_4(trainCubeCoordData(i, 2), trainCubeCoordData(i, 3), trainCubeCoordData(i, 4));
end


function [border1, border2, border3, border4] = calc_DTNC_4(x, y, z)

    if (z <= 7.01) %big cube
        border1 = y;
        border2 = 10-x;
        border3 = 10-y;
        border4 = x;
    elseif (x<= 2 && y <= 2) % small cube 1-4
        border1 = y;
        border2 = 2-x;
        border3 = 2-y;
        border4 = x;
    elseif (x >= 8 && y <= 2) % small cube 1-2
        border1 = y;
        border2 = 10-x;
        border3 = 2-y;
        border4 = x-8;
    elseif (x >= 8 && y >= 8) % small cube 2-3
        border1 = y-8;
        border2 = 10-x;
        border3 = 10-y;
        border4 = x-8;
    end
           
end

