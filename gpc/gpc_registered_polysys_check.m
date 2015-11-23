function [syschar_out, dist_out, poly_out]=gpc_registered_polysys_check(syschar_reg, dist_reg, poly_reg, varargin)
%GPC_CHECK_REGISTERED_POLYSYS() check triplets (SYSCHAR letter, DISTribution and POLYnomialSystem)
% which were already registered or which are the standard ones.
% This function should not be called directly, only through GPC_REGISTER_POLYSYS
%
% See also GPC

%   Noemi Friedman & Elmar Zander
%   Copyright 2012, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options = varargin2options(varargin);
[syschar, options] = get_option(options, 'syschar', '');
[dist, options] = get_option(options, 'dist', {});
check_unsupported_options(options, mfilename);
%% If SYSCHAR and DIST is not defined, then send back the standard POLYSYS and
% the regristered ones
if isempty(syschar) && isempty(dist)
    syschar_s='HPTULM';
    dist_out=cell(6,1);
    poly_out=cell(6,1);
    for i=1:6
        syschar=syschar_s(i);
        [~, dist]=get_standard_dist(syschar);
        poly=get_standard_polys_and_syschar(dist);
        
        dist_out{i}=dist;
        poly_out{i}=poly;
    end
    if ~isempty(syschar_reg)
        syschar_out=[syschar_s,syschar_reg];
        dist_out=vertcat(dist_out, dist_reg);
        poly_out=vertcat(poly_out, poly_reg);
    else
        syschar_out=syschar_s;
    end
    
elseif ~isempty(syschar) && isempty(dist)
    [syschar_out, dist_out]=get_standard_dist(syschar);
    if isempty(syschar_out) %if syschar is not among the standard polysys'
        ind=strmatch(upper(syschar), syschar_reg');
        if ~isempty(ind)
            % get syschar, distribution and polynomial corresponding to SYSCHAR
            syschar_out=syschar_reg(ind);
            dist_out=dist_reg{ind,:};
            poly_out=poly_reg{ind};
        else
            syschar_out='';
            dist_out={};
            poly_out={};
        end
    else
        [poly_out, ~,dist_out]=get_standard_polys_and_syschar(dist_out);
    end
    %Normalize poly if needed
elseif ~isempty(dist) && isempty(syschar)
    [poly_out, syschar_out, dist_out]=get_standard_polys_and_syschar(dist);
    %if isempty(syschar_out) %if dist is not among the standard distributions
    %then registry should be checked, but right now
    % do nothing
    %end
else
    error('DIST and SYSCHAR can not be defined together, please define either one or the other')
end
end

%%
function [syschar, dist]=get_standard_dist(syschar)
switch(syschar)
    case{'H','h'}
        dist=gendist_create('normal', {0,1});
    case{'P','p'}
        dist=gendist_create('uniform', {-1,1});
    case{'T','t'}
        dist = gendist_create('arcsine', {}, 'shift', -0.5, 'scale', 2);
    case{'U','u'}
        dist = gendist_create('semicircle');
    case{'L','l'}
        dist=gendist_create('exponential', {1});
    case{'M','m'}
        dist={'none'};
    otherwise
        dist={};
        syschar='';
end
end

%%
function [poly, syschar, dist_out]=get_standard_polys_and_syschar(dist)
n=0;
if iscell(dist)
    switch(upper(dist{1}))
        case 'NORMAL'
            poly=HermitePolynomials();
            %poly='Hermite';
            syschar='H';
        case 'UNIFORM'
            poly=LegendrePolynomials();
            %poly='Legendre';
            syschar='P';
        case 'BETA'
            a=dist{2}{1};
            b=dist{2}{2};
            if a==0.5&&b==0.5
                %poly= 'ChebyshevT';
                poly=ChebyshevTPolynomials();
                syschar= 'T';
            elseif  a==1.5&&b==1.5
                %poly= 'ChebyshevU';
                poly=ChebyshevUPolynomials();
                syschar= 'U';
            else
                %poly= 'Jacobi';
                poly=JacobiPolynomials(b-1, a-1);
                syschar= '';
            end
        case 'EXPONENTIAL'
            %poly='Laguerre';
            poly=LaguerrePolynomials();
            syschar='L';
        case 'LOGNORMAL'
            poly='';
            syschar='';
        case 'NONE'
            %poly='Monomials';
            poly=Monomials();
            syschar='M';
        otherwise
            error('No such distribution is implemented')
    end
elseif isa(dist, 'Distribution')
    if isa(dist, 'BetaDistribution')&&~(dist.a==3/2 && dist.b==3/2||dist.a==1/2 && dist.b==1/2)
        poly=JacobiPolynomials(dist.b-1, dist.a-1);
        syschar= '';
    elseif isa(dist, 'TranslatedDistribution') && isa(dist.dist, 'BetaDistribution')&&~(dist.dist.a==3/2 && dist.dist.b==3/2||dist.dist.a==1/2 && dist.dist.b==1/2)
        poly=JacobiPolynomials(dist.dist.b-1, dist.dist.a-1);
        syschar= '';
    else
        syschar=dist.default_syschar_letter(false);
        poly=dist.default_polys();
    end
else
    error('DIST should be generated by the GENDIST_CREATE function or one of the DISTRIBUTION objects')
end
if nargout>2
    dist_out=poly.weighting_dist;
end
end
