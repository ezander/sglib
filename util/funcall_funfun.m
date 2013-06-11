function y=funcall_funfun( varargin )
% FUNCALL_FUNFUN Make FUNCALL mechanism available for Matlab function functions.
%   Matlab's function functions (i.e. functions taking a function as a
%   parameter, as e.g. ode45, fzero, pcg, ...) cannot use SGLIBS function
%   call mechanism directly.  This wrapper function makes it available to
%   those functions (see example), by just calling FUNCALL( FUNC, X ) where
%   FUNC is the last parameter in the VARARG list, and X is all but the
%   last argument. I.e. you just pass the handle @FUNCALL_FUNFUN to the
%   function function and the cell array, you would normally pass to
%   FUNCALL, as anonymous parameter. The function function (e.g. ODE45)
%   will then call FUNCALL_FUNFUN internally, which in turn will call
%   FUNCALL with the parameters in the right order. (It's a bit twisted,
%   isn't it? Anyway, look at the examples, then it becomes clear).
%
% Example (<a href="matlab:run_example funcall_funfun">run</a>)
%   slope=2;
%   func={@mtimes,{slope},{1}};
%   figure; subplot(2,2,1)
%   fplot( @funcall_funfun, [-1,3], [], [], [], func );
%   % now the van der pol equation with different paramters
%   tspan = [0, 20]; y0 = [2; 0]; Mu = 1; subplot(2,2,3)
%   ode45(@funcall_funfun, tspan, y0,[],{@vanderpoldemo,{Mu},{3}});
%   Mu = 10; subplot(2,2,4)
%   ode45(@funcall_funfun, tspan, y0,[],{@vanderpoldemo,{Mu},{3}});
%
% See also FUNCALL, CACHED_FUNCALL, ODE45, FPLOT, DOC_FUNCTION_HANDLE

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

x=varargin(1:end-1);
func=varargin{end};
y=funcall( func, x{:} );
