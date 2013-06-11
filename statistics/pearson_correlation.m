function r=pearson_correlation(x,y)
% PEARSON_CORRELATION Computes the (Pearson) correlation coefficient.
%   R=PEARSON_CORRELATION(X,Y) Computes the Pearson or linear correlation
%   coefficient of the data sets X and Y, which must be vectors of equal
%   length. R is then given by cov(x,y)/sqrt(var(x)*var(y));
%
% Example (<a href="matlab:run_example pearson_correlation">run</a>)
%   N=10000;
%   x=rand(N,1); y=rand(N,1);
%   fprintf( 'Detects linear dependence well:\n' );
%   fprintf( 'r(x,x)=%g (expected: 1)\n', pearson_correlation(x,x) ); 
%   fprintf( 'r(x,-2*x)=%g (expected: -1)\n', pearson_correlation(x,-2*x) ); 
%   fprintf( 'Detects independence:\n' );
%   fprintf( 'r(x,y)=%g (expected: 0)\n', pearson_correlation(x,y) ); 
%   fprintf( 'r(x,y+0.2*x)=%g (expected: 0.2)\n', pearson_correlation(x,y+0.2*x) ); 
%   fprintf( 'Does not detect nonlinear dependence:\n' );
%   z=sin(pi*x); 
%   fprintf( 'r(x,z)=%g (expected: 0)\n', pearson_correlation(x,z) ); 
% 
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

C=cov(x,y);
r=C(1,2)/sqrt(C(1,1)*C(2,2));
