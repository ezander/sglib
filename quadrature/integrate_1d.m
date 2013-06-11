function int=integrate_1d(func, rule_func, p, varargin )
% INTEGRATE_1D Integrate a univariate function.
%    INT=INTEGRATE_1D(FUNC, RULE_FUNC, P, OPTIONS ) integrates the function
%    FUNC using the 1d integration rule RULE_FUNC using P stages. 
%
% Options:
%   vectorized: {true}, false
%      If FUNC accepts only one point at a time set this to false. This is,
%      however, slower. If set to true, which is the default, you have to
%      make sure that your code returns values dimensionally correct (see
%      also 'transposed' option). 
%   transposed: true, {false}
%      Set to true, if your code takes and returns row vectors instead of
%      column vectors.
%
% Example (<a href="matlab:run_example integrate_1d">run</a>)
%   % Compute the integral of (1,x,x^2,x^3,^4,x^5,x^6) with respect to a
%   % Gaussian measure (should give (1,0,1,0,3,0,15))
%   int =integrate_1d( @(x)(exp((0:6)'*log(x))), @gauss_hermite_rule, 4 );
%   disp('Moments of the Gaussian distribution N(0,1):' );
%   disp( round(int') );
%
% See also INTEGRATE_ND, GAUSS_HERMITE_RULE, GAUSS_LEGENDRE_RULE

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

options=varargin2options( varargin );
[vectorized,options]=get_option( options, 'vectorized', true );
[transposed,options]=get_option( options, 'transposed', false );
check_unsupported_options( options, mfilename );

% get pos and weights and make sure they are in the right shape (i.e. x is
% a row vector and w a column vector)
[x,w]=funcall(rule_func, p);
x=x(:)';
w=w(:);

if vectorized
    if ~transposed
        int=funcall(func,x)*w;
    else
        int=w'*funcall(func,x');
    end
else
    int=w(1)*funcall(func,x(1));
    for i=2:length(w)
        int=int+w(i)*funcall(func,x(i));
    end
end
