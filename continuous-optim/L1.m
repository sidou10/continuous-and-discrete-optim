function fU=L1(U, B, S,lambda)
A = [eye(5);-eye(5)];
b = [ones(5,1);zeros(5,1)];
fU = f1(U,B,S) + transpose(lambda)*((A*U)-b);
    