%%
clear
load('ProbaInterception.txt');
    
%%
ind_row = [];
ind_col = [];
val_edges = [];

for row=1:15
    for column=row+1:15
        if not(isnan(ProbaInterception(row,column)))
            ind_row = [ind_row row];
            ind_col = [ind_col column];
            val_edges = [val_edges ProbaInterception(row, column)];
        end
    end
end

G = sparse(ind_col, ind_row, val_edges, 15, 15);

%%
[I,J] = find(~isnan(ProbaInterception));
DG = sparse(I,J, ProbaInterception(~isnan(ProbaInterception)));
G = triu(DG);
view(biograph(G,[],'ShowArrows','off','ShowWeights','on'));

%%
T = sparse(-log(1-DG));
[tree, pred] = graphminspantree(DG);
[tree_min, pred_min] = graphminspantree(T);

view(biograph(tree_min,[],'ShowArrows','off','ShowWeights','on'));

%%
p_min = 1 - exp(-sum(sum(tree_min)));
disp(p)