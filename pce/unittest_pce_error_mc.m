function unittest_pce_error_mc
% UNITTEST_PCE_ERROR_MC Test the PCE_ERROR_MC function.
%
% Example (<a href="matlab:run_example unittest_pce_error_mc">run</a>)
%   unittest_pce_error_mc
%
% See also PCE_ERROR_MC, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'pce_error_mc' );

% set the random number generators to a specific state (rand for the random
% generation of the coeffixients and randn for the monte carlo stuff)
% munit_control_rand('seed', 12312 ); % fails...
munit_control_rand('seed');

m=4;
[ex, pce_func1, pce_func2]=setup( m, 0, 10 );
assert_equals( ex, pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1 ), 'p0b1');
assert_equals( ex, pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 7 ), 'p0b7' );
assert_equals( ex, pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1000 ), 'p0b1000' );

[ex, pce_func1, pce_func2]=setup( m, 2, 5 );
assert_equals( ex, pce_error_mc( pce_func1, pce_func2, m ), 'p2', 'reltol', 0.1 );

function [ex, pce_func1, pce_func2]=setup( m, p, N )
I=multiindex(m,p);
M=size(I,1);
x_i_alpha=rand(N,M);
y_i_alpha=rand(N,M);
d_i_alpha=[x_i_alpha-y_i_alpha];
[meand,vard]=pce_moments( d_i_alpha, I );
ex=sqrt(sum(meand.^2+vard));

pce_func1={ @pce_evaluate, {x_i_alpha, I}, {1,2} };
pce_func2={ @pce_evaluate, {y_i_alpha, I}, {1,2} };
