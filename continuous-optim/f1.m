function fU=f1(U,B,S)

fU = transpose(U) * S * U - transpose(B) * U;
    