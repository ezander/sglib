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


%TODO: write more docu, with more examples
%TODO: document the options

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
    size_actual=print_vector( '%d', size(actual) );
    size_expected=print_vector('%d', size(expected) );
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
        compare_logical( actual, expected, assert_id, curr_options, options );
    case 'char'
        compare_char( actual, expected, assert_id, curr_options, options );
    case 'struct'
        compare_struct( actual, expected, assert_id, curr_options, options );
    case 'cell'
        compare_cell( actual, expected, assert_id, curr_options, options );
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
    elseif false && isvector(actual) && length(actual)<=4
        % I think this kind of output isn't so helpful?!
        msg=sprintf( 'values don''t match %s~=%s', print_vector('%g', actual), print_vector('%g', expected) );
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
            ind=cell(1,length(size(comp)));
            [ind{:}]=ind2sub(size(comp),linind);
            ind=[ind{:}];
        end
        curr_options.no_step=false;
        for i=1:min(size(ind,1),max_assertion_disp+1)
            curr=ind(i,:);
            msg=sprintf( 'values don''t match at %s: %f~=%f', print_vector('%d',curr, ','), actual(linind(i)), expected(linind(i)));
            result_list{end+1}={{msg, assert_id}};
            assert( false, msg, assert_id, curr_options );
            curr_options.no_step=true;
        end
    end
end


function compare_cell( actual, expected, assert_id, curr_options, options ) %#ok remove ok when implemented
% ASSERT_EQUALS_CELL Assert equality for cell arrays.
%TODO: very crude implementation for cell arrays
for i=1:size(actual,1)
    for j=1:size(actual,2)
        assert_equals( actual{i,j}, expected{i,j}, sprintf('%s{%d,%d}', assert_id, i, j), curr_options, options );
        curr_options.no_step=true;
    end
end

function compare_struct( actual, expected, assert_id, curr_options, options )
% ASSERT_EQUALS_STRUCT Assert equality for structs.
%TODO: very crude implementation for structs 
exp_names=sort(fieldnames(expected));
act_names=sort(fieldnames(actual));
compare_cell( act_names, exp_names, assert_id, curr_options, options )
for i=1:numel(exp_names)
    assert_equals( actual.(exp_names{i}), expected.(exp_names{i}), sprintf('%s.%s', assert_id, exp_names{i}), curr_options, options );
    curr_options.no_step=true;
end

%%
function compare_logical( actual, expected, assert_id, curr_options, options ) %#ok remove ok when implemented
% ASSERT_EQUALS_LOGICAL Assert equality for logicals.

% Get the max number of assertions to confront the user with
max_assertion_disp=get_option( curr_options, 'max_assertion_disp', options );

% Do actual comparison
comp = (actual==expected);
if any(~comp(:))
    if isscalar(actual)
        msg=sprintf( 'values don''t match %d~=%d (logical)', actual, expected );
        munit_assert_failed( msg, assert_id);
    elseif false && isvector(actual) && length(actual)<=4
        % I think this kind of output isn't so helpful?!
        msg=sprintf( 'values don''t match %s~=%s (logical)', print_vector('%d', actual), print_vector('%d', expected) );
        munit_assert_failed( msg, assert_id);
    else
        linind=find(~comp);
        if isvector(comp)
            ind=linind(:);
        else
            % here comes a bit tricky matlab cell array/matrix
            % manipulation to get the index in the form we want
            %TODO: write a small tutorial on the stupied cell handling and
            %conversion stuff in matlab
            ind=cell(1,length(size(comp)));
            [ind{:}]=ind2sub(size(comp),linind);
            ind=[ind{:}];
        end
        curr_options.no_step=false;
        for i=1:min(size(ind,1),max_assertion_disp)
            curr=ind(i,:);
            msg=sprintf( 'values don''t match at %s: %d~=%d (logical)', print_vector('%d',curr, ','), actual(linind(i)), expected(linind(i)));
            assert( false, msg, assert_id, curr_options );
            curr_options.no_step=true;
        end
        if size(ind,1)>max_assertion_disp
            msg='... further output suppressed ...';
            assert( false, msg, assert_id, curr_options );
        end
    end
else
    assert( true, [], assert_id );
end

%%
function compare_char( actual, expected, assert_id, curr_options, options )
% ASSERT_EQUALS_CHAR Assert equality for strings/char arrays.

if ~strcmp( actual, expected)
    msg=sprintf( 'values don''t match ''%s''~=''%s''', actual, expected );
    munit_assert_failed( msg, assert_id );
else
    munit_assert_passed( assert_id );
end

%%
function s=print_vector( format, arr, del )
% PRINT_VECTOR Pretty-prints a vector for display.
% S=PRINT_VECTOR( FORMAT, ARR, DEL ) pretty-prints the vector given in ARR,
% whereby every element is formatted using the code in FORMAT (e.g. '%g'
% for floats or '%d' for integers) and using DEL as delimiter between
% elements. DEL defaults to ', '.

if nargin<3
    del=', ';
end
s='[';
for i=1:length(arr)
    s=[s sprintf(format, arr(i))];
    if i<length(arr)
        s=[s del];
    end
end
s=[s ']'];
