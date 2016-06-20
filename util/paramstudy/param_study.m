function s=param_study( script, var_params, def_params, ret_names, varargin )
% PARAM_STUDY Simplifies and speeds up doing parameter studies of algorithms.
%   S=PARAM_STUDY( SCRIPT, VAR_PARAMS, DEF_PARAMS, RET_NAMES, OPTIONS )
%   does a parameter study running SCRIPT for every combination of
%   parameters given in VAR_PARAMS. DEF_PARAMS are constant parameters set
%   each time before running the script, and RET_NAMES contains the names
%   or expressions that shall be returned. Details:
%
%   VAR_PARAMS: is a struct where each field indicates a parameter.
%       The value of the field must be a cell array containing the
%       possible parameters values. Ordering of the struct is important, as
%       the output values are returned as cell arrays, whose n-th dimension
%       corresponds to the n-th struct field.
%   DEF_PARAMS: a struct where again each field indicats a parameter,
%       whose value is directly contained as field value. 
%   RET_NAMES: is a struct where each field contains an expression that is
%       to be evaluated after each run of the script. In the return value S
%       a corresponding field will be created, which will contain a cell
%       array with all computed field values. 
%
%   Note 1: All structs can also be passed as cell arrays of cell array, with
%       each inner cell array consisting of a name value pair.
%   
%   Note 2: PARAM_STUDY makes all evaluations in the BASE  workspace and
%       thus messes it up. Therefore it is usually not a good idea to call
%       it from a script, better call it from a function. If the call stack
%       is empty, PARAM_STUDY will raise an error.
%
% Example (<a href="matlab:run_example param_study">run</a>)
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

options=varargin2options(varargin);
[cache,options]=get_option( options, 'cache', true );
[cache_file,options]=get_option( options, 'cache_file', '' );
[cache_partial,options]=get_option( options, 'cache_partial', true );
[verbosity,options]=get_option( options, 'verbosity', 1 );
check_unsupported_options(options,mfilename);

% check that we are not directly called from the base workspace called 
assignin( 'base', 'xyz', 'nononever' );
try
    xyz=evalin( 'caller', 'xyz' );
catch
    xyz='';
end
if strcmp( xyz, 'nononever' )
    error( 'sglib:param_study', 'param_study must be called from a function, not from a script! See help.' )
end

% check and canonify the input parameters
var_params=check_var_params( var_params );
def_params=check_def_params( def_params );
ret_names=check_ret_names( ret_names, var_params );

if cache && isempty(cache_file)
    cache_file=generate_cache_filename( script, {var_params, def_params, ret_names} );
end

% here comes the main work 
if cache
    s=cached_funcall( @param_study_internal, {script, var_params, def_params, ret_names}, ...
        1, cache_file, 1, ...
        'verbosity', verbosity, 'extra_params', {verbosity, cache_partial} );
else
    s=param_study_internal( script, var_params, def_params, ret_names, verbosity, cache_partial );
end

% check that variable parameters are in correct position
% check_result_params( s, var_params );


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


function s=param_study_internal( script, var_params, def_params, ret_names, verbosity, cache_partial )

% parameter looping stuff
% what we get here is: the names of all variables parameters, for each
% variable param the number of different values, and the total number of
% different parameter combinations
var_param_names=fieldnames(var_params);
n_var_params=size(var_param_names,1);
max_ind=reshape( cellfun('length',struct2cell(var_params)), 1, []);
num_ind=prod(max_ind);

% initialize the struct for return return values
for i=1:length(ret_names)
    name=ret_names{i};
    s.(name{1})=cell([max_ind, 1]); % [,1] necessary, if only one var param
end

% initialize vars for the parameter loop
params=def_params;
param_names=reshape(fieldnames(params),1,[]);
param_names=union(param_names,var_param_names);
ind=ones(1,n_var_params);

% do the parameter loop
for n=1:num_ind
    % get current parameters
    for i=1:n_var_params
        params.(var_param_names{i})=var_params.(var_param_names{i}){ind(i)};
    end
    
    % Clear base workspace and set all input params ther
    assign='';
    evalin( 'base', 'clear' );
    for i=1:length(param_names)
        name=param_names{i};
        assign=[assign strvarexpand('$name$=$params.(name)$, ')];
        assignin( 'base', name, params.(name) );
    end
    if verbosity>0
        fprintf('Param study: %d/%d', n, num_ind );
        fprintf(' {%s}\n', assign(1:end-2) );
    end

    filename='';
    if cache_partial
        filename=generate_cache_filename( script, params );
    end
    
    if ~isempty(filename) && exist([filename '.mat'],'file' )
        if verbosity>0
            fprintf( ' => loading: %s\n', filename );
        end
        evalin( 'base', ['load ' filename] );
    else
        % Now evaluate the script in base workspace
        evalin( 'base', script );
        if ~isempty(filename)
            makesavepath( filename );
            evalin( 'base', ['save ' filename] );
        end
    end
    
    % Lastly, retrieve return values from base workspace
    for i=1:length(ret_names)
        name=ret_names{i};
        try
            value=evalin('base', name{2} );
        catch
            msg=lasterr;
            warning( 'sglib:param_study', 'could not evaluate: %s (%s)', name{2}, msg );
            value=nan;
        end
        s.(name{1}){n}=value;
    end
    
    % compute next index 
    for k=1:n_var_params
        ind(k)=ind(k)+1;
        if ind(k)<=max_ind(k); break; end
        ind(k)=1;
    end
end


function check_result_params( ps_results, var_params )
var_param_names=fieldnames(var_params);
n_var_params=size(var_param_names,1);

for i=1:n_var_params
    in_params=cell2mat(var_params.(var_param_names{i}));
    in_params=shiftdim( in_params(:), -(i-1) );
    out_params=cell2mat(ps_results.(var_param_names{i}));
    res=binfun( @eq, out_params, in_params );
    if ~all(res(:))
        error('param_study:var_params', 'mismatch between input and output variable parameters' );
    end
end

