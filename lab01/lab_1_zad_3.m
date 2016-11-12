% Zadanie 3

clc
clear
format compact

f = [ -4; 1; 2 ];
A = [ -3 1 -7; -1 2 0; -2 -1 5 ];
b = [ 2; 5; 2 ];

[x, fval, exitflag] = simplex_zad3(f', A, b)