clear all;

%%
discretisation = [linspace(0.00001,0.1,50)';linspace(0.15,0.5,50)'];

crit = @(xx) J(xx, discretisation);

disp('Quasi-Newton');

tolerance = 1e-6;
h0 = rand(200,1);
options = optimoptions('fminunc', 'algorithm', 'quasi-newton', 'TolFun', tolerance);
tic
[X, FVAL, EXITFLAG, OUTPUT] = fminunc(crit, h0, options);
toc
disp(FVAL)