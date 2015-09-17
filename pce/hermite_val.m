function y=hermite_val( pce_coeff, x )
% HERMITE_VAL Evaluate expansion of univariate Hermite polynomials.
%   Y=HERMITE_VAL( PCE_COEFF, X ) evaluates the Hermite polynomial given
%   by the coefficients in PCE_COEFF at the positions given in X.
%
% Example (<a href="matlab:run_example hermite_val">run</a>)
%   pcc=pce_expand_1d( @exp, 4 );
%   x=linspace(0,10);
%   y=hermite_val( pcc, x );
%   plot(x,y);
%
% See also HERMITE_VAL_MULTI

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


% 
a_i_alpha = pce_coeff;
p = size(a_i_alpha, 2)-1;
V_a = gpcbasis_create('H', 'I', (0:p)' );
y = gpc_evaluate(a_i_alpha, V_a, x);
