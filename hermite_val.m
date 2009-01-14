function y=hermite_val( pce_coeff, x )
% HERMITE_VAL Evaluate expansion in Hermite polynomials.
%   Y=HERMITE_VAL( PCE_COEFF, X ) evaluates the Hermite polynomial given
%   by the coefficients in PCE_COEFF at the positions given in X. 
%
% Example
%   pcc=pce_expand_1d( @exp, 4 );
%   x=linspace(0,10);
%   y=hermite_val( pcc, x );
%   plot(x,y);
% 
% See also HERMITE_VAL_MULTI

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% check that only single vectors are passed to hermite_val
if ~isvector(pce_coeff)
    warning('hermite_val:no_matrix', 'can pass only one polynomial at a time')
end

% make row vector
if size(pce_coeff,1)>1
    pce_coeff=pce_coeff';
end

if 0
    % old algorithm
    p=[];
    for i=1:length(pce_coeff)
        h=hermite(i-1);
        p=[0 p]+pce_coeff(i)*h;
    end
end

% get all hermite polynomials as matrix and pre-multiply with coefficient
% matrix to get the coefficients of the polynomials
h=hermite(length(pce_coeff)-1,true);
p=pce_coeff*h;

% now evaluate
y=polyval(p,x);
