clc
clear
format compact

% Zad. 1

f = [ 5 ; 15 ; -7 ; -5 ];
A = [ 1  2  1 -1;
     -1  1 -2  2 ];
b = [ 1 ; 2 ];
lb = [ 0 ; 0 ; 0 ; 0 ];
ub = [ inf, inf, inf, inf ];

%options = optimset('linprog');
%options = optimset(options, 'Display', 'iter', 'LargeScale', 'off', 'Simplex', 'on');
[ x, val ] = linprog(-f, A, b, [], [], lb, ub);
x
-val

% Zad. 2

f_d = [ 1; 2 ]; % b
A_d = -[ 1 -1;  % -A_d'
         2  1;
         1 -2;
        -1  2 ];
b_d = -[ 5 ; 15 ; -7 ; -5]; % -f
lb_d = [ 0 ; 0 ];
ub_d = [ inf ; inf ];

% [ x_d, val_d ] = linprog(f_d, A_d, b_d, [], [], lb_d, ub_d);
% x_d
% val_d

% Zad. 3

[ m, n ] = size(A_d);

hold on
grid on

x1_min = -1;
x1_max = 10;
x2_min = -1;
x2_max = 10 ;

x1 = x1_min : 0.1 : x1_max;
x2 = x2_min : 0.1 : x2_max;
axis([ x1_min x1_max x2_min x2_max ]);
[ X1, X2 ] = meshgrid(x1, x2);
F = f(1) .* X1 + f(2) .* X2;
[c, h] = contour(X1, X2, F, 'r-');
clabel(c, h);

for i = 1 : m,
    G = A_d(i, 1) .* X1 + A_d(i, 2) .* X2 - b_d(i);
    contour(X1, X2, G, [-0.1 : 0.1; 0.0], 'g-');
    contour(X1, X2, G, [0 0], 'b-');
    gtext(sprintf('%d', i));
end

% Zad. 4

x_opt = [ A_d(2, :) ; A_d(4, :) ] \ [ b_d(2) ; b_d(4) ];
f_opt = f_d' * x_opt;
x_opt
f_opt