close all, clear all
[Aineq,B,S] = definition_constantes;
han_f4  = @(u) f4(u,B,S);
d=5;
%% 1.3.b
%Utilisation de fminunc
disp('Using Quasi-Newton');

tolerance = 1e-6;
options = optimoptions('fminunc', 'algorithm', 'quasi-newton', 'TolFun', tolerance, 'Display', 'off');

nb_min = 100;
mins_found = [];

tic
for i=1:nb_min
    U0 = rand(d,1);
    [X, FVAL, EXITFLAG, OUTPUT] = fminunc(han_f4, U0, options);
    if not(ismember(round(FVAL,4), mins_found))
        mins_found = [mins_found, round(FVAL,4)];
    end
end
toc

disp('Minimums found: ');
disp(mins_found);
%% 1.3.c
lb = [];
ub = [];

nb_min = 10;

ini_temps = 1:25:101;
rean_ints = 1:25:101;

for ini_temp= ini_temps
    for rean_int = rean_ints
        min_found = 0;
        for i=1:nb_min
        U0 = rand(d,1)*10;
        options = optimoptions('simulannealbnd', 'ReannealInterval', rean_int,'InitialTemperature',ini_temp,'MaxIterations', 10000, 'TolFun', tolerance, 'Display', 'off');
        [x,fval,exitflag,output] = simulannealbnd(han_f4, U0, lb, ub, options);
        if round(fval,4) == -10.7979
            min_found = min_found+1;
        end
        end
        disp(['Ini Temp = ', num2str(ini_temp), ', Rean Int = ' , num2str(rean_int), ', Min found = ', num2str(min_found)]);
    end     
end
