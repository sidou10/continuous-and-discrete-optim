function GradResults = gradient_rho_constant(han_f, han_df, U0, rho, tol)
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
it=0;  % compteur pour les itérations
call = 0;
converged = false;

while ~converged && it < itermax  
    it=it+1;
    dfx=han_df(xn); % valeur courante de la fonction à minimiser
    call = call + 1;
    xnp1=xn-rho*dfx;      % nouveau point courant (x_{n+1})
    fnp1=han_f(xnp1);
    call = call + 1;
    if abs(fnp1-f)<tol
        converged = true;
    end
    xn=xnp1; f=fnp1;      % xnp1 : nouveau point courant
end

GradResults.initial_x=U0;         % vecteur initial
GradResults.minimum=xnp1;         % vecteur après optimisation
GradResults.f_minimum=fnp1;       % valeur optimale de la fonction
GradResults
GradResults.nb_appels=call;       % nb appels
GradResults.iterations=it;        % nombre d'itérations
GradResults.converged=converged;  % true si l'algorithme a convergé