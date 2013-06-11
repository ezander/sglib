function ok=check_matrix( x, matcond, emptyok, varname, mfilename, varargin )
% CHECK_MATRIX Check whether input is a matrix with certain properties.
%
%   Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example (<a href="matlab:run_example check_condition">run</a>)
%     A=[1, 2; 3, 4]; B=eye(2);
%     options=struct( 'mode', 'print' );
%     %pass
%     check_matrix( A, 'square', true, 'A', mfilename, options );
%     check_matrix( A, {'square', 'real'}, true, 'A', mfilename, options );
%     check_matrix( B, {'diagonal', 'hermitian', 'triangular', 'projection'}, true, 'B', mfilename, options );
%     disp( 'No warning should have appeared until now. But now they come...');
%     %disp( 'Press enter to continue' ); pause;
%
%     %fail
%     check_matrix( A, {'diagonal', 'hermitian', 'triangular', 'projection'}, true, 'B', mfilename, options );
%     check_matrix( B, {'hermitian', 'sparse', 'singular'}, true, 'B', mfilename, options );
%     check_matrix( sparse(B), 'full', true, 'B', mfilename, options );
%
% See also CHECK_RANGE, CHECK_UNSUPPORTED_OPTIONS

%   Elmar Zander
%   Copyright 2007, 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[mode,options]=get_option( options, 'mode', 'debug' );
check_unsupported_options( options, mfilename );


if emptyok
    emptystr='empty or ';
else
    emptystr='';
end

if ~iscell(matcond)
    matcond={matcond};
end

all_ok=true;
for i=1:length(matcond)
    empty=isempty(x);
    ok=true;
    ok=ok&&(emptyok||~empty);
    ok=ok&&(empty||test_feature(matcond{i},x));
    if ~ok
        message=sprintf( 'matrix %s must be %s%s', varname, emptystr, matcond{i});
        check_boolean( ok, message, mfilename, 'depth', 2, 'mode', mode );
        all_ok=false;
    end
end


if nargout==0
    clear ok;
else
    ok=all_ok;
end


function hasit=test_feature( feature, M )
I=eye(size(M));
switch feature
    case {'square', 'quadratic'}
        hasit=size(M,1)==size(M,2);
    case 'real'
        hasit=compare(imag(M),0);
    case 'sparse'
        hasit=issparse(M);
    case 'full'
        hasit=~issparse(M);
    case 'singular'
        hasit=condest(M)>1e14;
    case 'regular'
        hasit=condest(M)<1e14;
    case 'hermitian'
        hasit=compare(M,M');
    case 'symmetric'
        hasit=compare(M,M.');
    case 'normal'
        hasit=compare(M*M',M'*M);
    case 'idempotent'
        hasit=compare(M*M,M);
    case 'unitary'
        hasit=compare(M'*M,I);
    case 'orthogonal'
        hasit=compare(M.'*M,I);
    case 'involutory'
        hasit=compare(M*M,I);
    case {'projector', 'projection'}
        idempotent=compare(M*M,M);
        hermitian=compare(M,M');
        hasit=idempotent&&hermitian;
    case 'diagonal'
        hasit=compare(diag(diag(M)),M);
    case 'upper_triangular'
        hasit=compare(triu(M),M);
    case 'lower_triangular'
        hasit=compare(tril(M),M);
    case 'triangular'
        hasit=compare(tril(M),M) || compare(triu(M),M);
end

function eq=compare( M1, M2 )
abstol=1e-14;
reltol=1e-14;
tol=max(reltol*norm(abs(M1)+abs(M2),'fro'),abstol);
eq = all(all( abs(M1-M2) < tol ));


