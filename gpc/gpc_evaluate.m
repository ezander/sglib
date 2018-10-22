function a_i_j=gpc_evaluate( a_i_alpha, V_a, xi )
% GPC_EVALUATE Evaluate a GPC at a given number of sample points.
%   A_I=GPC_EVALUATE( A_I_ALPHA, V_A, XI ) computes a realization of
%   the GPC expansion given by the coefficients in A_I_ALPHA w.r.t.
%   multiindex I_A at the sample point(s) given by XI.
% 
% Dimensions:
%   a_i_alpha : N x M
%   I_a       : M x m
%   xi        : m x k
%   a_i       : N x k
%   where N is the spatial dimension, M the stochastic dimension, m the
%   number of basic random variables, and k the number of evaluation
%   points.
%
% Example (<a href="matlab:run_example gpc_evaluate">run</a>)
%   I_a=multiindex( 2, 3 );           % m=2, M=10
%   V_a={'hp', I_a};
%   a_i_alpha=cumsum(ones( 5, 10 ));  % N=5
%   xi=gpcgerm_sample(V_a, 7);            % k=7
%   ai=gpc_evaluate( a_i_alpha, V_a, xi );
%   
%   subplot(3,2,1)
%   xi = linspace(-3,3);
%   plot(xi, gpc_evaluate( eye(6), {'H', (0:5)'}, xi));
%   title('Hermite (stoch.)'); ylim([-10, 10]); grid on;
%   subplot(3,2,2)
%   xi = linspace(-1,1);
%   plot(xi, gpc_evaluate( eye(6), {'P', (0:5)'}, xi));
%   title('Legendre'); grid on;
%   subplot(3,2,3)
%   xi = linspace(-1,1);
%   plot(xi, gpc_evaluate( eye(6), {'T', (0:5)'}, xi));
%   title('Chebyshev 1st'); grid on;
%   subplot(3,2,4)
%   xi = linspace(-1,1);
%   plot(xi, gpc_evaluate( eye(6), {'U', (0:5)'}, xi));
%   title('Chebyshev 2nd'); ylim([-1.5, 1.5]); grid on;
%   subplot(3,2,5)
%   xi = linspace(-5,20);
%   plot(xi, gpc_evaluate( eye(6), {'L', (0:5)'}, xi));
%   title('Laguerre'); ylim([-10, 20]); grid on;
%
% See also GPC, GPCGERM_SAMPLE

%   Elmar Zander
%   Copyright 2012, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% check whether arguments a_i_alpha, I_a and xi match
syschars = V_a{1};
I_a = V_a{2};
m = size(I_a, 2);

check_boolean(length(syschars)==1 || length(syschars)==m, 'length of polynomial system must be one or match the size of the multiindices', mfilename);
check_match(a_i_alpha, I_a, false, 'a_i_alpha', 'I_a', mfilename);
check_match(I_a, xi, false, 'I_a', 'xi', mfilename);

% evaluate the gpc basis functions
y_alpha_j = gpcbasis_evaluate(V_a, xi);

% multiply with gpc coefficients
% N x k : (N x M) * (M x k)
a_i_j = a_i_alpha * y_alpha_j;
