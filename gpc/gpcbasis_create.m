function V = gpcbasis_create(syschars, varargin)
% GPCBASIS_CREATE Create representation of a GPC space/basis.
%   V = GPCBASIS_CREATE(SYSCHARS, OPTIONS) creates a representation of a GPC
%   space. SYSCHARS can be a single character or a string of characters
%   specifying the germ of the GPC space. For a single character the option
%   'm' can be used to specify the number of independent random variables
%   making up the germ, otherwise the size of the germ is the length of the
%   given string passed in SYSCHARS. If the option 'p' is specified a
%   multiindex in M variables up to complete order P is created. It's
%   probably best to take a look at the examples below.
%   
%   The characters that can be currently used are:
%     H,h - Gauss/Hermite
%     P,p - Uniform/Legendre
%     L,l - Exponential/Laguerre (both are automatically normalised)
%     T,t - Arcsine/Chebyshev 1st kind
%     U,u - Semicircle/Chebyshev 2nd kind (both normalised)
%     M   - Monomials (no corresponding probability measure, normalisation
%             not possible)
%
% Options
%   m: {automatic, length=length(syschars)}
%      Number of random variables in the germ of the GPC
%   p: {automatic, 0}
%      Order of expansion, if multiindex needs to be created
%   full_tensor: {false}, true
%      Create the multiindex set for full tensor polynomials instead of
%      complete polynomials (i.e. the polynomial with the highest degree
%      has degree M*P instead of degree P).
%   ordering: default
%      The ordering of the multiindex set. See help for MULTIINDEX for
%      possible options.
%   I: {automatic}
%      If specified this is used as multiindex set, m and p should not be
%      specified then. Size of multiindex set (dim=2) should match the
%      length of SYSCHARS (i.e. ismember(length(syschars), [1, dim(I,2)]))
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
[ordering,options]=get_option(options, 'ordering', @isdefault);
[full_tensor,options]=get_option(options, 'full_tensor', @isdefault);
check_unsupported_options(options, mfilename);

if iscell(syschars)
    V_old = syschars;
    syschars = V_old{1};
    m = gpcbasis_size(V_old, 2);
end

% Determine m
if isdefault(m)
    m=length(syschars);
elseif ~(length(syschars)==1 || length(syschars)==m)
    error('sglib:gpcbasis', 'length of ''syschars'' does not match ''m''');
end

% Determine p
if isdefault(p)
    p=0;
end

% Determine additional multiindex options
mi_opts = {};
if ~isdefault(full_tensor)
    mi_opts = [mi_opts, {'full', full_tensor}];
end
if ~isdefault(ordering)
    mi_opts = [mi_opts, {'ordering', ordering}];
end

% Create multiindex set
if isdefault(I)
    I = multiindex(m, p, mi_opts{:});
else
    % check that I and m and syschars are compatible
end
V = {syschars, I};
end

function b=isdefault(p)
b=isequal(p,@isdefault);
end
