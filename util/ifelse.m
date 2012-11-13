function res=ifelse(bool, true_val, false_val)
% IFELSE Returns one of two arguments depending on condition.
%   RES=IFELSE(BOOL, TRUE_VAL, FALSE_VAL) returns TRUE_VAL if BOOL is true,
%   else FALSE_VAL, as probably exected. This function, however trivial, is
%   quite handy, when a conditional is needed where you can not specify
%   one, like in an expression or eval statement. Note however, that there
%   is no short-circuiting in this function and both arguments are
%   evaluated. If you want short-circuiting but the return values into a
%   string and pass the result to eval (see example section).
%
% Example (<a href="matlab:run_example ifelse">run</a>)
%    for i=1:5
%       fprintf( '%d %s of beer\n', i, ifelse(i==1, 'bottle', 'bottles') );
%    end
%    % short circuiting
%    x=0;
%    disp( 'this gives a warning' )
%    disp( ifelse( x==0, x, 1/x ) );
%    disp( 'this doesn''t' )
%    disp( eval( ifelse( x==0, 'x', '1/x' ) ) );
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if bool
    res=true_val;
else
    res=false_val;
end
