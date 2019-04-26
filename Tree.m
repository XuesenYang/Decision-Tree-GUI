function Tree (FileName)
% HELP of Classificatory Tree Algorithm.
%
% usage: Tree (filename). Ex: Tree ('database.xls').
%
% File type must be: 
%           excel (save in 97 compatibility mode)
%           csv 
%           mat (MatLab)
%
% 
% Classify a dataset with classification tree gini's method.
% 
% OUTPUT: 
%           Classificatory Tree (matlab view)
%           Features relative importance ratio list 
%           Classification Cost Graph and Best prune level
%           ROC curves with sensibility and sensitivity. 
%           AUC of the ROCs.
%
% Require:
%           A valid excel file or csv file. 
%           Check for different compatibility with excel file from Linux,
%           Os MAC X, Windows. Try to save with 95/97 compatibility.
%           This file must contain:
%           In the first row the variables names.
%           In the first column the outcome.
%           In the other columns the covariates.
%
% REMARKS:  Do not allow NaNs within features. MatLab algorithm doen't
% catch surrogate splits. NaNs may be a problem for the accuracy of
% classification and is a real problem for the ROC curves. In case with
% features with NaN the ROC may be miss the 100 % value, because NaN is
% outside classification.
% 
% How the program works:
% Table:
%
% leaf (n)      Pleaf(n)   %positive  %sumpositive %negatives %sumnegatives
%
% leaf (n) is the leaf's number.
% Pleaf(n) explanatory percentage of the leaf = within group subject 
%               classified in that leaf / total subject classified (of all groups)
%               classified in that leaf
%
% %positive = positive percentage target. Number of subject of that group
% classified in that leaf / total of subject of that group in the database.
%
% %summpositive =  percentage summ
%
% %negative = negative percentage target. total number of subject in the
% leaf that don't belong to that group / total number of database excluded
% subject that belong to that group
%
% %sumnegatives = percentage sum
%

% 
% Funzionamento del programma:
% Tabella
%
% leaf(n)       Pleaf(n)   %positivi %cumpos  %negativi  %cumneg
%
% leaf(n) = numero della foglia
% Pleaf(n) = percentuale di spiegazione della foglia = percentuale di
% classificati del gruppo in oggetto / totali della foglia inclusi tutti i
% gruppi
% %Positivi = % target di positivi = n? classificati del gruppo in oggetto
% in quella foglia / totale dei soggetti appartenenti al gruppo in oggetto
% nel database.
% %cumpos = cumulativo percentuale = somma cumulativa della % positivi
% %negativi = % target di negativi = n?totale di soggetti all'interno
% della foglia che non appartengono al gruppo in oggetto/totale dei
% soggetti nel database esclusi quelli che appartengono al gruppo in
% oggetto.
% %cumneg = cumulativo dei negativi.
% 
% ATTENZIONE: se i NaN sono nella variabile
%           selezionata dall'algoritmo come classificatore, la ROC
%           mancher? del punto 100% 100% perch? qualche caso ? uscito dalla
%           classficazione)
% 

%Display Title

fprintf('\nDecision Trees and Predictive Models with cross-validation and\n');
fprintf('ROC (Receiver Operating Characteristic) analysis plot\n');



%% Check for variable consistence

if (nargin ~= 1)
    display('This function need for input a filename (excel or csv file)');
    display('Please, see Help!');
    beep;

    return;
end

%% UNIX CHECK, Warning for Excel Import

if isunix
    fprintf ('\nRunning under UNIX ... Please check the MATLAB command for excel file import first!');
    fprintf ('\nType: [X, y, textdata] = ExcelImport (FileName) and check X, y, textdata\n\n');
end
%% Import excel of CSV File
% This cell import file from excel format or csv.


global X y textdata t;

%This is necessary because Unix can't load Excel server and give a warning
%message, also if the process goes ok.

warning off all

%Split complete filename in name + extensioni
[File, Extension] = strtok(FileName,'.');

if strcmp(Extension, '.csv') 
    fprintf('CSV file selected\n\n');
    [X, y, textdata] = ExcelImport (FileName);
elseif strcmp(Extension, '.xls') 
    fprintf('Excel File selected\n\n');
    [X, y, textdata] = ExcelImport (FileName);
elseif strcmp(Extension, '.mat')
    fprintf('Matlab File selected\n\n');
    load (FileName);
else
    fprintf('\nThis function need a Excel File or CSV file to perform');
    fprintf('\nPlease type the complete filename, with extension'\n);
    beep;
    return;
end

%Check the datafile. The number of variables must be the same of the number
%of columns. X contains only variables. Textdata contains also the y name.
if (length (textdata)-1) ~= length (X(1,:))
    display(' ');
    display('Variables name doesnt match with the number of file columns');
    display('Exit...\n');
    beep;
end

warning on all

%% Count Variables number
% Count the number of covariates

VarNumber = length (textdata);

fprintf ('%s %d', 'Number or covariates : ', VarNumber-1);
display(' ');

clear VarNumber;

%% Count Outcome groups
% Count number of outcome groups

if (ischar(y)) 
   fprintf('\n\nError: The first column of file must contains only numbers');
   fprintf('\nChange the format from string to integer from 0 to n classes\n');
   display('Exit...\n');
   beep;
   return;
end

if (min(y) ~= 0)
   fprintf('\n\nError: The first outcome class must be 0');
   fprintf('\nChange the format of outcome from 0 to n classes\n');
   display('Exit...\n');
   beep;
   return; 
end

NumberOfClasses = max(y)-min(y)+1;

fprintf('\n%s %d\n', 'Number of outcome classes : ', NumberOfClasses);

clear NumberOfClasses;

%%Chech for NaN in outcome groups
%NaN give some problems with ROCTree. A NaN is treated as missing class,
%and when it displayed ROCs don't reach the value 1 of AUC. So you need to
%delete the entire row. Please open the excel file, seletect the entire row
% and eliminate it without leaving the blank space.
%All the covariates value for a missing class is unusable for classification. 
%
nancheck = isnan(y);
if (nancheck(nancheck ==1) ) >= 1
   fprintf('\n\nError: The outcome classes musn\''t contains invalid classes (NaN)');
   fprintf('\nPlease delete observation(s) (clear entire row) from the input file\n');
   beep;
   return;
end

clear nancheck;

%% Launch a GUI to select variables from the imported file

% Launch a GUI for selecting variables to include in analysis
global sSelectedVariables;
global iExit

%Set the global variables SelectedVariables
RocTreeSelVarGUI(textdata);

if iExit== -1
    fprintf ('\nExit requested by the user ...\n');
    return;
end

%Generate an index of selected variables.
IndexOfSelected =0;

for index = 1:1:length(textdata)
    for index2 = 1:1:length(sSelectedVariables)
        if strcmp(sSelectedVariables(1,index2), textdata(1,index))
            %Need index - 1 beause the first variable is the outcome
            %At this moment of the process outcome variable was just
            %converted in the variable y. In the array X (analyzed after by the program)
            %remain all the explanatory variables. So X start from the
            %textdata (2)
            IndexOfSelected (index2) = index -1;
        end
    end
end

%Sort
IndexOfSelected = sort (IndexOfSelected);

%Display Index. Debug only.
%display(IndexOfSelected);

%Cut from textdata all variables not selected

backuptd = textdata;
textdata (:,:) = [];
%textdata (:,:) = [];
textdata(1) = backuptd(1);

for index = 1:1:length(IndexOfSelected)
    textdata(index+1) = backuptd (IndexOfSelected(index)+1);
end

backupX = X;
clear global X;

for index = 1:1:length(IndexOfSelected)
    X(:,index) = backupX (:,IndexOfSelected(index));
end

clear backuptd backupX index index2; 


%% Launch a GUI for select categorical variables
% Launch a GUI for selecting categorical Variables.
global CatSelected;


%Call the GUI
%This GUI create a workspace cell array variable named CatSelected contains
%a list of categorical variables.
RocTreeGUI(textdata) 
%Check the exit status with the global variable iExit
if iExit== -1
    fprintf ('\nExit requested by the user ...\n');
    return;
end

%Control the CatSelected names with textdata (imported from excel) and
%find the corresponding number in the list.
%global gIndexOfCategorical;
gIndexOfCategorical =0;

for index = 1:1:length(textdata)
    for index2 = 1:1:length(CatSelected)
        if strcmp(CatSelected(index2,1), textdata(1,index))
            %Need index - 1 beause the first variable is the outcome
            %At this moment of the process outcome variable was just
            %converted in the variable y. In the array X (analyzed after by the program)
            %remain all the explanatory variables. So X start from the
            %textdata (2)
            gIndexOfCategorical (index2) = index -1;
        end
    end
end

%Sort the index
gIndexOfCategorical = sort (gIndexOfCategorical);

%Display the variables.
display ('Selected variables as categorical :');
for index = 1:1:length(CatSelected)
    display(CatSelected(index));

end

%Cancel on final version
%display (gIndexOfCategorical)

 

%% Classificatory tree
% Classificates and plots tree

%NaN warning in italian. The same of above.
%Attenzione: I NaN fanno casino quando appartengono ai classificatori.
%In questo caso, quando i NaN appartengono ai classificatori, la ROC non
%ottiene il valore 100 % finale, perch? non li classifica.

fprintf ('\n------ Starting Classificatory tree with Gini algorithm ------\n\n');


%Calculate the number of the groups.
[outcomegroups, numberofgroups] = CalculateOutcomeGroups (y);  

%Perform the classification with or without categorical variables. If you
%have categorical variables you must specify in this function.
if gIndexOfCategorical == 0
    t = classregtree (X, y, 'method', 'classification', 'splitcriterion', 'gdi');
else
    t = classregtree (X, y, 'method', 'classification', 'splitcriterion', 'gdi', 'categorical' ,gIndexOfCategorical);
end

%Display the tree
view(t, 'names', textdata(2:end))

%% Features importance list
% Find feature relative importance  (percentage)

FeaturesImportanceList = CalculateFeaturesImportance (t,textdata);

%% Calculates leafs population

%Return the number of nodes
nnodes = numnodes(t);

%Find the terminal node (the terminal node contain 2 child leafs 
childnodevector = 0;
childnodeindex = 1;

for index=1:1:nnodes
    ischild=children(t,index);
    if (ischild (1) == 0) && (ischild (2) == 0)
        childnodevector(childnodeindex) =  index;
        childnodeindex=childnodeindex+1;
    end
end

%Calculates The Number of leafs
numchildnode = childnodeindex-1;

display(['----> Leafs number (= terminal nodes) : ', int2str(numchildnode)] );

%Close all graph.
close all;

%% Fit the best tree and return pruning level
%Calculate best nodes


%PAY ATTENTION: COMMENT THIS LINE IF THE PROGRAM GIVE YOU AN ERROR. I've
%found that 2009b may give an error in this point. I can't explain why.

Bestprune = BestTree (t,X,y, 10);


%% Plot ROC curves for each group (group 0 is excluded)

%Calculates AUC and plot the Curves of ROC for each group.

%Se ci sono solo 2 gruppi calcola le ROC e l'AUC
%Indica il gruppo. 
%Se gruppo = 1 -> target = gruppo 0
%se gruppo = 2 -> target = gruppo 1
%se gruppo = 3 -> target = gruppo 2

%Specificy the target group from 0 to number of group-1
%Remember that if you have 4 group the variable contain 4. But the groups
%are: 0, 1, 2, 3

%Calculate the ROC of each group. 
for index = 1:1:numberofgroups
    [AUC, ROCMatrix] = treeROC (t, index-1, numberofgroups);
end
clear index;

%% Evaluate the classification accuracy
% 

sfit = eval (t, X);

Convertedy = num2str(y);

pct = mean(strcmp(sfit,Convertedy));

fprintf ('\nProportion that is correctly classified : %.2f \n', pct*100);


end

