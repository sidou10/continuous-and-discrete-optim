function GradResults = gradient_rho_adaptatif(han_f, han_df, U0, rho0, tol)
% Fonction permettant de minimiser la fonction f(U) par rapport au vecteur U 
% Méthode : gradient à pas fixe
% INPUTS :
% - han_f   : handle vers la fonction à minimiser
% - han_df  : handle vers le gradient de la fonction à minimiser
% - U0      : vecteur initial 
% - rho     : paramètre gérant l'amplitude des déplacement 
% - tol     : tolérance pour définir le critère d'arrêt
% OUTPUT : 
% - GradResults : structure décrivant la solution 

itermax=10000;  % nombre maximal d'itérations 

xn=U0; f=han_f(xn); % point initial de l'algorithme
it=0;          % compteur pour les itérations
converged = false;
rho = rho0;
call = 0;
%% Adaptative step implementation

while ~converged && it < itermax  
    it=it+1;
    dfx=han_df(xn);       %Compute the gradient
    xnp1=xn-rho*dfx;      %Compute x(n+1)
    fnp1=han_f(xnp1);     %Compute f(x(n+1))
    call = call + 1;      %Increment the number of calls to the cost function  
    if abs(fnp1-f)<tol    %Check convergence
        converged = true;
    end
    if fnp1 < f           %Compare f(x(n)) and f(x(n+1))
        rho = 2*rho;      %If x(n+1) better, move to it and double rho
        xn=xnp1;          %Otherwise, stay at x(n) and divide rho
        f=fnp1;
    else
        rho = rho/2;
    end
end

%% Résultats
GradResults.initial_x=U0;         % vecteur initial
GradResults.minimum=xnp1;         % vecteur après optimisation
GradResults.f_minimum=fnp1;       % valeur optimale de la fonction
GradResults.nb_appels=call;       % nb appels a f ou df  
GradResults.iterations=it;        % nombre d'itérations
GradResults.converged=converged;  % true si l'algorithme a convergé