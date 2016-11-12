function[x, fval, exitflag] = simplex_dual(f, A, b)
% SIMPLEX  Prosta implementacja algorytmu dualnego symplex dla maksymalizacji f.
%          Na podstawie wyk�adu http://www.mini.pw.edu.pl/~epawelec/pm/s4_w4.pdf
%        x: szukane rozwi�zanie maksymalizacji
% exitflag: 1 gdy istnieje RO, 0 wpp. (lub gdy przekroczono maksymaln�
%           dozwolon� liczb� iteracji algorytmu)
%        f: wsp�czynniki maksymalizowanej funkcji
%        A: lewe strony ogranicze�
%        b: prawe strony ogranicze�
%
% Przyk�adowe dane wej�ciowe:
% f = [ -13 -16 -22 -40 ]'
% A = [ -1 -1 -1 -1 ; 0 -1 -2 -4 ]
% b = [ -4; -3 ]
%
% Dane wyj�ciowe:
% [ x, fval, exitflag ] = [ [ 1 3 0 0 ]', -61, 1 ]

MAX_ITERATIONS = 10;
exitflag = 0;
fval = 0;
f = f';

% m: ilo�� ogranicze�
% n: ��czna liczba zmiennych (bez dope�niaj�cych i sztucznych)

[m, n] = size(A);
assert(size(f, 1) == 1)
assert(size(f, 2) == n)
assert(size(b, 1) == m)
assert(size(b, 2) == 1)

% 1st step
% Wyznaczenie BRDD przy za�o�eniu postaci ogranicze�: Ax <= b
% i konstrukcja tabeli.
%
%    |              C              |   
% ___|_____________________________|___
%    |                             |   
%  L |        [ A, eye(m) ]        | b 
% ___|_____________________________|___
%    |              Z              |   
%    |              ZC             |   

C  = [ f, zeros(1, m) ];           % 1 x (n + m)
L  = zeros(m, 1);                  % m x 1
A  = [ A, eye(m), b ];             % m x (n + m + 1)

% Zmienne bazowe

BASE = [ n + 1 : n + m ]';

for i = 1 : MAX_ITERATIONS
    b = A(:, end)
    
    % Policz ZC = Z - C.
    
    Z  = L' * A(:, 1 : end - 1);
    ZC = Z - C;
    
    % Wypisz informacje diagnostyczne.
    
    fprintf('Iteration #%d\n\n', i)
    printlabmatrix(A, L, C, Z, ZC, BASE)
    BASE
    x = currentsolution(BASE, A, m, n)
    
    % 2nd step
    % Sprawd� warunek stopu, tj. czy wszystkie elementy b >= 0. Je�eli tak,
    % to bie��ce BRDD jest dopuszczalne prymalnie i jednocze�nie optymalne.
    
    if (all(b >= 0))
        exitflag = 1;
        x = x(1 : n); % Usu� zmienne dope�niaj�ce
        fval = f * x
        return;
    end
    
    % 3rd step
    % Zastosuj kryterium wyj�cia zmiennej z bazy, tzn. znajd� indeks r = min{b}.
    
    [~, r] = min(b);
    
    % 4th step
    % Sprawd� czy zadanie ZP jest sprzeczne, tzn. czy wszystkie elementy A
    % w wierszu r-tym s� nieujemne. (A jest sklejone z b, dlatego end - 1).
    
    current_row = A(r, 1 : end - 1);
    
    if (all(current_row >= 0))
        disp('sprzecznosc')
        return;
    end
    
    % Znajd� indeks pierwszego elementu ujemnego w wierszu r-tym.
    %
    %[~, j] = find(current_row < 0, 1)
    %a = current_row(j)
    
    % 5th step
    % Zastosuj kryterium wej�cia zmiennej do bazy, tzn. wyznacz indeks k
    % spe�niaj�cy warunek max{ (z - c) / a }, gdzie a < 0.
    
    max_idx = 0;
    max_val = -Inf;
    
    for j = 1 : m + n
        if current_row(j) >= 0
            continue
        end
        val = ZC(j) / current_row(j);
        if (val > max_val)
            max_val = val;
            max_idx = j;
        end
    end
    
    k = max_idx;
    BASE(r) = k;
    L(r) = C(k);
    
    % 7th and 8th step
    % Aktualizacja tabeli eliminacj� Gaussa jak w zwyk�ym sympleksie.
    % Dzia�anie na wierszach tak, aby w kolumnie by�a tylko jedna 1.
    
    A(r, :) = A(r, :) ./ A(r, k); % Podzielenie wiersza, aby pojawi�a si� jedynka
    
    for j = 1 : m
        if j ~= r
            A(j, :) = A(j, :) - A(j, k) .* A(r, :);
        end
    end
    
    disp('_________________________________')
end

if i == MAX_ITERATIONS
    fprintf('Giving up after %d iteration(s).\n', i)
    x = currentsolution(BASE, A, m, n);
    x = x(1 : n); % Usu� zmienne dope�niaj�ce
    printlabmatrix(A, L, C, Z, ZC, BASE)
end

end

%-----------------------------------------------------------------------------

function[x] = currentsolution(BASE, A, m, n)
% CURRENTSOLUTION:  Wypisuje aktualnie rozpatrywane warto�ciowanie zmiennych x.
    
    % Wyzerowanie rozwi�zania powi�kszonego o zmienne dope�niaj�ce
    x = zeros(m + n, 1);
    
    % Odczytaj rozwi�zanie dla zmiennych bazowych (reszta wyzerowana)
    x(BASE) = A(:, end);
end

%-----------------------------------------------------------------------------

function[A] = printlabmatrix(A, L, C, Z, ZC, BASE)
% PRINTLABMATRIX:  Pomocnicza funkcja do �adnego drukowania tabeli.

    A = [
        [ NaN, NaN , C                 , NaN;
          NaN, NaN , 1 : length(A) - 1 , NaN  ];
        [ L  , BASE, A                        ];
        [ NaN, NaN , Z                 , NaN;
          NaN, NaN , ZC                , NaN  ]
    ];
end