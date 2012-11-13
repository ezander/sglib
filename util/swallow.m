function swallow(varargin)
% SWALLOW Just swallows its arguments
%   SWALLOW(ARG1, ARG2, ...) takes any number of arguments and does just
%   nothing. You don't have to litter your code with ugly instance of 
%     %#ok<ASGLU>
%   or even %#ok<ASGLU*> which suppress all warnings. Furthermore this is
%   complete version independent (You know, in some versions mlint warns
%   you not to do something, you say %#ok, and in the next matlab version,
%   mlint warns you, you don't have to say %#ok, aaargh!)
% 
% Example (<a href="matlab:run_example swallow">run</a>)
%   % Suppose you just need the orthogonal columns of a QR
%   % With swallow mlint won't complain.
%   A=rand(10);
%   [Q,R]=qr( A );
%   swallow( R );
%
% See also NEVER

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
