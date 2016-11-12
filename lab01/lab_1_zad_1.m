% Zadanie 1

clc
clear
format compact

f = [ -4; 1; 2 ];
A = [ -3 1 -7; -1 2 0; -2 -1 5 ];
b = [ 2; 5; 2 ];

% ograniczenia

lb = [ 0; 0; 0 ];
ub = [];
opcje = optimset('linprog');
opcje = optimset(opcje, 'largescale', 'off', 'Simplex', 'on', 'Display', 'iter');

%printf('Z ograniczeniem dolnym:')

[x, fval, exitflag, output, lambda] = linprog(-f, A, b, [], [], lb, ub, [], opcje) % -f, bo szukamy max
fval = -fval

%printf('Bez ograniczenia dolnego:')

%lb = []

%[x, fval, exitflag, output, lambda] = linprog(-f, A, b, [], [], lb, ub, [], opcje) % -f, bo szukamy max
fval = -fval