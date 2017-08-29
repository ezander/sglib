function str=disp_func( func, varargin )
% DISP_FUNC Convert function handle to string description.
%   STR=DISP_FUNC( FUNC ) returns the string representation of FUNC.
%   Partially supplied arguments are put at the appropriate places. 
%
% Options
%   TODO: there should be options for the naming of positional arguments,
%   number of arguments, string escaping, etc.
%
% Example (<a href="matlab:run_example disp_func">run</a>)
%    disp_func( {{@testtest, {'a', 'd', 'r'}, {3,2,5}}, {'a', 'd', 'r'}} )
%    disp_func( {@foobar, {'a', 'b'}, {1,3}})
%
% See also FUNCALL, DISP

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_num_args(nargin, 1, inf, mfilename);

options = varargin2options(varargin, mfilename);
[indent,options]=get_option(options, 'indent', false);
%[separgs,options]=get_option(options,'separgs', false);
check_unsupported_options(options);

if isempty(func)
    str='<none>';
else
    [handle,args]=collect_args( func );
    str=sprintf('%s(%s)', handle2str( handle ), args2str(args, indent));
end

if nargout==0
    disp(str);
    clear('str');
end
    

function s=handle2str( handle )
% HANDLE2STR Convert a function handle into a string.
if isa( handle, 'function_handle' )
    s=['@' func2str(handle) ];
elseif ischar(handle)
    s=handle;
else
    error( 'sglib:unknown_func_type', 'Unknown function type' );
end

function [handle,args]=collect_args( func )
% COLLECT_ARG Extract function handle and collect specified and positional arguments
[handle,arg_func]=identity_replace( func );
phs={}; for i=1:10; phs{end+1}=make_pos_arg(i); end
args=funcall( arg_func, phs{:} );

function [handle,arg_func]=identity_replace( func )
% IDENTITY_REPLACE Replaces inner function handle with the 'identity' so
% that evaluating the function gives the function's arguments. The inner
% function handle is returned separately.
if iscell(func)
    inner=func{1};
    [handle, inner]=identity_replace(inner);
    arg_func={inner, func{2:end}};
else
    handle=func;
    arg_func=@identity;
end

function out=identity( varargin )
% IDENTITY Return arguments unaltered
out=varargin;


function s=args2str( args, indent )
% ARGS2STR Convert arguments to string representation
last={};

% remove trailing specified arguments end insert into 'last' cell array
while numel(args)>0 && ~is_pos_arg(args{end})
    last=[args(end) last];
    args(end)=[];
end
% remove trailing positional arguments
while numel(args)>0 && is_pos_arg(args{end})
    args(end)=[];
end

if indent
    sep = sprintf(',\n  ');
else
    sep = ', ';
end

s='';
for i=1:length(args)
    if is_pos_arg(args{i})
        s=[s sep strvarexpand( '<arg$args{i}{1}$>', 'quotes', true )]; %#ok<AGROW>
    else
        s=[s sep strvarexpand( '$args{i}$', 'quotes', true )]; %#ok<AGROW>
    end
end

% If there are trailing arguments, put an ellipses in between
if ~isempty( last )
    s=[s ', ...'];
    for i=1:length(last)
        s=[s sep strvarexpand( '$last{i}$', 'quotes', true )]; %#ok<AGROW>
    end
end

% Cut the ', ' from the beginning of the string
if length(s)>=length(sep)
    if indent % only cut the comma, not the whole separator
        s=s(2:end);
    else
        s=s(length(sep)+1:end);
    end
end


function bool=is_pos_arg( arg )
% IS_POS_ARG Checks whether args is a positional argument
bool=iscell(arg) && numel(arg)>=2 && isequal( arg{2}, @pos_arg_tag );

function arg=make_pos_arg( n )
% MAKE_POS_ARG Create positional argument number N
arg={n,@pos_arg_tag};

function pos_arg_tag
% POS_ARG_TAG This functions is a just a unique tags for positional arguments
