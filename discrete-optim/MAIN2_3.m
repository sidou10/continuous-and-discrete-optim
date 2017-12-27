%%
N = 10000;

a = 0.02 + rand(1,N).*0.98;
b = rand(1,N).*(a-0.01);

d = 1e-3./(1e-2 + a.^4 - b.^4);
p = a.^2 - b.^2;


frontiere = [];
for i=1:N
    index = find(p<p(i));
    index2 = find(d(index)<d(i));
    if (isempty(index2))
        frontiere = [frontiere; i];
    end
end
hold on
plot(p,d, 'LineStyle', 'none', 'Marker', '.');
plot(p(frontiere),d(frontiere), 'LineStyle', 'none', 'color', 'r', 'Marker', 'o');
xlabel('Poids');
ylabel('Déformation');

%%
disp('SQP');
x_min = [];
Aineq = [1 0;-1 0;0 -1;-1 1];
bineq = [1;-0.002;0;-0.01];
tolerance = 1e-9;

for lambda=0:0.001:1
    han_J = @(x) J(x, lambda);
    options = optimoptions('fmincon', 'TolFun', tolerance, 'Display', 'off');
    [X, FVAL, EXITFLAG, OUTPUT] = fmincon(han_J,rand(2,1),Aineq,bineq,[],[],[],[],[],options);
    x_min = [x_min; X'];
end

p = x_min(:,1).^2 - x_min(:,2).^2;
d = 1e-3./(1e-2 + x_min(:,1).^4 - x_min(:,2).^4);

hold on
plot(p,d, 'LineStyle', 'none', 'Marker', 'x');
axis([0 1 0 0.1]);
hold off
