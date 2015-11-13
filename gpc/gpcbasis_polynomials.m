function multivar_polys=gpcbasis_polynomials(V, varargin)
% GPCBASIS_POLYNOMIALS Show textual representation of GPC basis polynomials.
%   MULTIVAR_POLYS=GPCBASIS_POLYNOMIALS(V, OPTIONS) returns a cell array
%   containing strings with textual representation of the polynomials
%
% Options
%    'symbols': {'x1', 'x2', ...}
%       Symbols can be a string or a cell array. The symbols the univariate
%       polynomials are taking from there in order. If it is a string the
%       the string can be in the form 'xyz' or 'xi,eta,zeta' if multichar
%       symbols should be used.
%    'format_opts': {}
%       Is a cell array of options that is passed on the FORMAT_POLY for
%       formatting the univariate polynomials.
%
% Example (<a href="matlab:run_example gpcbasis_polynomials">run</a>)
%    V = gpcbasis_create('HP', 'p', 4);
%    gpcbasis_polynomials(V, 'symbols', 'xy', 'format_opts', ...
%        {'tight', false, 'rats', true})
%
% See also GPCBASIS_CREATE FORMAT_POLY

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

options=varargin2options(varargin);
[symbols,options]=get_option(options, 'symbols', '');
[format_opts, options]=get_option(options, 'format_opts', {});
check_unsupported_options(options, mfilename);

% Determine the germ
germ = V{1};
I = V{2};
m = size(I,2);
if length(germ)==1
    germ = repmat(germ, 1, m);
end

% Determine the symbols for representing the univariate polynomials
if ischar(symbols)
    if any(symbols==',')
        symbols = strsplit2(symbols, ',');
    elseif ~isempty(symbols)
        symbols = mat2cell(symbols, 1, ones(1,length(symbols))); %#ok<MMTC>
    end
elseif ~iscell(symbols)
    error('sglib:gpcbasis_polynomials', 'Symbols should be string or cell array');
end

if ~isempty(symbols) && numel(symbols)<m
    warning('sglib:gpcbasis_polynomials', 'Not enough symbols specified');
end

for j=numel(symbols)+1:m
    symbols{j} = sprintf('x%d', j);
end

% Determine coefficients of the univariate polynomials (plus the number of
% terms and the sign of the highest coefficient)
p = max(I(:));
univar_polys_str = cell(m,p+1);
univar_polys_nt  = zeros(m,p+1);
univar_polys_sgn = ones(m,p+1);
for j=1:m
    rc_j = polysys_recur_coeff(germ(j),p);
    poly_j = polysys_rc2coeffs(rc_j);
    sgn = sign(diag(fliplr(poly_j)));
    poly_j = binfun(@times, poly_j, sgn);
    
    univar_polys_nt(j,:) = sum(poly_j~=0,2);
    univar_polys_sgn(j,:) = sgn;
    univar_polys_str(j,:) = format_poly(poly_j, 'symbol', symbols{j}, format_opts{:});
end

% Create the multivariate polynomials
%#ok<*AGROW>
multivar_polys = cell(size(I,1),1);
for k=1:size(I,1)
    multivar = (sum(I(k,:)~=0)>1);
    s='';
    sgn = 1;
    for j=1:m
        if I(k,j)
            if ~isempty(s)
                s = [s, ' '];
            end
            p1 = I(k,j)+1;
            
            sp=univar_polys_str{j,p1};
            sgn = sgn * univar_polys_sgn(j,p1);
            if multivar && univar_polys_nt(j, p1)>1
                s=[s, '(', sp, ')'];
            else
                s=[s, sp];
            end
        end
    end
    if isempty(s)
        s = '1';
    end
    if sgn<0
        s = ['-', s];
    end
    multivar_polys{k,1} = s;
end


function C=strsplit2(str, sym)
% STRSPLIT2 Split a string into symbols.
C={};
while ~isempty(str)
    pos=find(str==sym);
    if isempty(pos)
        C{end+1} = str; 
        break;
    else
        p = pos(1);
        C{end+1} = str(1:p-1); 
        str = str(p+1:end);
    end
end
