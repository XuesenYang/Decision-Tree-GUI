function [outcomegroups, numberofgroups] = CalculateOutcomeGroups (y)


sortedoutcome = sortrows (y);
outcome = unique (sortedoutcome);

%The length of outcome array correspond to the number of group.
numberofgroups = length (outcome);

%Count for earch group the number of cases.
for index = 1:1:numberofgroups
    %voidgroup contains each row contain that group
    voidgroup = find (sortedoutcome == outcome(index));
    outcomegroups(1, index) = outcome(index);
    %The number of cases is the number of rows
    outcomegroups(2, index) = length(voidgroup);
end 
    

%Display results

fprintf ('Outcomes groups and cases:\n');
for index = 1:numberofgroups
    fprintf ('\nGroup number : %d\t\t cases = %d', outcomegroups (1,index), outcomegroups (2,index));
end
fprintf('\n');


end