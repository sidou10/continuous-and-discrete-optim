function [] = affichage(x_sol, PositionCasiers, PositionObjets, titre)
%AFFICHAGE Summary of this function goes here
%   Detailed explanation goes here
hold on
title(titre);
plot(PositionCasiers', zeros(1,15)', 'LineStyle', 'none', 'Marker', 'o');
plot(real(PositionObjets), imag(PositionObjets), 'LineStyle', 'none', 'Marker', 'none');
x_sol_reshaped = reshape(x_sol, 15, 15);
for i=1:15
    x_casier = PositionCasiers(i);
    y_casier = 0;
    text(x_casier, y_casier + 0.05, "B" + i);
    
    x_objet = real(PositionObjets(i));
    y_objet = imag(PositionObjets(i));
    text(x_objet, y_objet, "O" + i);
    
    xs = [PositionCasiers(i)];
    ys = [0];
    
    res_boite_i = x_sol_reshaped(i, :);
    
    c = 0;
    for j=res_boite_i
        c = c + 1;
        if floor(j) == 1 | ceil(j) == 1
            xs = [xs;real(PositionObjets(c))];
            ys = [ys;imag(PositionObjets(c))];
        end
    end
    
    plot(xs, ys, 'LineStyle', '-')
end
hold off
end

