function Jh=J(h, discretisation)

Jh = 0;
for nu=discretisation
    clone = nu;
    ecart = abs(H0(clone) - H(h,clone));
    if ecart > Jh
        Jh = ecart;
    end
end
  
    
end


