function print_results( variable, fields, ps_results )
% PRINT_RESULTS Short description of print_results.
%   PRINT_RESULTS Long description of print_results.
%
% Example (<a href="matlab:run_example print_results">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

variable=check_var_params( variable );
fields=check_ret_names( fields, variable );

% print the results
%fields=fieldnames(ps_results);
for i=1:length(fields)
    if ischar(fields{i})
        name=fields{i};
    else
        name=fields{i}{1};
    end
    fprintf('%s\n', name );
    disp( cell2mat(ps_results.(name)) );
end





%% copied from param_study 
% argh, copy and paste, sometimes matlab sucks too much to make it clean,
% may when i have some more time next


function s=cellarr2struct( c )
% CELLARR2STRUCT Convert a cell array to a struct
s=struct();
for i=1:length(c)
    s.(c{i}{1})=c{i}{2};
end

function c=struct2cellarr( s )
% STRUCT2CELLARR Convert a struct to a cell array
c={};
fields=fieldnames(s);
for i=1:length(fields)
    c{end+1}={fields{i}, s.(fields{i})};
end


function var_params=check_var_params( var_params )
% CHECK_VAR_PARAMS Checks and converts the var params
if iscell(var_params)
    var_params=cellarr2struct( var_params );
end
fields=fieldnames(var_params);
for i=1:length(fields)
    field=fields{i};
    value=var_params.(field);
    if ~iscell(value)
        if isnumeric( value )
            var_params.(field)=num2cell(value);
        else
            error( 'sglib:param_study', 'Can''t convert non numeric value to cell array' );
        end
    end
end

function def_params=check_def_params( def_params )
% CHECK_DEF_PARAMS Checks and converts the var params
if iscell(def_params)
    def_params=cellarr2struct( def_params );
end

function ret_names=check_ret_names( ret_names, var_params )
% CHECK_RET_NAMES Checks and converts the var params
if ~iscell(ret_names)
    ret_names=struct2cellarr( ret_names );
end
var_param_names=fieldnames(var_params);
ret_names={var_param_names{:}, ret_names{:}};
for i=1:length(ret_names)
    if ~iscell(ret_names{i})
        ret_names{i}={ret_names{i},ret_names{i}};
    end
end
