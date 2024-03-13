%%% Distance to nearest contour 

% TODO
% include vertical face
% 1 feature distance to nearest face? 
% compress 4 features to 2?
% 

%load('itpAmCaseStudyData5.mat')


DTNC_4 = zeros(4733, 4);
DTNC_5 = zeros(4733, 5);

for i = 1:length(trainCubeCoordData(:, 1))
    DTNC_4(i, :) = calc_DTNC_4(trainCubeCoordData(i, 2), trainCubeCoordData(i, 3), trainCubeCoordData(i, 4));
    DTNC_5(i, :) = calc_DTNC_5(trainCubeCoordData(i, 2), trainCubeCoordData(i, 3), trainCubeCoordData(i, 4), i);
end

[M, I] = min(DTNC_5(:, 5))
[M, I] = min(DTNC_5(:, 4))
[M, I] = min(DTNC_5(:, 3))
[M, I] = min(DTNC_5(:, 2))
[M, I] = min(DTNC_5(:, 1))

function borders = calc_DTNC_5(x, y, z, i)

    if (z <= 7) %big cube
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

    if ((x<= 2 && y <= 2) || (x >= 8 && y <= 2) || (x >= 8 && y >= 8)) % small cube XY
        border5 = 9-z;

    else
        border5 = 7-z;
    end

    if (border5 < 0)

        fprintf("ERROR1: %d", i)
    end

    borders = [border1, border2, border3, border4, border5];
end



function borders = calc_DTNC_4(x, y, z)

    if (z <= 7) %big cube
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
    
    borders = [border1, border2, border3, border4];
end

