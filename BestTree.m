function BestPrune = BestTree (t, X, y, nsamples)
%% BestTree
% Calculate Best prune level with cross validation method.
% This function return BestPrune level.

    hold off;
    fprintf ('\n----- Performing cross-validation to calculate best prune');
    fprintf ('\n\nNumber of v-fold : %d', nsamples);
    %Determina il nodo con il costo minore, ossia il minor splitting tramite il
    %metodo della cross validation
    [c,s,n,best] = test(t,'cross', X, y, 'nsamples', nsamples);

    [mincost,minloc] = min(c);
    
    plot(n,c,'b-o',...
         n(best+1),c(best+1),'bs',...
         n,(mincost+s(minloc))*ones(size(n)),'k--');
    xlabel('Tree size (number of terminal nodes)');
    
    maxy = max (c);
    maxn = max (n);
    minx = min (c)/4;
    axis ([minx maxn 0 maxy]);
    ylabel('Cost'); 
    %return bestprune level
    BestPrune = best;
end