function h=hermite( n, all_polys )
% HERMITE  Return the n-th Hermite polynomial.
%   H=HERMITE(N) with n integer and non-negative returns the n-th
%   (probabilistic) Hermite polynomial H_i(x). The returned polynomials is
%   not normalized so that <H_i H_j>=i! delta_ij, where <.> denotes the
%   expected value with respect to the Gauss measure exp(-x^2/2)/sqrt(2*pi).
%   The algoritm uses the three term recurrence
%      $$H_{n+1}(x) = x H_n - n H_{n-1}$$
%   with H_0=1 and H_1=x. The returned polynomial uses the standard matlab
%   representation of polynomials where the first element corresponds to the
%   highest power of x and the last element to the constant. E.g.
%   hermite(4) returns [1,0,-6,0,3] which means x^4-6*x^2+3. Polynomials of
%   this kind can be easily manipulated and evaluated in Matlab using the
%   functions polyint (integration), polyder (derivatives), conv
%   (multiplication) and polyval (evaluation).
%
%   H=HERMITE(N,TRUE) returns all Hermite polynomials up to degree N.
%
% Example (<a href="matlab:run_example hermite">run</a>)
%   h1=hermite( 1 ); format_poly( h1 );
%   h2=hermite( 2 ); format_poly( h2 );
%   h3=hermite( 3 ); format_poly( h3 );
%   h4=hermite( 4 ); format_poly( h4 );
%   x=linspace(-1,1);
%   plot(x,polyval(h1,x),x,polyval(h2,x),x,polyval(h3,x),x,polyval(h4,x));
%
% See also HERMITE_VAL, FORMAT_POLY

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if n==0
    h=1;
    return;
end

if nargin<2 || ~all_polys
    % Compute just a single polynomial of degree n
    p=1;
    q=[1 0];
    for i=1:n-1;
        % The following code line implements the Hermite recurrence
        % relation
        %   H_{n+1} = x H_n(x) - n H_{n-1}
        [q,p]=deal([q 0]-i*[0 0 p],q);
    end
    h=q;
else
    % Compute all polynomials up to degree n
    h=zeros(n+1,n+1);
    % H_0 = 1
    h(1,end)=1;
    % H_1 = x
    h(2,end-1)=1;
    for i=2:n
        % The following code line implements the Hermite recurrence
        % relation
        %   H_{n+1} = x H_n(x) - n H_{n-1}
        h(i+1,:)=[h(i,2:end) 0] - (i-1)*h(i-1,:);
    end
end
