function fU=f2(U,S)

fU = transpose(U) * S * U + transpose(U) * exp(U);
