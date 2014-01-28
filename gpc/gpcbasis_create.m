function V = gpcbasis_create(polysys, varargin)
% GPCBASIS_CREATE Short description of gpcspace_create.
%   GPCSPACE_CREATE Long description of gpcspace_create.
%   
%   H,h - Gauss/Hermite (normalised)
%   P,p - Uniform/Legendre (normalised)
%   L,l - Exponential/Laguerre (both are automatically normalised)
%   T,t - Arcsine/Chebyshev 1st kind (both normalised)
%   U,u - Semicircle/Chebyshev 2nd kind (both normalised)
%   M   - Monomials (no corresponding probability measure, normalisation
%           not possible)
%
% Options
%   m: {automatic, length=polysys}
%      Number of random variables in the germ of the GPC
%   p: {automatic, 0}
%      Order of expansion, if multiindex needs to be created
%   full_tensor: {false}, true
%      Create the multiindex set for full tensor polynomials instead of
%      complete polynomials (i.e. the polynomial with the highest degree
%      has degree M*P instead of degree P).
%   I: {automatic}
%      If specified this is used as multiindex set, m and p should not be
%      specified then. Size of multiindex set (dim=2) should match the
%      length of polysys (i.e. ismember(length(polysys), [1, dim(I,2)]))
%
% Example (<a href="matlab:run_example gpcbasis_create">run</a>)
%   % Create a GPC basis with Hermite Chaoses in 4 RVs up to total degree 2
%   V = gpcbasis_create('H', 'm', 4, 'p', 2);
%   fprintf('%d basis functions in %d RVs\n', gpcbasis_size(V,1), gpcbasis_size(V,2));
%   V = gpcbasis_create('hlp', 'p', 6);
%
% See also GPC, GPCBASIS_SIZE

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

options=varargin2options(varargin);
[m,options]=get_option(options, 'm', @isdefault);
[p,options]=get_option(options, 'p', @isdefault);
[I,options]=get_option(options, 'I', @isdefault);
%[rvtype,options]=get_option(options, 'I', @isdefault); 'rvtype', 'normal'
[full_tensor,options]=get_option(options, 'full_tensor', false);
check_unsupported_options(options, mfilename);

if iscell(polysys)
    V_old = polysys;
    polysys = V_old{1};
    m = gpcbasis_size(V_old, 2);
end

if isdefault(m)
    m=length(polysys);
elseif ~(length(polysys)==1 || length(polysys)==m)
    error('sglib:gpcbasis', 'length of ''polysys'' does not match ''m''');
end
if isdefault(p)
    p=0;
end
if isdefault(I)
    I = multiindex(m, p, 'full', full_tensor);
else
    % check that I and m and polysys are compatible
end
V = {polysys, I};

function b=isdefault(p)
b=isequal(p,@isdefault);
