function [data,version,recomp]=load_or_recompute( ndata, compute_func, params, filename, version )
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
% Note 2: It's not possible to call FUNCALL without output argument and
%   terminating semicolon to have its output automatically displayed like
%   normal in matlab/octave. The reason is that in this the number of
%   output arguments is set to 0 by matlab/octave, causing FUNCALL to call
%   the function with the number of output args set to zero. Setting this
%   artificially to 1 would cause problems with functions that have indeed
%   no output arguments. Distinguishing these cases on the other hand would
%   require context information that is not available. Thus, the only
%   remedy is to write 'disp(funcall(...))', if the output should be
%   displayed (this sets nargout to 1, as it should be).
%   Update: there is no error message anymore, but still there is no output
%   in this case due to those difficulties.
%
% Example:
%   % calling the power function
%   funcall( {@power,{3}},2 )==8
%   funcall( {@(y,x)(power(x,y)),{3}},2 )==9
%   funcall( {@power,{3},{2}},2 )==8
%   funcall( {@power,{3},{1}},2 )==9
%
%   %call ode45 with (@times,[1,2],1) 
%   % a) positions 1 and 3 for @times and 1 are specified
%   funcall( {@ode45,{@times,1},{1,3}}, [1,2] )
%   % b) position for 1 is unspecified, so moves to the end of the
%   %    parameter list
%   funcall( {@ode45,{1}}, @times, [2,3] )
%
%   % calling an arbitrary function
%   disp( funcall( @func, a, b ) ) % calls func(a,b)
%   disp( funcall( {@func, {c,d}}, a, b ) ) % calls func(a,b,c,d)
%   disp( funcall( {@func, {c,d}, {1,4}}, a, b ) ) % calls func(c,a,b,d)
%
% 
% See also FEVAL, ISFUNCTION

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



if nargin<5
    version=1;
end


% load saved structure from file if possible
if exist( filename, 'file' ) 
    s=load( filename );
    valid=true;
    
    valid=valid && isfield(s,'version');
    valid=valid && isequal(s.version,version);
    valid=valid && isfield(s,'params');
    valid=valid && isequalwithequalnans(s.params,params);
    valid=valid && isfield(s,'data');
    if valid
        recomp=false;
        data=s.data;
        version=s.version;
        return;
    end
end

% no file or saved file didn't match (wrong version, diff parameters, ...),
% then recompute
recomp=true;
data=cell(ndata,1);
[data{:}]=funcall( func, params{:} );
if ismatlab()
	save( filename, '-V6', 'data', 'params', 'version' );
else
	save( '-mat', filename, 'data', 'params', 'version' );
end
