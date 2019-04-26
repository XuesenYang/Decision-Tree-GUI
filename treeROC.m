function [AUC, ROCMatrix] = treeROC (t, group, numberofgroups)
%% Calculate ROC and the AUC (from a ROC) for each group of the outcome.
% FUNCTION INVOKED BY TREE.M  
% The outcome must be categorical.
% numberofgroups :  it must be specified from 0 to one. Please pay attention to set
%                   up your first group with the value 0. 
% group = the group you want to analyze.
% Pay attention at group: if will have value from 0 to n-1.

% Attenzione al GRUPPO: assume i valori da 0 a n-1. Se vi sono 3 gruppi
% questi dovranno avere valore 0, 1, 2
   
    nnodes = numnodes(t);
    %Verify which node is terminal.
    %Determina i nodi terminali, ossia le leafs (foglie)
    childnodevector = 0;
    childnodeindex = 1;

    for index=1:1:nnodes
        ischild=children(t,index);
        if (ischild (1) == 0) && (ischild (2) == 0)
            childnodevector(childnodeindex) =  index;
            childnodeindex=childnodeindex+1;
        end
    end

    numchildnode = childnodeindex-1;
    Pleafs = zeros (2);
    %per ogni foglia, calcola la percentuale di spiegazione del gruppo in
    %oggetto per tale foglia
    %for each leaf calculate the explanatory percentage of each group.
    for index=1:1:numchildnode
        Pleafs(index,1) = childnodevector(index);
        Prob = classprob(t,childnodevector(index));
        %Prob conterrà:
        %   in posizione 1 -> gruppo 0
        %   in posizione 2 -> gruppo 1
        %   in posizione 3 -> gruppo 2
        %   etc...
        %Prob will contain (example of 3 groups):
        %   column 1 -> probability of group 0
        %   column 2 -> probability of group 1
        %   column 3 -> probability of group 2
        Pleafs(index,2) = Prob (group+1);
    end

    %Ordina la percentuale di spiegazione delle foglie dalla più grande alla
    %più piccola
    
    %Sort the explanatory percentage. 

    Pleafsorted = -(sortrows (-Pleafs,2));

    %Save to ROCMatrix
    ROCMatrix = Pleafsorted;

    clear Pleafsorted;

    %Calcola la percentuale di targhet positivi = totale classificati del
    %gruppo in oggetto in quella foglia / totale di soggetti appartenenti
    %al gruppo in oggetto nel database
    
    %Calculate the percentage of positive target = total classified within
    %a group in a leaf / total subjects in that group.
    
    %Colonna 1: gruppo 0, colonna 2: gruppo 1, colonna 3: gruppo 2 ....
    %In Totcases (group+1) = totale soggetti appartenenti al gruppo group
    %nel database
    
    %Calculate the number of total cases in each group.
    Totcases = classcount (t,1); %Ritorna il numero di casi dei vari gruppi
    
    %Calcola il totale dei soggetti appartenenti agli altri gruppi e lo
    %mette in TotExcluded
    
    %Sum the number of subject in each group except that analyzed. 
    TotExcluded = 0;
    for index2 = 1:1:numberofgroups
        if index2 ~= (group+1)
            TotExcluded = Totcases (index2) + TotExcluded;
        end
    end
        
    %ROCMatrix construction: 
    
    %Number of leafs.
    for index=1:1:numchildnode
        %In the first column put the number of negative and positive in the
        %leaf.
        leafcounts = classcount(t,ROCMatrix(index,1));

        %Calculate per percentage of positive target and puts it in the third
        %column. These are the true positive values of the algorithm.
        ROCMatrix (index,3) = leafcounts(group+1)/Totcases(group+1);
        ROCMatrix (index,4) = ROCMatrix (index,3);
       
        %Calculate the percentage of negative target and puts it in the fifth
        %column. These are the false positive of the algorithm.
        %The negative subjects are those in the other group in the leaf
        %that you are watching.
        falsepositive = 0;
        for index2 = 1:1:numberofgroups
            %If it isn't the group analized calculate the false positive
            %number.
            if index2 ~= (group+1)
                falsepositive = falsepositive + leafcounts (index2);
            end
        end
        ROCMatrix (index,5) = falsepositive/TotExcluded;
        ROCMatrix (index,6) = ROCMatrix (index,5);
        
        %Calcola il cumulativo positivo e negativo, presenti rispettivamente
        %nella colonna 4 e 6. Il cumulativo rappresenta la percentuale di veri
        %positivi (colonna 4) e falsi positivi (colonna 6) che corrispondono a
        %sensibilità e specificità
        
        %Calculate the cumulative of the colum 4 and 6. The cumulative
        %percentage is the percentage of true positive (column 4) and false
        %positive (column 6) that is sensibility and specificity.
        if index>1
            ROCMatrix (index,4) = ROCMatrix (index,3) + ROCMatrix (index-1,4);
            ROCMatrix (index,6) = ROCMatrix (index,5) + ROCMatrix (index-1,6);
        end



    end
    
    %Check if ROCMatrix (1,6) and (1,4) is 0, otherwise add a 0 row 
    if ((ROCMatrix (1,6) ~= 0) | (ROCMatrix (1,4) ~= 0))
        ROCGraph = [0 0 0 0 0 0; ROCMatrix];
    else
        ROCGraph = ROCMatrix;
    end        
    
    fprintf ('\nPlotting ROC curves');
    %Plot ROC curves
    figure;
    plot (ROCGraph (:,6), ROCGraph (:,4), 'LineWidth',2);
    hold on;
    plot (ROCGraph (:,6), ROCGraph (:,4), 'x');
    sTitle = sprintf ('ROC curves of decision tree, TARGET group: %d', group);
    title (sTitle);
    axis ([-0.01 1.01 0 1.01]);
    ylabel ('Sensitivity');
    xlabel ('Specificity');
    %Plot random line
    randomx = 0:0.05:1;
    randomy = randomx;
    plot (randomx, randomy, '--');

    %Calcola l'area sotto la curva con il metodo del trapezzoide
    %Calculate AUC with trapezoid algebra.
    AUC = 0;
    oldx = 0;
    oldy = 0;

    %       |
    %       |    
    %       |  ____________________
    %       | /|           |
    %       |/ |           h
    %       ---------------|-------
    %         b            a


    %Exclude the last point because it's 1,1
    for index = 1:1:(numchildnode-1)

        yroc = ROCMatrix (index,4);
        xroc = ROCMatrix (index,6);

        h = yroc - oldy;
        a = 1 - xroc;
        b = xroc - oldx;

        %L'area del trapezzoide è composta dall'area del triangolo più l'area
        %del rettangolo
        %Sum the box area and triangle area.

        %Area del triangolo AT = altezza * base /2
        AT = (b * h)/2;
        AR = (a * h);

        partialAUC = AT+AR;
        AUC = AUC + partialAUC;
        oldx = xroc;
        oldy = yroc;
    end
    %Make string for AUC
    sAUC = sprintf ('AUC = %1.3f', AUC);
    %Display AUC in graph
    text (0.6,0.2, sAUC, 'FontSize',14);
    
    fprintf('\nArea Under Curve (AUC), Target Group: %d', group);
    %fprintf ('\nArea sottesa alla curva - metodo del trapezzoide -, TARGHET group : %d', group);    
    display (AUC);
    clear xroc yroc newx newy b h a;
end