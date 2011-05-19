function [sigma_k]=kl_solve_1d_exp(a,c,m)
% KL_SOLVE_1D_EXP Solve the 1D KL problem for the exponential covariance.
%   KL_SOLVE_1D_EXP Long description of kl_solve_1d_exp.
%
% Example (<a href="matlab:run_example kl_solve_1d_exp">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

%c=1;
%a=1;

fun1=@(w)(c-w.*tan(a*w));
w1=fsolve_mult( fun1, 0, m );

fun2=@(w)(w+c.*tan(a*w));
w2=fsolve_mult( fun2, 0, m );

w=sort( [w1, w2] );
sigma_k=sqrt( 2*c./(w.^2+c^2) );
%lam=sig.^2

if false
    plot(sig); hold all
    plot(lam)
    plot(cumsum(lam))
    hold off
    sum(sig.^2)
end

function w=fsolve_mult( fun, x0, x1 )
%%
wc=linspace(x0,x1,1000);
fv=fun(wc);
fs=sign(fv);
mins=find(fs(2:end)+fs(1:end-1)==0);

for i=1:length(mins)
    w0=wc(mins(i));
    w1=wc(mins(i)+1);
    opts=optimset( 'display', 'off', 'TolFun', 1e-10 );
    [x,fval,flag]=fzero( fun, [w0; w1], opts );
    [w0, w1, x]
    w(i)=x;
end

%%
if true
    hold off;
    wcan=(wc(mins)+wc(mins+1))*0.5;
    plot( wc, fv ); hold on;
    plot( wc(mins), 0, 'bo' )
    %plot( wcan, fun(wcan), 'ko' )
    plot( w, fun(w), 'rx' )
    ylim([-1,1])
    hold off;
end
    
