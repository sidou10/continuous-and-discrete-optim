function fU=f1_penal(U,B,S,epsilon)

fU = transpose(U) * S * U - transpose(B) * U + (1/epsilon)*penalisation(U);
    
