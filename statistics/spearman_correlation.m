function r=spearman_correlation(x,y,use_pearson)
% SPEARMAN_CORRELATION Computes the Spearman rank correlation coefficient.
%   R=SPEARMAN_CORRELATION(X,Y,USE_PEARSON) Computes the Spearman rank
%   correlation coefficient of the data sets X and Y, which must be vectors
%   of equal length. If USE_PEARSON is false, then if RKX and RKY are the
%   ranks of the data in X and Y, R is computed as
%   1-6*SUM((RKX-RKY).^2)/(N*(N*N-1)). If USE_PEARSON is true or
%   unspecified, then R is computed as the Pearson coefficient of RKX and
%   RKY.
%   
%   Note: There is no provision for ties here, in which case the formula
%   simple above is not adequate. Therefore USE_PEARSON has a default value
%   of true.
%
% Example (<a href="matlab:run_example spearman_correlation">run</a>)
%   N=10000;
%   x=rand(N,1); y=rand(N,1);
%   fprintf( 'Detects linear dependence well:\n' );
%   fprintf( 'r(x,x)=%g (expected: 1)\n', spearman_correlation(x,x) ); 
%   fprintf( 'r(x,-2*x)=%g (expected: -1)\n', spearman_correlation(x,-2*x) ); 
%   fprintf( 'Detects independence:\n' );
%   fprintf( 'r(x,y)=%g (expected: 0)\n', spearman_correlation(x,y) ); 
%   fprintf( 'r(x,y+0.2*x)=%g (expected: 0.2)\n', spearman_correlation(x,y+0.2*x) ); 
%   fprintf( 'Does not detect nonmonotone, nonlinear dependence:\n' );
%   z=sin(pi*x); 
%   fprintf( 'r(x,z)=%g (expected: 0)\n', spearman_correlation(x,z) ); 
%   fprintf( 'Does detect monotone, nonlinear dependence:\n' );
%   z=x.^2; 
%   fprintf( 'r(x,z)=%g (expected: 1)\n', spearman_correlation(x,z) ); 
%
% See also PEARSON_CORRELATION

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

if nargin<3
    use_pearson=true;
end

n=length(x);
[dummy,indx]=sort(x);
[dummy,indy]=sort(y);
rkx(indx)=1:n;
rky(indy)=1:n;

if use_pearson
    r=pearson_correlation(rkx,rky);
else
    d=rkx-rky;
    r=1-6*sum(d.^2)/(n*(n^2-1));
end
