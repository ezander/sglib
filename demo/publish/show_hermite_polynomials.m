%% Univariate Hermite Polynomials
% Show how to generate and plot univariate Hermite polynomials.
%
% Back to the <./ directory index>

%% License
function show_hermite_polynomials
%   Author: Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

%% Show the coefficient of Hermite polynomials
% Here we call the hermite function for each polynomial degree we want to
% output (note that in matlab the order of coefficients is kind of
% reversed)

for p=0:5
    h=hermite(p);
    disp(h);
end

%% Get a bunch of Hermite polynomials at once and output as polynomial
% Here we call the hermite function such that it returns all polynomials at
% once, and pass the result to a polynomials formatting function.

H=hermite(6,true);
format_poly( H, 'tight', false, 'twoline', true );

%% Plot Hermite polynomials (the conventional way)
% This is how you would conventionally evaluate some polynomials in matlab:
% get the coefficients and evaluate at the locations you want.

x=linspace(-2,2);
H=hermite(6,true);
y=zeros( 0, size(x,2) );
for i=0:5
    y=[y; polyval( H(i+1,:), x' )'];
end
plot( x, y );

%% Plot Hermite polynomials (the better and faster way)
% Since evaluation of Hermite polynomials (with respect to multiindices and
% different coefficients sets) is needed pretty often in stochastic
% Galerkin and collocation there are special functions to simplify this and
% speed things up. pce_evaluate evaluates a given pce at the points
% specifieds in x. The pce in this case has coefficients eye(6) with
% respect to multiindex set 0:5 i.e. the i-th polynomials referenced in
% this way is just H_{i-1}. If this does not make sense to you: In the
% example above you could have written y=[y; pce_evaluate( 1, i, x )];

x=linspace(-2,2);
y=pce_evaluate( eye(6), (0:5)', x );
plot( x, y );
