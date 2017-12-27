function H0nu=H0(nu)

if and(0 <= nu,nu <= 0.1)
    H0nu = 1;
elseif and(0.15 <= nu, nu <= 0.5)
    H0nu = 0;
else
    H0nu = 50;
end
