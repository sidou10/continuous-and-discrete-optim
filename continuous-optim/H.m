function Hnu=H(h, nu)


cosi = arrayfun(@(x)double(cos(2*pi*nu*x)), double((1:length(h))'));
Hnu = h'*cosi;

end
