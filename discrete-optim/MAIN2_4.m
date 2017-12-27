%%
clear;
load('DonneesEnginsChantier.mat');
%%
N = 100;

pinit = 10000;
ploc = 200;
pfin = 10000;

%%
%Fonction transpose(f)
F1 = pinit*eye(N) + tril(ploc*ones(N));
F2 = pfin*eye(N) - tril(ploc*ones(N));
f = ones(1,N)*[F1 F2];

%Contraintes d'inégalité
%Le nombres de machines que l'on a est toujours supérieur à la demande
A1 = tril(-1*ones(N));
A2 = tril(ones(N));
A = [A1 A2];
b = [-D 0];

%Contraintes d'égalité
Aeq = zeros(2, 2*N);
%On ne peut rien rendre à la première semaine
Aeq(1, N+1) = 1;
%Il ne faut avoir aucune machine à la dernière semaine
Aeq(2, 1:N) = 1;
Aeq(2, N+1:2*N) = -1;

beq = zeros(2,1);

%Autres options
lb = zeros(2*N,1);
ub = [];
%%
[x,fval,exitflag,output] = intlinprog(f, 1:2*N,A,b, Aeq, beq, lb, ub);
%%
reshaped = reshape(x, N, 2)'
disp(fval);

%%
n = cumsum(reshaped(1,:)) - cumsum(reshaped(2,:));
a = reshaped(1,:);
r = reshaped(2,:);
d = [D 0];
t = 1:100;
%%

hold on
plot(t, n);
plot(t, d, 'LineStyle', '-');
xlabel('week');
legend('n(t)', 'd(t)');
hold off
