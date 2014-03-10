function [xn, flag, info]=fzero_ridders(func, xa, xb, varargin)
% FZERO_RIDDERS Find a zero of a continuous function by Ridders' method.
%   [XN, FLAG, INFO]=FZERO_RIDDERS(FUNC, XA, XB, VARARGIN) finds a zero of
%   the function FUNC in the interval [XA,XB]. XA and XB must  bracket a
%   zero of FUNC, i.e. FUNC(XA) and FUNC(XB) must differ in sign.
%
% Options
%   d: []
%     If this function is used to find the minimum along a search
%     direction, this option can be used to specify the search direction.
%     The actual value to minimise is taken to be the inner product between
%     D and FUNC(X), compute by the function tensor_scalar_product. The
%     value of FUNC is returned in INFO.GVAL.
%   maxiter: int, {100}
%     Maximum number of iterations.
%   abstol: double, {1e-8}
%     Absolute tolerance on the function value.
%   reltol: double, {1e-8}
%     Relative tolerance on the function value.
%   verbosity: intm  {0}
%     If larger zero, debugging output is displayed.
%
% References
%    [1] Ridders, C. (1979). "A new algorithm for computing a single root
%        of a real continuous function". IEEE Transactions on Circuits and
%        Systems 26: 979–980. doi:10.1109/TCS.1979.1084580
%
% Example (<a href="matlab:run_example fzero_ridders">run</a>)
%    % Find only the zero of the second component (d=[0,1])
%    func = @(x)([x^3-x-5; sin(x*pi/1.8)]);
%    xa = 1.5; xb = 2.5;
%    [x, flag, info]=fzero_ridders(func, xa, xb, 'd', [0;1]);
%    strvarexpand('iter=$info.iter$, x=$x$, fval=$info.fval$, gval=$info.gval''$')
%
% See also FZERO_ILLINOIS, TENSOR_SCALAR_PRODUCT

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin, mfilename);
[maxiter,options]=get_option(options, 'maxiter', 100);
[abstol,options]=get_option(options, 'abstol', 1e-8);
[reltol,options]=get_option(options, 'reltol', 1e-8);
[verbosity,options]=get_option(options, 'verbosity', 0);
[d,options]=get_option(options, 'd', []);
[fa,options]=get_option(options, 'fa', []);
[fb,options]=get_option(options, 'fb', []);
check_unsupported_options(options);


funccount = 0;

if isempty(fa)
    fa = evaluate(func, xa, d);
    funccount = funccount + 1;
end
if isempty(fb)
    fb = evaluate(func, xb, d);
    funccount = funccount + 1;
end
assert(sign(fa)~=sign(fb), 'Function must have different sign at xa and xb');

xm = 0.5*(xa+xb);
fm = evaluate(func, xm, d);
funccount = funccount + 1;


flag=1;
tol = abstol + reltol*0.5*(fa+fb);
for iter=1:maxiter
    w = fm^2 - fa * fb;
    dx = (xb - xm);
    xn = xm + sign(fa) * fm * dx / sqrt(w);
 
    xn2 = xm + dx * (fm/fa) / sqrt((fm/fa)^2 - fb/fa);
    assert(abs(xn-xn2)<1e-12);
    
    [fn, gn] = evaluate(func, xn, d);
    funccount = funccount + 1;
    if abs(fn)<tol
        flag=0;
        break;
    end
    
    if sign(fm)~=sign(fn)
        xa = xm;
        fa = fm;
        xb = xn;
        fb = fn;
    elseif sign(fa)~=sign(fn)
        xb = xn;
        fb = fn;
    else
        xa = xn;
        fa = fn;
    end
    assert(sign(fa)~=sign(fb));
    
    xm = 0.5*(xa+xb);
    fm = evaluate(func, xm, d);
    funccount = funccount + 1;
    
    if verbosity>0
        fprintf('%3d  %10.7f  %8.5f \n', iter, xn, fn);
    end
end

info.flag = flag;
info.method = mfilename;
info.iter = iter;
info.maxiter = maxiter;
info.fval = fn;
info.gval = gn;
info.reltol = tol;
info.relres = abs(fn)/tol;
info.funccount = funccount;

if flag && nargout<2
    tensor_solver_message(info);
end


function [f, g] = evaluate(func, x, d)
g = funcall(func, x);
if isempty(d)
    f = g;
else
    f = tensor_scalar_product(g, d);
end
