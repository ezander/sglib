function unittest_FunctionSystem(varargin)
% UNITTEST_FUNCTIONSYSTEM Test the FUNCTIONSYSTEM function.
%
% Example (<a href="matlab:run_example unittest_FunctionSystem">run</a>)
%   unittest_FunctionSystem
%
% See also FUNCTIONSYSTEM, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'FunctionSystem' );

% Have to test through some derived class, which has not overridden the
% base methods (note that we cannot instantiate FunctionSystem as it is
% abstract, and cannot have a private or internal mock class. It would have
% to be public, and that's too ugly IMHO.
L = JacobiPolynomials(0,0);
assert_equals(L.get_default_syschar(), '', 'empty');
