function test_pce_divide
% TEST_PCE_DIVIDE Test the PCE_DIVIDE function.
%
% Example 
%    test_pce_divide
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'pce_divide' );

p=10;

% Define the random variables A, B and X.
%a_func={@exponential_stdnor, {2}};
a_func={@uniform_stdnor, {2,3}};
b_func={@lognorm_stdnor, {1.5, 0.5}};
x_func={@div_func,{b_func, a_func}};

% method 3: pce by b_func/a_func
x_gamma_ex=pce_expand_1d( x_func, p );

% method 4: solving stochastic galerkin equatin with pces of a and b
[a_alpha,I_a]=pce_expand_1d( a_func, p );
[b_beta,I_b]=pce_expand_1d( b_func, p );

tic
for i=1:1+00
    x_gamma=pce_divide( a_alpha, I_a, b_beta, I_b );
end
%toc

if 0
    [x_gamma_ex; x_gamma]'
    format short
    (x_gamma_ex-x_gamma)'./x_gamma_ex'*100
end

assert_equals( x_gamma(1:5), x_gamma_ex(1:5), 'pce_coeff', 'reltol', 0.1.^[7,5,4,4,2] );



function y=div_func( x, num_func, den_func )
y=funcall(num_func,x)./funcall(den_func,x);

