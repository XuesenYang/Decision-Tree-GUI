function FeatureImportanceList = CalculateFeaturesImportance (t, textdata)
%% Function FeatureImportanceList = CalculateFeaturesImportance (t)
% Function invoked by Tree.m  
% Calculate the feature importance in percentage, sorting it. Give the text
% output.


%Feature importance in row
featureimp = varimportance(t);

%Transpose in column
featureimp = featureimp';

featurenumber = length (featureimp);

%Sposta tutto di una colonnna a dx

%Shift 1 position to dx
featureimp (:,2) = featureimp (:,1);

featureimp (1:end,1) = 1:featurenumber;

%Sorta le feature in base alla più alta alla più bassa

%Sort features from the major to the minor.
featureimp = -sortrows (-featureimp, 2);

%Calcola la percentuale.
%Calculate percentage
maximportance = featureimp (1, 2);

featureimp (:,2 ) = featureimp (:,2) / maximportance*100;

FeatureImportanceList = featureimp;

fprintf ('\n\n--- Features importance List ---\n');

for index = 1:featurenumber
    if (featureimp (index,2) ~= 0)
        fprintf ('Feature %s (n° %d) \t\tRelative Importance : %3.1f perc\n', char(textdata(featureimp(index,1)+1)), featureimp (index, 1), featureimp (index,2));
    end
end

fprintf ('\n');

end