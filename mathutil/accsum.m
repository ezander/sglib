function s=accsum(v)
% ACCSUM Accurately sums an array without cancellation.
%   S=ACCSUM(V) computes the sum of the entries in V like SUM(V), however,
%   the result is accurate up to full machine precision storing all full
%   precision subtotals. The algorithm can be proven to be correct
%   depending on IEEE-754 arithmetic guarantees [1]. The code of this
%   method is a translation of the Python implementation found in [2].
%
% References:
%   [1] http://www-2.cs.cmu.edu/afs/cs/project/quake/public/papers/robust-arithmetic.ps
%   [2] http://code.activestate.com/recipes/393090/
%
% Example (<a href="matlab:run_example accsum">run</a>)
%    vals = [7.0, 1e100, -7.0, -1e100, -9e-20, 8e-20];
%    vals = repmat( vals, 1, 10 );
%    fprintf( 'The correct result is: %g \n', -1e-19 );
%    fprintf( 'accsum:     %g \n', accsum(vals) );
%    fprintf( 'matlab sum: %g \n', sum(vals) );
%
% See also SUM

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

partials=zeros(1,0);
for j=1:numel(v);
    x=v(j);
    i=1;
    for k=1:numel(partials);
        y=partials(k);
        if abs(x)<abs(y)
            t=x;
            x=y;
            y=t;
        end
        hi=x+y;
        lo=y-(hi-x);
        if lo
            partials(i)=lo;
            i=i+1;
        end
        x=hi;
    end

    partials(i)=x;
    partials(i+1:end)=[];
end

s=sum(partials);
