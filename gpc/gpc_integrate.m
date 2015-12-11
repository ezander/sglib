function [int, w]=gpc_integrate(func, V, p, varargin)
% GPC_INTEGRATE Integrate over GPC space or generate integration points.
%   INT=GPC_INTEGRATE(FUNC, V, P, OPTIONS) integrate the function FUNC over
%   the given GPC space V with an integration rule of order P. The grid can
%   be specified via the option 'grid' and defaults to 'smolyak'. The
%   integral is returned in INT.
%
%   XW=GPC_INTEGRATE([], V, P, OPTIONS) return the points and weights in
%   one cell array {X,W}.
%
%   [X, W]=GPC_INTEGRATE([], V, P, OPTIONS) return the points and weights
%   of the integration rule separately.
%
% Example 1: (<a href="matlab:run_example gpc_integrate 1">run</a>)
%   I_a = multiindex(3,4);
%   a_i_alpha = rand(10, size(I_a, 1));
%   gpc_integrate(@(a)(a), {'h',I_a}, 5, 'gpc_coeffs', a_i_alpha)
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
%   [x,w] = gpc_integrate([], {'h',[0,0]}, 5, 'grid', 'smolyak');
%   plot(x(1,:),x(2,:),'x'); axis('square');
%   title('Gauss/Hermite')
%   subplot(2,2,2);
%   [x,w] = gpc_integrate([], {'p',[0,0]}, 5, 'grid', 'smolyak');
%   plot(x(1,:),x(2,:),'x'); axis('square');
%   title('Uniform/Legendre')
%   subplot(2,2,3);
%   [x,w] = gpc_integrate([], {'l',[0,0]}, 5, 'grid', 'smolyak');
%   plot(x(1,:),x(2,:),'x'); axis('square');
%   title('Exponential/Laguerre')
%   subplot(2,2,4);
%   [x,w] = gpc_integrate([], {'u',[0,0]}, 5, 'grid', 'smolyak');
%   plot(x(1,:),x(2,:),'x'); axis('square');
%   title('Semicircle/Chebyshev_U')
%
% See also GPC, FUNCALL, GPC_EVALUATE, GPCGERM_SAMPLE, GPC_MOMENTS

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
[rule_mode, options] = get_option(options, 'rule_mode', 'auto');
[vectorized, options] = get_option(options, 'vectorized', true);
[transposed, options] = get_option(options, 'transposed', false);
[gpc_coeffs, options] = get_option(options, 'gpc_coeffs', []);
check_unsupported_options(options, mfilename);

if strcmp(rule_mode, 'auto')
    if strcmp(grid, 'smolyak')
        %rule_mode = 'ccf2';
        rule_mode = 'gauss';
        % We still stick to Gauss for the moment until the issue is better
        % understood and fixed
    else
        rule_mode = 'gauss';
    end
end

[syschars, I] = deal(V{:});

m = size(I, 2);
m1 = size(syschars,2);
check_boolean(m1==1 || m1==m, 'length of polynomial system must be one or match the size of the multiindices', mfilename);

rule_func = cell(m1, 1);
for i = 1:m1
    syschar = syschars(i);
    rule_func{i} = funcreate(@polysys_int_rule, syschar, @funarg, rule_mode);
end

if ~isempty(func)
    % function is explicitly given
    if ~isempty(gpc_coeffs)
        func = {@func_with_gpc_eval, {func, V, gpc_coeffs}, {1, 2, 3}};
    end
    int=integrate_nd(func, rule_func, m, p, 'grid', grid, ...
        'vectorized', vectorized, 'transposed', transposed, ndint_options{:});
else
    % return only integration rule
    [x,w]=integrate_nd(func, rule_func, m, p, 'grid', grid, ...
        'vectorized', vectorized, 'transposed', transposed, ndint_options{:});
    if ~isempty(gpc_coeffs)
        x = gpc_evaluate(gpc_coeffs, V, x);
    end
    if nargout<2
        int = {x, w};
    else
        int = x;
    end
end

function y = func_with_gpc_eval(func, V, a_i_alpha, x)
a = gpc_evaluate(a_i_alpha, V, x);
y = funcall(func, a);
