function multivar_polys=gpcbasis_polynomials(V, varargin)
% GPCBASIS_POLYNOMIALS Short description of gpcbasis_polynomials.
%   GPCBASIS_POLYNOMIALS Long description of gpcbasis_polynomials.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example gpcbasis_polynomials">run</a>)
%
% See also

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
check_unsupported_options(options, mfilename);

germ = V{1};
I = V{2};
m = size(I,2);
if length(germ)==1
    germ = repmat(germ, 1, m);
end

if ischar(symbols)
    if any(symbols==',')
        symbols = strsplit2(symbols, ',');
    elseif ~isempty(symbols)
        symbols = mat2cell(symbols, 1, ones(1,length(symbols)));
    end
elseif ~iscell(symbols)
    warning('sglib:gpcbasis_polynomials', 'Symbols should be string or cell array');
    symbols = {};
end

if ~isempty(symbols) && numel(symbols)<m
    warning('sglib:gpcbasis_polynomials', 'Not enough symbols specified');
end

for j=numel(symbols)+1:m
    symbols{j} = sprintf('x%d', j);
end

p = max(I(:));
univar_polys = cell(m,p+1);
for j=1:m
    rc_j = polysys_recur_coeff(germ(j),p);
    poly_j = polysys_rc2coeffs(rc_j);
    univar_polys(j,:) = format_poly(poly_j, 'symbol', symbols{j});
end    
multivar_polys = cell(size(I,1),1);
for k=1:size(I,1)
    s='';
    for j=1:m
        if I(k,j)
            s=[s, '(', univar_polys{j,I(k,j)+1}, ')'];
        end
    end
    if sum(I(k,:)~=0)==1
        s=s(2:end-1);
    end
    if isempty(s)
        s='1';
    end
    multivar_polys{k,1} = s;
end


function C=strsplit2(str, sym)
C={};
while ~isempty(str)
    pos=find(str==sym);
    if isempty(pos)
        C{end+1} = str; %#ok<AGROW>
        break;
    else
        p = pos(1);
        C{end+1} = str(1:p-1); %#ok<AGROW>
        str = str(p+1:end);
    end
end
