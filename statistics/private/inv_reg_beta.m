function x=inv_reg_beta( y, a, b )
% INV_REG_BETA Compute the inverse regularized beta function.
%   X=INV_REG_BETA( Y, ALPHA, BETA ) computes the inverse regularized beta
%   function which is used for the transformation of normally distributed
%   random variables to beta distributed one. Y can be a vector and has to
%   be in the range [0,1].
%
% Note
%   If A or B are smaller than one the derivative of the betainc function
%   has singularities at zero and one. If Y is very close to one of those
%   singularities the algorithm might not converge or does so very slowly.
%
% Example (<a href="matlab:run_example inv_reg_beta">run</a>)
%   y=linspace(0,1);
%   x=inv_reg_beta( y, 4, 2 );
%   plot(x,y);
%
% See also BETA_STDNOR

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


% Compute the inverse regularized beta function for many
% values of Y using a vectorized Newton.
% Solve I_x(a,b)=B_x(a,b)/B(a,b)=y
% B_x(a,b)=y*B(a,b)=z
% B_x=int_0^x t^(a-1) (1-t)^(b-1) dt

%TODO: If there are singularities it should be possible to make an
%analytical approximation to betainc since its the integral of a hyperbola
%which we can integrate directly. Another way could be to transform the
%equation by taking powers which would remove the singularities.

% Do interpolation for the starting values if a large set of values is
% specified. This makes Newton converge much faster.
no_interp_limit=100;
if length(y)<=no_interp_limit
    x=y;
else
    % compute values over range
    y_min = min(y);
    y_max = max(y);
    if y_min==y_max
        % sometimes the input consists of just one value and the
        % interpolation below would faile
        xi=inv_reg_beta( y(1), a, b );
        x=repmat(xi, size(y));
    else
        yi=linspace(y_min, y_max, no_interp_limit);
        xi=inv_reg_beta( yi, a, b );
        % remove all nan's (shouldn't appear anyway)
        notnan=~isnan(xi);
        xi=xi(notnan); yi=yi(notnan);
        % interpolate now
        x=interp1( yi, xi, y, 'pchip', NaN );
        x(x>1)=1;
        x(x<0)=0;
    end
end

% We need that often
bab=beta(a,b);
if bab==0
    error( 'util:inv_reg_beta:too_large', 'Input parameters too large' );
end

% x0 and x1 are used for bracketing the solution
x0=zeros(size(y));
x1=ones(size(y));

% Solve B_x(a,b)=z with Newton-Raphson plus bracketing
% with bisection. 'ok' contains the values for which the algorithm has
% already converged.
dBx=zeros(size(x));
Bx=betainc(x,a,b);
ok=(x0==x1); % ok should false for all in the first step
ok=ok | (Bx==y);
num_it=0;
while ~all(ok)
    num_it=num_it+1;
    if num_it>100
        %TODO: improve method and turn warning back on
        %warning('inv_reg_beta:no_conv', 'inv_reg_beta did not converge for all values. returning nan' );
        %x(notok)=nan;
        break;
    end

    % check whether some have converged
    notok=~ok;

    dBx(notok)=x(notok).^(a-1).*(1-x(notok)).^(b-1)/bab;
    % Newton x_(n+1)=x_n - B_x/(dB_x/dx)
    x(notok)=x(notok)-(Bx(notok)-y(notok))./dBx(notok);

    % check bounds
    ind=notok & ((x<x0) | (x>x1) | isnan(x));
    if num_it>40 && mod(num_it,2)==0
        % it it took us more than fifty iterations so far we switch to a
        % bisection method
        ind=notok;
    end
    x(ind)=(x0(ind)+x1(ind))/2;

    % Matlab computes here the *regularized* incomplete beta function
    Bx(notok)=betainc(x(notok),a,b);
    ind=(Bx-y<0);
    x0(ind&notok)=x(ind&notok);
    x1(~ind&notok)=x(~ind&notok);

    ok=ok | abs(y-Bx)<1e-10;
    %fprintf( '%d: %d %d\n', num_it, sum(ok), length(find(ind1)) );
end

