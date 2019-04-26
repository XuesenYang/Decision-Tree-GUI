%% Reprune
% Questa funzione chiede il livello di pruning (non il numero delle foglie)
% ed esegue il pruning dell'albero, generando un nuovo tree (newt).
% Automaticamente poi avvia la costruzione delle ROC
% Richiede di inserire il valore di pruning (digitarlo quando richiesto).
% Questo valore NON corrisponde al numero di nodi rimanenti ma al valore di
% pruning, da valutare direttamente nell'albero classificatorio
%% MAIN FUNCTION

%Chiude tutti i grafici mostrati e fa il repruning.
close all;

prunelevel = input ('Enter prune level : ');
fprintf ('\n---- > Pruning with pruning level : %d\n\n', prunelevel);
newt = prune (t, 'level',prunelevel); 
view(newt, 'name', textdata(2:end));

%Return the number of nodes
nnodes = numnodes(newt);

%Determina i nodi terminali, ossia le leafs (foglie)
childnodeindex = 1;

for index=1:1:nnodes
    ischild=children(newt,index);
    if (ischild (1) == 0) && (ischild (2) == 0)
        childnodeindex=childnodeindex+1;
    end
end
%The Number of leafs
numchildnode = childnodeindex-1;

display(['----> Leafs number (= terminal nodes) : ', int2str(numchildnode)] );

for index = 1:1:groups
    [AUC, ROCMatrix] = treeROC (newt, index-1, groups);
end


