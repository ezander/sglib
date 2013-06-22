function info=process_param( param, info, stringify )
% PROCESS_PARAM Short description of process_param.
%   PROCESS_PARAM Long description of process_param.
%
% Example (<a href="matlab:run_example process_param">run</a>)
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

if nargin<2 || isempty(info)
    info=struct();
end

if ~isfield(info,'base' ); info.base=''; end
if ~isfield(info,'params' ); info.params={}; end
if ~isfield(info,'values' ); info.values={}; end

try
    value=evalin( 'caller', param );
catch
    error( 'process_param:not_specified', 'Parameter %s not specified', param );
end

info.params={info.params{:}, param };
info.values={info.values{:}, value };

if ~exist('stringify', 'var')
    stringify='';
    if isfield( info, 'param_str_map' )
        param_str_map=info.param_str_map;
        for i=1:size(param_str_map,1)
            if strcmp(param_str_map{i,1}, param )
                stringify=param_str_map{i,2};
                break;
            end
        end
    end
end

if ~isempty(stringify)
    strval=strvarexpand(stringify);
    strval=strrep( strval, '.', '_' );
    if isempty(info.base)
        info.base=[info.base, strval];
    else
        info.base=[info.base, '-', strval];
    end
end
