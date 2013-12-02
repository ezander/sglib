function r=roundat( a, scale )
% ROUNDAT Rounds to some given scale.
%   R=ROUNDAT( A, SCALE ) rounds the data given in A according to the scale
%   given in SCALE. If SCALE equals 1 this is normal rounding. If SCALE is
%   e.g. 0.1 then A is rounded to the nearest first decimal digit, i.e.
%   0.37 is rounded to 0.4.
%
% Example (<a href="matlab:run_example roundat">run</a>)
%   % suppose you have a process that produces "near" integer data
%   % but maybe not everything is really "near" and you want to see that
%   a=(1:10)+0.00001*randn(1,10);
%   a(3)=3.93487593423471;
%   a(7)=6.39478423456493;
%   disp('you don''t see too much here...')
%   disp(a)
%   disp('that''s much better...')
%   disp(roundat(a,0.001))
%   
% See also

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

r=floor( a/scale+0.5 )*scale;
