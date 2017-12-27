function beta=penalisation(U)
beta = sum(max(0,U-1).^2 + max(0, -U).^2);