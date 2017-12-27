close all, clear all
[Aineq,B,S] = definition_constantes;
han_f1  = @(u) f1(u,B,S);
han_df1 = @(u) df1(u,B,S);
han_f2 = @(u) f2(u,S);
d=5; 
%% 1.2.1 SQP pour minimiser f1
%A = [eye(5);-eye(5)];
%b = [ones(5,1);zeros(5,1)];
A = [];
b = [];
Aeq = [];
beq = [];
lb = zeros(5,1);
ub = ones(5,1);
nonlcon = [];


options = optimoptions('fmincon', 'algorithm', 'sqp', 'Display', 'off');
disp('SQP Algorithm to minimize f1');
U0 = ones(d,1)./2;


tic
for i=1:1000
    [X, FVAL, EXITFLAG, OUTPUT] = fmincon(han_f1,U0,A,b,Aeq,beq,lb,ub,nonlcon,options);
end
toc

disp(FVAL);
disp(OUTPUT);

%% 1.2.1 SQP pour minimiser f2
disp('SQP Algorithm to minimize f2');
U0 = ones(d,1)./2;

tic
for i=1:1000
    [X, FVAL, EXITFLAG, OUTPUT] = fmincon(han_f2,U0,A,b,Aeq,beq,lb,ub,nonlcon,options);
end
toc

disp(OUTPUT)
%% 1.2.2.2
tolerance = 1e-6;
U0 = zeros(5,1);
xn = U0;

%We try first to solve the penalized function without making epsilon -> 0
%But with epsilon << 1

epsilon_uc = [];
fval_uc = [];
epsilon_nuc = [];
fval_nuc = [];

epsilon = 1e-11;
while epsilon < 1
    han_f1_penal  = @(u) f1_penal(u,B,S, epsilon);
    options = optimoptions('fminunc', 'algorithm', 'quasi-newton', 'TolFun', tolerance, 'Display', 'off');
    [X, FVAL, EXITFLAG, OUTPUT] = fminunc(han_f1_penal, xn, options);
    if sum(round(X,3)>=0) + sum(round(X,3)<=1) == 2*d
        epsilon_uc = [epsilon_uc epsilon];
        fval_uc = [fval_uc FVAL];
    else
        epsilon_nuc = [epsilon_nuc epsilon];
        fval_nuc = [fval_nuc FVAL];
    end 
    epsilon = epsilon * 10;
end
hold on
plot(log10(epsilon_uc), fval_uc, 'LineStyle', 'none', 'Marker', 'o', 'color', 'g', 'DisplayName', 'Constraints OK');
plot(log10(epsilon_nuc), fval_nuc, 'LineStyle', 'none', 'Marker', 'x', 'color', 'r', 'DisplayName', 'Constraints not OK');
xlabel('log10(epsilon)');
ylabel('f value');
legend('show');
title('Result of the minimization of the penalized function, with epsilon fixed');
hold off
%disp(['Minimum f1 penal, without epsilon -> 0: ', num2str(FVAL)]);
%disp('Verifying that the constraints are respected');
%disp(X)
%%
epsilon = 1; %initial epsilon
c = 0;
fval = [];
while epsilon > 0.000000001
    han_f1_penal  = @(u) f1_penal(u,B,S, epsilon);
    options = optimoptions('fminunc', 'algorithm', 'quasi-newton', 'TolFun', tolerance, 'Display', 'off');
    [X, FVAL, EXITFLAG, OUTPUT] = fminunc(han_f1_penal, xn, options);
    xn = X;
    epsilon = epsilon/10;
    fval = [fval FVAL];
    c = c + 1;
end

plot(1:c, fval, 'Marker', 'o', 'color', 'b');
xlabel('# of the iteration');
ylabel('f value');
title('Result of the minimization of the penalized function, with epsilon -> 0');


disp(['Minimum f1 penal, with epsilon -> 0: ', num2str(FVAL)]);
%% 1.2.3.2
tol = 1e-9;
xnm1 = rand(5,1);
lambdan = rand(10,1);
options = optimoptions('fminunc', 'algorithm', 'quasi-newton', 'TolFun', 1e-4, 'Display', 'off');
Lnm1 = -1e10;
rho = 0.1;
maxiter = 10000;
iter = 0;
converged = false;
A = [eye(5);-eye(5)];
b = [ones(5,1);zeros(5,1)];

tic
call = 0; %Counting the number of function calls
while ~converged && iter <= maxiter
    iter = iter + 1;
    han_L = @(u) L1(u,B,S,lambdan);  %In these 2 lines, we minimize respect to u, L(., lambdan)
    [xn, Ln, EXITFLAG, OUTPUT] = fminunc(han_L, xnm1, options);
    call = call + OUTPUT.funcCount;
    if abs(Ln-Lnm1) < tol 
        converged = true;
        break;
    else
        gradLn = (A*xn-b); %Gradient of L1 respect to lambda
        lambdan = max(0, lambdan + rho*gradLn); %the new lambda is the projection of lambdan + rho*gradLn
        Lnm1 = Ln; %Updating the values of of xnm1 and L(xnm1, lambdanm1) for next loop
        xnm1 = xn;
    end
end
toc

disp(converged);
disp(f1(xn,B,S));
disp(call);