function varargout=funcall( func, varargin )
% FUNCALL Call a function with given parameters (extending feval).
%   VARARGOUT=FUNCALL( FUNC, VARARGIN ) calls the functions FUNC with the
%   arguments given in VARARGIN and returning all output arguments in
%   VARARGOUT.
%
%   If FUNC is an anonymous function, inline function or function handle
%   the function is evaluated just normally (see FEVAL). If FUNC is a cell
%   array the handling is special: the first element of FUNC is considered
%   the function handle (or equivalent); the second element is a nested
%   cell array containing additional parameters; if a third element is
%   given, it is again a nested cell array specifying the positions of the
%   additional parameters, otherwise they are assumed to come at the end of
%   the parameter list.
% 
% Note 1: the reason for this extension is that there is no efficient and
%   portable way to specify partially parameterized functions in matlab and
%   octave.
%
% Note 2: Nesting: FUNCALL functions can be arbitrary nested. If func is a
%   function callable by FUNCALL, taking some parameters X and Y, then
%   {func,{3}} is again callable by FUNCALL (now a function of one parameter
%   X, since Y is already bound to 3.
%
% Note 3: The reason that parameters go to the end of the argument list by
%   default is that the function that gets the 'function handle' usually
%   supplies the 'essential' arguments which usually come first and the
%   'parametric' arguments and options are supplied by the caller and come last. 
%
% Note 4: For those who care: this function uses 'nargout bumping' as
%   described in <a href="http://blogs.mathworks.com/loren/2009/04/14/convenient-nargout-behavior/">Convenient nargout Behavior</a>
%
% Example (<a href="matlab:run_example funcall">run</a>)
%   % calling the power function
%   funcall( {@power,{3}},2 )==8
%   funcall( {@(y,x)(power(x,y)),{3}},2 )==9
%   funcall( {@power,{3},{2}},2 )==8
%   funcall( {@power,{3},{1}},2 )==9
%   
%   %call ode45 with (@times,[1,2],1) 
%   % a) positions 1 and 3 for @times and 1 are specified
%   [t,y]=funcall( {@ode45,{@times,1},{1,3}}, [1,2] ); 
%   plot(t,y); hold on;
%   % b) position for 1 is unspecified, so moves to the end of the
%   %    parameter list
%   [t,y]=funcall( {@ode45,{1.5}}, @times, [1,2] ); 
%   plot(t,y); hold off;
%   
%   % calling an arbitrary function
%   disp( funcall( @mtimes, 3, 4 ) ) % calls mtimes(3,4)
%   size( funcall( {@rand, {10,20}}, 30, 40 ) ) % calls rand(30,40,10,20)
%   size( funcall( {@rand, {10,20}, {1,4}}, 30, 40 ) ) % calls rand(10,30,40,20)
%
% 
% See also CELL, ISFUNCTION, VARARGIN, VARARGOUT, NARGIN, NARGOUT, FEVAL

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if iscell( func )
    if length(func)<2
        func{2}={};
    end
    if ~iscell(func{2}) 
        error( 'element 2 of function cell array has to be a cell array' );
    end
    if length(func)>2
        if ~iscell(func{3})
            error( 'element 3 of function cell array has to be a cell array' );
        end
        args=merge_cells( func{2}, func{3}, varargin );
        [varargout{1:nargout}]=funcall( func{1}, args{:} );
    else
        [varargout{1:nargout}]=funcall( func{1}, varargin{:}, func{2}{:} );
    end
elseif ischar( func )
    [varargout{1:nargout}]=feval( func, varargin{:} );
else
    [varargout{1:nargout}]=func( varargin{:} );
end
