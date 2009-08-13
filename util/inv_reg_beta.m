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
%   $Id$
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
    yi=linspace(min(y), max(y), no_interp_limit);
    xi=inv_reg_beta( yi, a, b );
    % remove all nan's (shouldn't appear anyway)
    notnan=~isnan(xi);
    xi=xi(notnan); yi=yi(notnan);
    % interpolate and again remove nans is necessary
    x=interp1( yi, xi, y, 'cubic', NaN );
    nanind=isnan(x);
    if any(nanind)
        x(nanind)=y(nanind);
    end
    x(x>1)=1;
    x(x<0)=0;
end

% We need that often
bab=beta(a,b);

% if a<1/2
%     ind=(x<0.01);
%     x(ind)=(bab*a*y(ind)).^(1/a);
% end
% if b<1/2
%     ind=(x>0.99);
%     x(ind)=1-(bab*b*(1-y(ind))).^(1/b);
% end

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




%TODO: maybe we should try this one (from gsl)
% /*
%  * Invert the Beta distribution.
%  *
%  * References:
%  *
%  * Roger W. Abernathy and Robert P. Smith. "Applying Series Expansion
%  * to the Inverse Beta Distribution to Find Percentiles of the
%  * F-Distribution," ACM Transactions on Mathematical Software, volume
%  * 19, number 4, December 1993, pages 474-480.
%  *
%  * G.W. Hill and A.W. Davis. "Generalized asymptotic expansions of a
%  * Cornish-Fisher type," Annals of Mathematical Statistics, volume 39,
%  * number 8, August 1968, pages 1264-1273.
%  */
%
% #include <config.h>
% #include <math.h>
% #include <gsl/gsl_math.h>
% #include <gsl/gsl_errno.h>
% #include <gsl/gsl_sf_gamma.h>
% #include <gsl/gsl_cdf.h>
% #include <gsl/gsl_randist.h>
%
% #include "error.h"
%
% double
% gsl_cdf_beta_Pinv (const double P, const double a, const double b)
% {
%   double x, mean;
%
%   if (P < 0.0 || P > 1.0)
%     {
%       CDF_ERROR ("P must be in range 0 < P < 1", GSL_EDOM);
%     }
%
%   if (a < 0.0)
%     {
%       CDF_ERROR ("a < 0", GSL_EDOM);
%     }
%
%   if (b < 0.0)
%     {
%       CDF_ERROR ("b < 0", GSL_EDOM);
%     }
%
%   if (P == 0.0)
%     {
%       return 0.0;
%     }
%
%   if (P == 1.0)
%     {
%       return 1.0;
%     }
%
%   if (P > 0.5)
%     {
%       return gsl_cdf_beta_Qinv (1 - P, a, b);
%     }
%
%   mean = a / (a + b);
%
%   if (P < 0.1)
%     {
%       /* small x */
%
%       double lg_ab = gsl_sf_lngamma (a + b);
%       double lg_a = gsl_sf_lngamma (a);
%       double lg_b = gsl_sf_lngamma (b);
%
%       double lx = (log (a) + lg_a + lg_b - lg_ab + log (P)) / a;
%       x = exp (lx);             /* first approximation */
%       x *= pow (1 - x, -(b - 1) / a);   /* second approximation */
%
%       if (x > mean)
%         x = mean;
%     }
%   else
%     {
%       /* Use expected value as first guess */
%       x = mean;
%     }
%
%   {
%     double lambda, dP, phi;
%     unsigned int n = 0;
%
%   start:
%     dP = P - gsl_cdf_beta_P (x, a, b);
%     phi = gsl_ran_beta_pdf (x, a, b);
%
%     if (dP == 0.0 || n++ > 64)
%       goto end;
%
%     lambda = dP / GSL_MAX (2 * fabs (dP / x), phi);
%
%     {
%       double step0 = lambda;
%       double step1 = -((a - 1) / x - (b - 1) / (1 - x)) * lambda * lambda / 2;
%
%       double step = step0;
%
%       if (fabs (step1) < fabs (step0))
%         {
%           step += step1;
%         }
%       else
%         {
%           /* scale back step to a reasonable size when too large */
%           step *= 2 * fabs (step0 / step1);
%         };
%
%       if (x + step > 0 && x + step < 1)
%         {
%           x += step;
%         }
%       else
%         {
%           x = sqrt (x) * sqrt (mean);   /* try a new starting point */
%         }
%
%       if (fabs (step0) > 1e-10 * x)
%         goto start;
%     }
%
%   end:
%     return x;
%
%   }
% }
