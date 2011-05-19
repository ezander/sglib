function [sigma_k]=kl_solve_1d_exp(x0,x1,l,n)
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

a=0.5*(x1-x0);
c=1/l;


m=(n+1)*l;
fun1=@(w)(c-w.*tan(a*w));
w1=fsolve_mult( fun1, 0, m, 10*m );

fun2=@(w)(w+c.*tan(a*w));
w2=fsolve_mult( fun2, 0, m, 10*m );

w=sort( [w1, w2] );
w=w(1:n);
sigma_k=sqrt( 2*c./(w.^2+c^2) );


function w=fsolve_mult( fun, x0, x1, N )
%%
wc=linspace(x0,x1,N);
fs=sign(fun(wc));
sc=find(fs(2:end)+fs(1:end-1)==0); % sign changes

w=[];
opts=optimset( 'display', 'off', 'TolFun', 1e-10 );
for i=1:length(sc)
    ws=wc(sc(i)+[0,1]);
    [x,fval,flag]=fzero( fun, ws, opts ); %#ok<ASGLU>
    if flag==1
        w(end+1)=x; %#ok<AGROW>
    end
end

%%
if 1==0
    hold off;
    %wcan=(wc(mins)+wc(mins+1))*0.5;
    plot( wc, fv ); hold on;
    plot( wc(mins), 0, 'bo' )
    %plot( wcan, fun(wcan), 'ko' )
    plot( w, fun(w), 'rx' )
    ylim([-1,1])
    hold off;
end
    
