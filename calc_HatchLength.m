

hatchLength = zeros(length(trainCubeCoordData), 1);


for i = 1:length(trainCubeCoordData(:, 1))
    hatchLength(i, :) = calcHatchLength(trainCubeCoordData(i, 2), trainCubeCoordData(i, 3), trainCubeCoordData(i, 4), i);
end

function hatchLength = calcHatchLength(x, y, z, index)
    hatchLength = 0;

    z_adj = floor(z./0.05).*0.05 ; % rounds down to nearest 0.05
    layer = (z_adj/0.05) + 1;
    
    if (z <= 7) %big cube
        theta = 31.4038;
        
        if (cast(mod(layer, 2), "logical") == 0) %iseven (positive angle)
            if (y > 1.6380*x)
                hatchLength = (x/(cosd(90-theta))) + ((10-y)/(cosd(theta)));
            elseif (y < 1.6380*x - 6.3802)
                hatchLength = (y/cosd(theta)) + ((10-x)/(cosd(90-theta))); 
            else
                hatchLength = (y/cosd(theta)) + ((10-y)/(cosd(theta)));
            end

        elseif(cast(mod(layer, 2), "logical") == 1) %isodd (negative angle)
            if (y < -1.6380*x + 10)         
                hatchLength = (y/cosd(theta)) + (x/(cosd(90-theta)));
            elseif (y > -1.6380*x + 16.380)              
                hatchLength = ((10-x)/cosd(90-theta)) + ((10-y)/(cosd(theta)));
            else
                hatchLength = (y/cosd(theta)) + ((10-y)/cosd(theta));
            end

        else
            fprintf("ERROR1: %d\n", index);
        end

    else % small cube (impose bottom right/topright cubes onto bottom left cube)
        theta = 16.077;
        if (x <= 2.01 && y <= 2.01 ) %bottom left cube
            % do nothing
        elseif (x >= 7.99 && y <= 2.01 ) % bottom right cube
            x = max(x - 8, 0);        
        elseif (x >= 7.99 && y >= 7.99) % top right cube
            x = max(x - 8, 0);
            y = max(y-8, 0);

        else
            fprintf("ERROR2: %d\n", index) % catch edge cases
        end


        if (cast(mod(layer, 2), "logical") == 0) %iseven (positive angle)

            if (y > 3.4698*x)
                hatchLength = (x/(cosd(90-theta))) + ((2-y)/(cosd(theta)));
            elseif (y < 3.4698*x - 4.9396)
                hatchLength = (y/cosd(theta)) + ((2-x)/(cosd(90-theta))); 
            else
                hatchLength = (y/cosd(theta)) + ((2-y)/(cosd(theta)));
            end
           

        elseif(cast(mod(layer, 2), "logical") == 1) %isodd (negative angle)
            if (y < -3.4698*x + 2)         
                hatchLength = (y/cosd(theta)) + (x/(cosd(90-theta)));
            elseif (y > -3.4698*x + 6.9396)              
                hatchLength = ((2-x)/cosd(90-theta)) + ((2-y)/(cosd(theta)));
            else
                hatchLength = (y/cosd(theta)) + ((2-y)/cosd(theta));
            end

        else % catch errors
            fprintf("ERROR3: %d\n", index)
        end
    end

    if (hatchLength == 0)
        fprintf("WARN1: %d\n", index)
    end
    if (hatchLength < 0)
        fprintf("ERROR4: %d\n", index)
    end

end