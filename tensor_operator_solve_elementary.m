function U=tensor_operator_solve_elementary( A, T )
% TENSOR_OPERATOR_SOLVE_ELEMENTARY Solves an equation with an elementary tensor operator.
%
% Example (<a href="matlab:run_example tensor_solve_elementary">run</a>)
%   % still to come
%
% See also TENSOR_APPLY

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
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
    mode={'',''};
end
if nargin<4
    options={{},{}};
end
if ~iscell(mode)
    error('tensor_solve:mode', 'mode must be given as a cell array' );
end

options={varargin2options(options{1}), varargin2options(options{2})};

U={ solve(A{1},T{1},mode{1},options{1}), solve(A{2},T{2},mode{2},options{2}) };

function U=solve( A, T, mode, options )
if isfunction(A)
    switch mode
        case {'', 'inv', 'inverse'}
            U=funcall(A,T);
        case 'pcg'
            % get options for tol, maxit, etc [] means "use default" for
            % pcg
            tol=get_option( options, 'tol', [] );
            maxit=get_option( options, 'maxit', [] );
            M1=get_option( options, 'M1', [] );
            M2=get_option( options, 'M2', [] );
            x0=get_option( options, 'x0', [] );
            check_unsupported_options( options, mfilename );
            % use options for tol, maxit, etc
            U=zeros(size(T));
            for i=1:size(T,2)
                [U(:,i),flag,relres]=pcg(@iterfunc,T(:,i),tol,maxit,M1,M2,x0,A);
                %TODO: process flag and relres
            end
        otherwise
            error( 'unknown mode' );
    end
elseif isnumeric(A)
    switch mode
        case ''
            U=A\T;
        case {'inv', 'inverse'}
            U=A*T;
        case 'chol'
            L=A;
            U=L\(L'\T);
        case 'lu'
            error( 'not yet implemented' );
        otherwise
            error( 'unknown mode' );
    end
else
    error([ 'unknown type for solve: ', class(A)]);
end

function y=iterfunc( x, A )
y=funcall( A, x );

