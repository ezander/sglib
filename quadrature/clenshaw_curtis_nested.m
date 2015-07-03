function [x,w]=clenshaw_curtis_nested(n, varargin)
% CLENSHAW_CURTIS_NESTED Compute the nested Clenshaw-Curtis rule.
%   [X,W]=CLENSHAW_CURTIS_NESTED(N) computes the nested Clenshaw-Curtis or
%   Fejer rules. This is mainly for sparse grid integration where nested
%   rules are advantageous.
%
% Options
%   'mode': {'cc'}, 'fejer1', 'fejer2'
%     Selects the actual integration rule from Clenshaw-Curtis, Fejer 1 or
%     Fejer 2.
%
% Example (<a href="matlab:run_example clenshaw_curtis_nested">run</a>)
%   clf; hold all
%   for i = 1:5
%     [x, w] = clenshaw_curtis_nested(i, 'mode', 0);
%     plot(x, i*ones(size(x)), 'x');
%   end
%   xlim([-1.3, 1.3]); ylim([0.5, 5.5])
%
% See also SMOLYAK_GRID, INTEGRATE_ND, CLENSHAW_CURTIS_RULE

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

options=varargin2options(varargin, mfilename);
[mode, options]=get_option(options, 'mode', 0);
check_unsupported_options(options)

check_range(n, 1, inf, 'n', mfilename);

switch mode
    case {'cc', 0}
        m = 2^(n-1)+(n>1);
    case {'fejer1', 1}
        m = 3^(n-1);
    case {'fejer2', 2}
        m = 2^n-1;
end
[x,w]=clenshaw_curtis_rule(m, 'mode', mode);
