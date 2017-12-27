function Jab=J(x,lambda)

Jab = lambda*[1 -1]*x.^2 + (1-lambda)*1e-3/(1e-2+[1 -1]*x.^4);
    
end

