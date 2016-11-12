function[x, fval, exitflag] = simplex_zad3(f, A, b)
% SIMPLEX  Prosta implementacja algorytmu symplex dla maksymalizacji f.
%          Na podstawie wykładu http://www.mini.pw.edu.pl/~epawelec/pm/s4_w3.pdf
%        x: szukane rozwiązanie maksymalizacji
% exitflag: 1 gdy istnieje RO, 0 wpp.
%        f: współczynniki maksymalizowanej funkcji
%        A: lewe strony ograniczeń
%        b: prawe strony ograniczeń
%
% Przykładowe dane wejściowe:
% f = [ 3 2 ]
% A = [ 2 1; 3 3; 1.5 0 ]
% b = [ 10; 24; 6 ]

MAX_ITERATIONS = 100;
exitflag = 0;

% m: ilość ograniczeń
% n: łączna liczba zmiennych (bez dopełniających i sztucznych)

[m, n] = size(A);
assert(size(f, 1) == 1)
assert(size(f, 2) == n)
assert(size(b, 1) == m)
assert(size(b, 2) == 1)

% 1st step
% Wyznaczenie BRD i konstrukcja tabeli.
%
%    |              C              |   
% ___|_____________________________|___
%    |                             |   
%  L |        [ A, eye(m) ]        | b 
% ___|_____________________________|___
%    |              Z              |   
%    |              ZC             |   

C  = [ f, -f, zeros(1, m) ];       % 1 x (2n + m)
L  = zeros(m, 1);                  % m x 1
A  = [ A, -A, eye(m), b ];         % m x (2n + m + 1)

% Zmienne bazowe

BASE = [ 2 * n + 1 : 2 * n + m ]';

for i = 1 : MAX_ITERATIONS    
    % 2nd step
    % Obliczenie wskaźnika optymalności dla aktualnego BRD.
    
    Z  = L' * A(:, 1 : end - 1);
    ZC = Z - C;
    
    % Wypisz informacje diagnostyczne
    
    fprintf('Iteration #%d\n\n', i)
    printlabmatrix(A, L, C, Z, ZC, BASE)
    BASE
    x = currentsolution(BASE, A, m, n)
    
    % 3rd step
    % Sprawdzenie warunku stopu.
    
    if all(ZC >= 0)
        exitflag = 1;
        x = x(1 : n); % Usuń zmienne dopełniające
        fval = f * x
        return;
    end
    
    % 4th, 5th and 6th step
    % - Szukanie najmniejszego elementu wektora (Z - C). Ta zmienna wejdzie do bazy.
    % - Wyliczenie współczynników i na ich podstawie ustalenie jaka zmienna opuści bazę.
    % - Sprawdzenie czy zadanie nie posiada skończonego RO.
    
    minin     = 1;   % indeks zmiennej, która wejdzie do bazy
    minout    = 1;   % indeks zmiennej, która opuści bazę
    minoutval = Inf; % wartość zmiennej, która opuści bazę
    
    for j = 1 : length(ZC)
        if ZC(j) >= 0
            continue;
        end
        
        k = A(:, end) ./ A(:, j); % Pionowy wektor współczynników
        
        if all(k <= 0)
            printf('Finite solution does not exist.\n')
            return;
        end
        
        % Szukamy indeksu minimalnego dodatniego współczynnika z wektora k,
        % któremu odpowiada zmienna, która opuści bazę.
        
        if ZC(j) < minoutval
            minoutval = ZC(minin);
            minin = j;
            minout = find(k == min(k(k > 0)));
        end
    end
    
    BASE(minout) = minin;
    L(minout) = C(minin);
    
    % 7th and 8th step
    % Aktualizacja tabeli. Działanie na wierszach tak, aby w kolumnie była tylko jedna 1.
    
    A(minout, :) = A(minout, :) ./ A(minout, minin); % Podzielenie wiersza, aby pojawiła się jedynka
    
    for j = 1 : m
        if j ~= minout
            A(j, :) = A(j, :) - A(j, minin) .* A(minout, :);
        end
    end
    
    fprintf('_________________________________\n\n')
end

if i == MAX_ITERATIONS
    printf('Giving up after %d iteration(s).\n', i)
    x = currentsolution(BASE, A, m, n);
    x = x(1 : n); % Usuń zmienne dopełniające
    printlabmatrix(A, L, C, Z, ZC, BASE)
end

end

%-----------------------------------------------------------------------------

function[x] = currentsolution(BASE, A, m, n)
% CURRENTSOLUTION:  Wypisuje aktualnie rozpatrywane wartościowanie zmiennych x.
    
    % Wyzerowanie rozwiązania powiększonego o zmienne dopełniające
    x = zeros(2 * n + m, 1);
    
    % Odczytaj rozwiązanie dla zmiennych bazowych (reszta wyzerowana)
    x(BASE) = A(:, end);
    
    x = x(1 : n) - x(n + 1 : 2 * n);
end

%-----------------------------------------------------------------------------

function[A] = printlabmatrix(A, L, C, Z, ZC, BASE)
% PRINTLABMATRIX:  Pomocnicza funkcja do ładnego drukowania tabeli.

    A = [
        [ NaN, NaN , C                 , NaN;
          NaN, NaN , 1 : length(A) - 1 , NaN  ];
        [ L  , BASE, A                        ];
        [ NaN, NaN , Z                 , NaN;
          NaN, NaN , ZC                , NaN  ]
    ];
end