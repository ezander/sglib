function int=gpc_integrate(func, V, p, varargin)
% GPC_INTEGRATE Short description of gpc_integrate.
%   GPC_INTEGRATE Long description of gpc_integrate.
%
% Example 1: (<a href="matlab:run_example gpc_integrate 1">run</a>)
%   I_a = multiindex(3,4);
%   a_i_alpha = rand(10, size(I_a, 1));
%   gpc_integrate(@(x,a)(a), {'h',I_a}, 5, 'gpc_coeffs', a_i_alpha)
%
%   gpc_integrate(@(x)(sin(x(1)+x(2))), {'hl',[0,0]}, 5, 'grid', 'smolyak', 'vectorized', false)
%   gpc_integrate(@(x)(sin(x(1,:)+x(2,:))), {'hl',[0,0]}, 5, 'grid', 'smolyak')
%   reshape(gpc_integrate(@(x)([ones(size(x)); x; x.^2; x.^3; x.^4; x.^5; x.^6]), {'phltu',[0,0,0,0,0]}, 5, 'grid', 'smolyak'),5,7)
%   %xw = gpc_integrate([], {'h',[0,0]}, 5, 'grid', 'smolyak');
%   %xw{1}
%   %xw{2}
%
% Example 2: (<a href="matlab:run_example gpc_integrate 2">run</a>)
%   subplot(2,2,1);
%   xw = gpc_integrate([], {'h',[0,0]}, 5, 'grid', 'smolyak');
%   plot(xw{1}(1,:),xw{1}(2,:),'x'); axis('square');
%   title('Gauss/Hermite')
%   subplot(2,2,2);
%   xw = gpc_integrate([], {'p',[0,0]}, 5, 'grid', 'smolyak');
%   plot(xw{1}(1,:),xw{1}(2,:),'x'); axis('square');
%   title('Uniform/Legendre')
%   subplot(2,2,3);
%   xw = gpc_integrate([], {'l',[0,0]}, 5, 'grid', 'smolyak');
%   plot(xw{1}(1,:),xw{1}(2,:),'x'); axis('square');
%   title('Exponential/Laguerre')
%   subplot(2,2,4);
%   xw = gpc_integrate([], {'u',[0,0]}, 5, 'grid', 'smolyak');
%   plot(xw{1}(1,:),xw{1}(2,:),'x'); axis('square');
%   title('Semicircle/Chebyshev_U')
%
% See also GPC, GPC_EVALUATE, GPC_SAMPLE, GPC_MOMENTS

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options = varargin2options(varargin);
[ndint_options, options] = get_option(options, 'ndint_options', {});
[grid, options] = get_option(options, 'grid', 'smolyak');
[vectorized, options] = get_option(options, 'vectorized', true);
[gpc_coeffs, options] = get_option(options, 'gpc_coeffs', []);
check_unsupported_options(options, mfilename);

[polys, I] = deal(V{:});

m = size(I, 2);
m1 = size(polys,2);
assert(m1==1 || m1==m);

rule_func = cell(m1, 1);
for i = 1:m1
    poly = polys(i);
    rule_func{i} = {@polysys_int_rule, {poly}, {1}};
end

if ~isempty(gpc_coeffs)
    func = {@func_with_gpc_eval, {func, V, gpc_coeffs}, {1, 2, 3}};
end
int=integrate_nd(func, rule_func, m, p, 'grid', grid, 'vectorized', vectorized, ndint_options{:});

function y = func_with_gpc_eval(func, V, a_i_alpha, x)
a = gpc_evaluate(a_i_alpha, V, x);
y = func(x, a);
