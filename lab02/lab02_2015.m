% Zad. 1

f = [ 30, 95, 40, -10, 20, 10, 50 ]
b = [ 5, 6 ]
A = [ 5, 2, 1, 1, 0, 1, 0;
      3, 5, 2, 0, 1, 0, 1 ]
lb = [ 0, 0, 0, 0, 0, -inf, -inf ] 
up = [ inf, inf, inf, inf, inf, 0, 0 ]

options = optimset('linprog');
options = optimset(options, 'largeScale', 'off');
options = optimset(options, 'simplex', 'on');
[ x, fval, exitflag, output, lambda ] = linprog(-f, [], [], A, b, lb, up, [], options)

% Zad. 2

f = [ 5 ; 6 ];
A = [ 5 3;
      2 5;
      1 2 ];
b = [ 30 ; 95 ; 40 ];
lowerBound = [ -10 ; 20 ];
upperBound = [  10 ; 50 ];

[ x, fval ] = linprog(-f, A, b, [], [], lowerBound, upperBound)

[ m, n ] = size(A);

hold on
grid on
x1_min = -20; x1_max = 20;
x2_min = 10; x2_max = 60;
x1 = x1_min : 0.01 : x1_max;
x2 = x2_min : 0.1 : x2_max;
axis([ x1_min x1_max x2_min x2_max ]);
[ X1, X2 ] = meshgrid(x1, x2);
F = f(1) .* X1 + f(2) .* X2;
[c, h] = contour(X1, X2, F, 'r-');
clabel(c, h);

for i = 1 : m,
   G = A(i, 1) .* X1 + A(i,2) .* X2 - b(i);
   contour(X1, X2, G, [0 : 0.1 : 1.5], 'g-');   
   contour(X1, X2, G, [0 0], 'b-'); 
   gtext(sprintf('%d', i));
end

y = [5, 3 ; 2, 5]
a = [30, 95]

% Zad. 3

% A = [ 5, 3 ; 1, 2 ]
%
% B = [ 30 ; 95 ]
% A \ B
% ans =
%  -32.1429
%   63.5714
% [ 5, 6 ] * ( A \ B )
% ans =
%  220.7143
%
% B = [ 30 ; 40 ]
% A \ B
% ans =
%   -8.5714
%   24.2857
% [ 5, 6 ] * ( A \ B )
% ans =
%  102.8571