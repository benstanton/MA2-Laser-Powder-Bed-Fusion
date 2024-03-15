    
% calc SED in mm^3
SED_mm = ((6.*trainRegressionTarget)./pi).^(1/3);

% convert to micrometers ^3 
SED = SED_mm.*1000;

% calculate unique values
[C,~,ic] = unique(SED);
a_counts = accumarray(ic,1);
value_counts_unbinned = [C, a_counts];

binnedSED_3 = zeros(4733, 3);
binnedSED_4 = zeros(4733, 4);

for i1 = 1:length(SED)
    if (SED(i1) == 0)
        binnedSED_3(i1, 1) = 1;
        binnedSED_4(i1, 1) = 1;
    elseif (SED(i1) <= 50)
        binnedSED_3(i1, 1) = 1;
        binnedSED_4(i1, 2) = 1;
    elseif (SED(i1) <= 100)
        binnedSED_3(i1, 2) = 1; 
        binnedSED_4(i1, 3) = 1;
    else
        binnedSED_3(i1, 3) = 1; 
        binnedSED_4(i1, 4) = 1;
    end
end

% calculate unique values of binned_3
sum_binned_3 = sum(binnedSED_3);

% calculate unique values of binned_4
sum_binned_4 = sum(binnedSED_4);

