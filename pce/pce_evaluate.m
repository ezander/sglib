function a_i=pce_evaluate( a_i_alpha, I_a, xi )
% PCE_EVALUATE Evaluate a PCE random variable at a given sample point.
%   A_I=PCE_EVALUATE( A_I_ALPHA, I_A, XI ) computes a realization of
%   the PCE expansion given by the coefficients in A_I_ALPHA w.r.t.
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
% Example (<a href="matlab:run_example pce_evaluate">run</a>)
%   I_a=multiindex( 2, 3 );           % m=2, M=10
%   a_i_alpha=cumsum(ones( 5, 10 ));  % N=5
%   xi=randn(2, 7);                   % k=7
%   pce_evaluate( a_i_alpha, I_a, xi )
%
% See also GPC_EVALUATE, MULTIINDEX

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

a_i = gpc_evaluate( a_i_alpha, {'H', I_a}, xi );
