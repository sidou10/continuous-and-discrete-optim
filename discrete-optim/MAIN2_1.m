load('DonneesRangerObjets.mat');

Aeq = zeros(30,225);

%Contraintes Somme_sur_i (xij) = 1
debut = 1;
for i=1:15
    Aeq(i, debut:debut+14) = ones(1,15);
    debut = debut + 15;
end

%Contraintes Somme_sur_j (xij) = 1
debut = 1;
for i = 16:30
    for j = debut:15:225
        Aeq(i, j) = 1;
    end
    debut = debut +1;
end

%b
beq = ones(30,1);

%Autres options
lb = zeros(225,1);
ub = ones(225,1);

f1 = reshape(abs(transpose(PositionCasiers - PositionObjets)), [1 225]);

options = optimoptions('intlinprog');
tolerance = 1e-6;
options = optimoptions(options, 'ConstraintTolerance', tolerance, 'ObjectiveImprovementThreshold', tolerance, 'RelativeGapTolerance', tolerance, 'Display', 'off');

[x1,fval1,exitflag1,output1] = intlinprog(f1, 1:225,[],[], Aeq, beq, lb, ub, options);
disp(['Question 2.2 - f minimal = ', num2str(fval1)]);
%%
affichage(x1, PositionCasiers, PositionObjets, ['(Q2) fval = ', num2str(fval1)]);
sparse(reshape(x1, 15, 15))
%%

%Contraintes côte a côte + 1 pas dans la 15
notin = zeros(1,225);
notin(211) = 1;
AeqComp = [eye(14), zeros(14,2),-eye(14),zeros(14,195)];
Aeq2 = [Aeq; AeqComp];
beq2 = [beq;zeros(14,1)];

[x2,fval2,exitflag2,output2] = intlinprog(f1, 1:225,[],[], Aeq2, beq2, lb, ub, options);
disp(['Question 2.3 - f minimal = ', num2str(fval2)]);
%%
affichage(x2, PositionCasiers, PositionObjets, ['(Q3) fval = ', num2str(fval2)]);
sparse(reshape(x2, 15, 15))
%% Contraintes d'inégalités

A = zeros(14,225);
boite_i_courante = 1;
nb_boites_a_droite = 14;

for num_contrainte=1:14
    A(num_contrainte, 2*15 + boite_i_courante) = 1;
    A(num_contrainte, (3*15 + boite_i_courante + 1):(3*15 + boite_i_courante + 1 + nb_boites_a_droite - 1)) = ones(1,nb_boites_a_droite);
    boite_i_courante = boite_i_courante + 1;
    nb_boites_a_droite = nb_boites_a_droite - 1;
end

%Contrainte 3 pas dans 1
notin = zeros(1, 225);
notin(2*15+1) = 1;
Aeq3 = [Aeq2; notin];
beq3 = [beq2; 0];

b = ones(14,1);

[x3,fval3,exitflag3,output3] = intlinprog(f1, 1:225, A, b, Aeq3, beq3, lb, ub, options);
disp(['Question 2.4 - f minimal = ', num2str(fval3)]);
%%
affichage(x3, PositionCasiers, PositionObjets, ['(Q4) fval = ', num2str(fval3)]);
sparse(reshape(x3, 15, 15))
%%
AeqComp = zeros(13, 225);
AeqComp(:,6*15+2:6*15+14) = eye(13);

for i=2:14
    %AeqComp(i-1, 8*15+i-1) = -1;
    AeqComp(i-1, 8*15+i+1) = -1;
end

%Conditions aux bords
bord1 = zeros(1,225);
bord1(15*6+1) = 1;
bord1(15*8+2) = -1;

bord2 = zeros(1,225);
bord2(15*6+15) = 1;
bord2(15*8+14) = -1;

Aeq4 = [Aeq3; AeqComp; bord1; bord2];
beq4 = [beq3; zeros(15,1)];
%Aeq4 = [Aeq3; AeqComp];
%beq4 = [beq3; zeros(13,1)];


[x4,fval4,exitflag4,output4] = intlinprog(f1, 1:225, A, b, Aeq4, beq4, lb, ub, options);
disp(['Question 2.5 - f minimal = ', num2str(fval4)]);

%%
affichage(x4, PositionCasiers, PositionObjets, ['(Q5) fval = ', num2str(fval4)]);
sparse(reshape(x4, 15, 15))

%%
[i_boites, i_objets, s] = find(sparse(reshape(x4, 15, 15)));
assignement = [i_boites, i_objets];
for i=1:14
    %Je récupère les indices de la boite et l'objet associé
    i_boite = assignement(i,1);
    i_objet = assignement(i,2);
    %Je rajoute la contrainte empêchant l'assignement de la boite avec
    %l'objet
    const = zeros(1,225);
    const((i_objet-1)*15 + i_boite) = 1;
    Aeq_block = [Aeq4; const];
    beq_block = [beq4; 0];
    %Je résouds le problème d'optimisation avec la nouvelle contrainte
    [x_block,fval_block,exitflag_block,output_block] = intlinprog(f1, 1:225, A, b, Aeq_block, beq_block, lb, ub, options);
    if round(fval_block, 4) <= round(fval4, 4)
        disp(['(', num2str(i_boite), ', ', num2str(i_objet), ')']);
    end
end

%%
affichage(x_block, PositionCasiers, PositionObjets, ['(Q6) fval = ', num2str(fval_block)]);
