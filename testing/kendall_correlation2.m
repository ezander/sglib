function r=kendall_correlation2(x,y)
% KENDALL_CORRELATION2 Short description of kendall_correlation.
%   KENDALL_CORRELATION2 Long description of kendall_correlation.
%
% Example (<a href="matlab:run_example kendall_correlation2">run</a>)
%   N=10000;
%   x=rand(N,1); y=rand(N,1);
%   fprintf( 'Detects linear dependence well:\n' );
%   fprintf( 'r(x,x)=%g (expected: 1)\n', kendall_correlation2(x,x) ); 
%   fprintf( 'r(x,-2*x)=%g (expected: -1)\n', kendall_correlation2(x,-2*x) ); 
%   fprintf( 'Detects independence:\n' );
%   fprintf( 'r(x,y)=%g (expected: 0)\n', kendall_correlation2(x,y) ); 
%   fprintf( 'r(x,y+0.2*x)=%g (expected: 0.2)\n', kendall_correlation2(x,y+0.2*x) ); 
%   fprintf( 'Does not detect nonmonotone, nonlinear dependence:\n' );
%   z=sin(pi*x); 
%   fprintf( 'r(x,z)=%g (expected: 0)\n', kendall_correlation2(x,z) ); 
%   fprintf( 'Does detect monotone, nonlinear dependence:\n' );
%   z=x.^2; 
%   fprintf( 'r(x,z)=%g (expected: 1)\n', kendall_correlation2(x,z) ); 
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

n=length(x);


[x,ind]=sort(x);
[y,ind]=sort(y(ind));
rk(ind)=1:n;

%warning('this is not correct for certain permutations');
%offset=(1:n)-rk;
%r=sum(offset(offset>0));

r=1-4*numperms(rk)/(n*(n-1));

function p=numperms(rk)
n=length(rk);
p=0;
for i=n:-1:2
    lidx=find(rk==i);
    p=p+(i-lidx);
    rk(lidx)=[];
end
