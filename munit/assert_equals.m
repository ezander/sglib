function assert_equals( actual, expected, assert_id, varargin )
% ASSERT_EQUALS Check the equality of acutal and expected values.
%   ASSERT_EQUALS( ACTUAL, EXPECTED, ASSERT_ID, OPTIONS ) checks that
%   ACTUAL and EXPECTED match in type, size and value.
%
% Note: Row and column vectors don't match. If you want them to be treated
%   as equal convert to one form.
%
% Example (<a href="matlab:run_example assert_equals">run</a>)
%   assert_equals( factorial(1:4), [1,2,6,24], 'fact', 'abstol', 0, 'reltol', 0 );
%
% See also ASSERT

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

if nargin<3
    assert_id=[];
end

curr_options=varargin2options( varargin{:} );
options=munit_options();

result_list=compare_values( actual, expected, assert_id, curr_options, options );
munit_process_assert_results( result_list, assert_id );

function result_list=compare_values( actual, expected, assert_id, curr_options, options )

result_list=compare_types( actual, expected, assert_id );
if length(result_list); return; end

result_list=compare_size( actual, expected, assert_id );
if length(result_list); return; end

result_list=compare_content( actual, expected, assert_id, curr_options, options );

%%
function result_list=compare_types( actual, expected, assert_id )
% first check if both are of the same class
result_list={};
if ~(isnumeric(actual) && isnumeric(expected) )
    if ~strcmp( class(actual), class(expected) )
        msg=sprintf( 'classes don''t match: %s~=%s', class(actual), ...
            class(expected) );
        result_list={{msg, assert_id}};
        return
    end
end

%%
function result_list=compare_size( actual, expected, assert_id )
% then check whether they have the same size
% but only if it's not of class string (then there can be a more meaningful
% message to the user)
result_list={};
if ndims(actual)~=ndims(expected) || (any( size(actual)~=size(expected) ) && ~ischar(actual))
    size_actual=print_vector( '%d', size(actual), [], iscell(actual) );
    size_expected=print_vector('%d', size(expected), [], iscell(expected) );
    msg=sprintf( 'size doesn''t match: %s~=%s', size_actual, size_expected );
    result_list={{msg, assert_id}};
    return;
end

%%
function result_list=compare_content( actual, expected, assert_id, curr_options, options )
% then do equality checking based on class
result_list={};
switch class(actual)
    case {'double', 'sparse' }
        result_list=compare_double( actual, expected, assert_id, curr_options, options );
    case 'logical'
        result_list=compare_logical( actual, expected, assert_id, curr_options, options );
    case 'char'
        result_list=compare_char( actual, expected, assert_id, curr_options, options );
    case 'struct'
        result_list=compare_struct( actual, expected, assert_id, curr_options, options );
    case 'cell'
        result_list=compare_cell( actual, expected, assert_id, curr_options, options );
    otherwise
        warning('assert_equals:unknown_class', ['don''t know how ' ...
            'to compare classes of type %s'], class(actual) );
end

%%
function result_list=compare_double( actual, expected, assert_id, curr_options, options )
% ASSERT_EQUALS_DOUBLE Assert equality for doubles.
result_list={};

% Get abstol and reltol
abstol=get_option( curr_options, 'abstol', options.abstol );
reltol=get_option( curr_options, 'reltol', options.reltol );
if ~isscalar(abstol) && any(size(abstol)~=size(actual))
    error( 'assert_equals:options', 'if abstol is a vector then it must have the same size as the value vector' );
end
if ~isscalar(reltol) && any(size(reltol)~=size(actual))
    error( 'assert_equals:options', 'if reltol is a vector then it must have the same size as the value vector' );
end

% Get the max number of assertions to confront the user with
max_assertion_disp=get_option( curr_options, 'max_assertion_disp', options.max_assertion_disp );

% Do actual comparison
comp = (abs(actual-expected)<=max(abstol,reltol.*abs(expected)));
if any(~comp(:))
    if isscalar(actual)
        msg=sprintf( 'values don''t match %g~=%g', actual, expected );
        result_list={{msg, assert_id}};
    else
        linind=find(~comp);
        if isvector(comp)
            ind=linind(:);
        else
            % here comes a bit tricky matlab cell array/matrix
            % manipulation to get the index in the form we want
            %TODO: write a small tutorial on the stupied cell handling and
            %conversion stuff in matlab
            ind=cell(1,ndims(comp));
            [ind{:}]=ind2sub(size(comp),linind);
            ind=[ind{:}];
        end
        for i=1:min(size(ind,1),max_assertion_disp+1)
            curr=ind(i,:);
            msg=sprintf( 'values don''t match at %s: %g~=%g', print_vector('%d',curr, ','), actual(linind(i)), expected(linind(i)));
            result_list{end+1}={msg, assert_id};
        end
    end
end

function result_list=compare_logical( actual, expected, assert_id, curr_options, options ) 
% ASSERT_EQUALS_LOGICAL Assert equality for logicals.
result_list={};

% Get the max number of assertions to confront the user with
max_assertion_disp=get_option( curr_options, 'max_assertion_disp', options );

% Do actual comparison
comp = (actual==expected);
if any(~comp(:))
    if isscalar(actual)
        msg=sprintf( 'values don''t match %d~=%d (logical)', actual, expected );
        result_list{end+1}={msg, assert_id};
    else
        linind=find(~comp);
        if isvector(comp)
            ind=linind(:);
        else
            % here comes a bit tricky matlab cell array/matrix
            % manipulation to get the index in the form we want
            %TODO: write a small tutorial on the stupied cell handling and
            %conversion stuff in matlab
            ind=cell(1,ndims(comp));
            [ind{:}]=ind2sub(size(comp),linind);
            ind=[ind{:}];
        end
        for i=1:min(size(ind,1),max_assertion_disp+1)
            curr=ind(i,:);
            msg=sprintf( 'values don''t match at %s: %d~=%d (logical)', print_vector('%d',curr, ','), actual(linind(i)), expected(linind(i)));
            result_list{end+1}={msg, assert_id};
        end
    end
end


%%
function result_list=compare_char( actual, expected, assert_id, curr_options, options ) %#ok
% ASSERT_EQUALS_CHAR Assert equality for strings/char arrays.
result_list={};

if ~strcmp( actual, expected)
    msg=sprintf( 'values don''t match ''%s''~=''%s''', actual, expected );
    result_list{end+1}={msg, assert_id};
end

function result_list=compare_struct( actual, expected, assert_id, curr_options, options )
% ASSERT_EQUALS_STRUCT Assert equality for structs.
result_list={};

exp_names=sort(fieldnames(expected));
act_names=sort(fieldnames(actual));
unexpected=setdiff(act_names, exp_names);
missing=setdiff(exp_names, act_names);
common=intersect(act_names, exp_names);

for i=1:length(unexpected)
    msg=sprintf( 'field ''%s'' was not expected', unexpected{i} );
    result_list{end+1}={msg, assert_id};
end
for i=1:length(missing)
    msg=sprintf( 'field ''%s'' was missing', missing{i} );
    result_list{end+1}={msg, assert_id};
end

for i=1:length(common)
    new_assert_id=sprintf('%s.%s', assert_id, common{i});
    new_list=compare_values( actual.(common{i}), expected.(common{i}), new_assert_id, curr_options, options );
    result_list={result_list{:}, new_list{:}};
end


%%
function result_list=compare_cell( actual, expected, assert_id, curr_options, options ) %#ok remove ok when implemented
% ASSERT_EQUALS_CELL Assert equality for cell arrays.
result_list={};

for i=1:numel(actual)
    new_assert_id=sprintf('%s%s', assert_id, print_vector('%g', ind2sub(i,size(actual)), ',', true) );
    new_list=compare_values( actual{i}, expected{i}, new_assert_id, curr_options, options );
    result_list={result_list{:}, new_list{:}};
end


%%
function s=print_vector( format, arr, del, cellarr )
% PRINT_VECTOR Pretty-prints a vector for display.
% S=PRINT_VECTOR( FORMAT, ARR, DEL ) pretty-prints the vector given in ARR,
% whereby every element is formatted using the code in FORMAT (e.g. '%g'
% for floats or '%d' for integers) and using DEL as delimiter between
% elements. DEL defaults to ', '.
braces='[]{}';
if nargin<3 || isempty(del)
    del=', ';
end
if nargin<4
    cellarr=false;
end
s=braces(2*cellarr+1);
for i=1:length(arr)
    s=[s sprintf(format, arr(i))];
    if i<length(arr)
        s=[s del];
    end
end
s=[s braces(2*cellarr+2)];
