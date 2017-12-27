close all, clear all
[Aineq,B,S] = definition_constantes;


%% gradient avec rho constant + adaptatif

d=5; U0 = zeros(d,1);
tolerance=1e-6; pas=0.1;
disp(['*** Méthode du gradient avec rho constant: ', num2str(pas),' ***']);
%disp(['*** Méthode du gradient avec rho adaptatif, rho initial = ', num2str(pas),' ***']);


han_f1  = @(u) f1(u,B,S);
han_df1 = @(u) df1(u,B,S);
han_f1_df1 = @(u) deal(f1(u,B,S),df1(u,B,S));

tic
for i=1:2
    %GradResults=gradient_rho_constant(han_f1,han_df1,U0,pas,tolerance);
    GradResults=gradient_rho_adaptatif(han_f1,han_df1,U0,pas,tolerance);
end
toc

%disp(['gradient_rho_constant : minimum=',num2str(GradResults.f_minimum)])
disp(['gradient_rho_adaptatif : minimum=',num2str(GradResults.f_minimum)])

disp(GradResults);
%% Utilisation de fminunc
disp('Quasi-Newton');
options = optimoptions('fminunc', 'algorithm', 'quasi-newton', 'TolFun', tolerance, 'Display', 'off');
tic
for i=1:1000
    [X, FVAL, EXITFLAG, OUTPUT] = fminunc(han_f1, U0, options);
end
toc

disp(OUTPUT)
%% Utilisation de fminunc avec gradient spécifié
disp('Gradient spéficié');
options = optimoptions('fminunc', 'algorithm', 'quasi-newton', 'TolFun', tolerance, 'SpecifyObjectiveGradient', true, 'Display', 'off');
tic
for i=1:1000
    [X, FVAL, EXITFLAG, OUTPUT] = fminunc(han_f1_df1, U0, options);
end
toc

disp(OUTPUT)
