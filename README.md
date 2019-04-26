# Decision-Tree-GUI   
# Title   
Decision Trees and Predictive Models with cross-validation and ROC analysis plot   
# Summary   
This code implements a classification tree for data mining method and plots the ROC curves for each target class.    
# Description  
Decision tree learning is a common method used in data mining. Most of the commercial packages offer complex Tree classification algorithms, but they are very much expensive.
This Matlab code uses ‘classregtree' function that implement GINI algorithm to determine the best split for each node.    
The main function of this code is named Tree. It imports data directly from an excel or csv file, using the first row as variable names (necessary). The first column is the outcome group. It must be numeric.
To starting the classification tree type in Matlab workspace: Tree(‘filename.xls’) or Tree(‘filename.csv’) (be careful that your excel file contains a first row with variable names and the outcome group in the first column).
It can also import directly from Matlab file (.mat extension). Please create a file with this 3 variables: X (matrix of covariate values), y (outcome values), textdata (cell structure contains the text name of outcome and covariates). If you want an example please type: [X, y, textdata] = ExcelImport (‘example.xls’) or [X, y, textdata] = ExcelImport (‘yourfile.xls’) and watch the output. 
There are two important issues:    
1)	outcome classes must be numeric, with value from 0 to n.    
2)	outcome classes must’n contain NaN (the code will exit in this circumstance).     
At this point a first GUI helps you to select variables to include in the analysis, so you don’t need to modify your original datafile. It continues with a second GUI that asks for categorical variables: select one or more if necessary.  
Then the Tree function:    
1)	Calculates the features relative importance.   
2)	Draws classification tree.   
3)	Performs a cross validation in order to obtain the best pruning position.     
4)	Draws the cost for pruning.   
5)	Plots ROC curves for each target classes (output classes) and display AUC   
There are some important notes:   
1)	Please pay attention when you save your datafile. The Excel import function of Matlab doesn’t recognize well all excel file type. In MAC OS 10.6.2 with Matlab 2009a, for example, you must save it with Excel 95 compatibility. 
2)	Sometimes the Excel import function does mistakes. You can notice it for a strange list of covariates. In this case watch your file for ‘number typed as string’ or blank columns on the right. I advice you to select outcome and covariates data with the mouse and copy them into a new file (with Ms Copy and Paste function) and use that one.
3)	If you have more than one worksheet in your file, the worksheet to import must be the first.   
4)	Handle with care datafile with missing values. The Matlab ‘classregtree’ function doesn’t use surrogates splits.    
5)	This code runs only with Matlab 2009a (or 2009b). The previous version support classification tree but the functions are quite different.

An example file (example.xls) is included in zip. In matlab type : Tree(‘example.xls’) to start.   
