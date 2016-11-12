% Test algorytmu dual_simplex.m

clc
clear
format compact

f = [ -13 -16 -22 -40 ]'
A = [ -1 -1 -1 -1 ; 0 -1 -2 -4 ]
b = [ -4; -3 ]

[x, fval, exitflag] = simplex_dual(f, A, b)

% Sprawdzenie linprogiem:

%lb = [ 0; 0; 0 ];
%ub = [];
%opcje = optimset('linprog');
%opcje = optimset(opcje, 'largescale', 'off', 'Simplex', 'on', 'Display', 'iter');
%
%[x, fval, exitflag, output, lambda] = linprog(-f, A, b, [], [], lb, ub, [], opcje) % -f, bo szukamy max
%fval = -fval