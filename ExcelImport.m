function [X, y, textdata] = ExcelImport (filename)
%% Excel Import Function written by Andrea Padoan
% USAGE: [X, y, textdata] = ExcelImport (filename)
fprintf ('\n------ Performing requested action. Import from excel file. ------\n');
[typ, desc] = xlsfinfo(filename);
fprintf ('\nOpening: %s \t\tWorkSheet: %s\n', filename, char(desc(1)));
[data,textdata]=xlsread (filename, 1);

fprintf ('Fill variables X and y to workspace .... \n\n');
%Recupera le covariate
X = data(:,2:end);
%Recupera l'outcome
y = data(:,1);

end