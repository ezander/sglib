function assert_matrix( A, properties, assert_id, varargin )
% ASSERT_MATRIX Short description of assert_matrix.
%   ASSERT_MATRIX Long description of assert_matrix.
%
% Example (<a href="matlab:run_example assert_matrix">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[abstol,options]=get_option( options, 'abstol', munit_options( 'get', 'abstol' ) );
[reltol,options]=get_option( options, 'reltol', munit_options( 'get', 'reltol' ) );
[exact,options]=get_option( options, 'exact', false );
check_unsupported_options(options,mfilename);

if nargin<3
    assert_id = [];
end

if ischar(properties)
    properties={properties};
end

if exact
    abstol=0;
    reltol=0;
end

result_list={};
for i=1:length(properties)
    property=properties{i};
    switch property
        case 'square'; h=@issquare;
        case 'sparse'; h=@issparse;
        case 'full'; h=@isfull;
        case 'real'; h=@isreal;
        case 'symmetric'; h={@issymmetric, {abstol,reltol}};
        case 'hermitian'; h={@ishermitian, {abstol,reltol}};
        case 'unitary'; h={@isunitary, {abstol,reltol}};
        case 'orthogonal'; h={@isorthogonal, {abstol,reltol}};
        case 'diagonal'; h={@isdiagonal, {abstol,reltol}};
        case 'identity'; h={@isidentity, {abstol,reltol}};
        case 'lower triangular'; h={@islowertri, {abstol,reltol}};
        case 'upper triangular'; h={@isuppertri, {abstol,reltol}};
        otherwise
            error( 'sglib:assert_matrix', 'Unknown matrix property: %s', property );
    end
    
    if ~funcall(h,A)
        msg=sprintf('matrix is not %s', property );
        result_list{end+1}={msg, assert_id}; %#ok<AGROW>
    end
end
munit_process_assert_results( result_list, assert_id );


function bool=issquare( A )
[m,n]=size(A);
bool=m==n;

function bool=isfull( A )
bool=~issparse(A);

function bool=issymmetric( A, abstol, reltol )
tol=max(abstol,reltol*max(abs(A(:))));
bool=issame( A, A.', tol );

function bool=ishermitian( A, abstol, reltol )
tol=max(abstol,reltol*max(abs(A(:))));
bool=issame( A, A', tol );

function bool=isunitary( A, abstol, reltol )
bool=isidentity( A'*A, abstol, reltol );

function bool=isorthogonal( A, abstol, reltol )
bool=isidentity( A.'*A, abstol, reltol );

function bool=isdiagonal( A, abstol, reltol )
tol=max(abstol,reltol*max(abs(A(:))));
bool=issame( A, diag(diag(A)), tol );

function bool=isidentity( A, abstol, reltol )
tol=max(abstol,reltol);
bool=issame( A, speye(size(A)), tol );

function bool=isuppertri( A, abstol, reltol )
tol=max(abstol,reltol*max(abs(A(:))));
bool=issame( A, triu(A), tol );

function bool=islowertri( A, abstol, reltol )
tol=max(abstol,reltol*max(abs(A(:))));
bool=issame( A, tril(A), tol );



function bool=issame( A, B, tol )
bool=max(abs(A(:)-B(:)))<=tol;

