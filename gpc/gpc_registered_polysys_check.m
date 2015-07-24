function [sys_out, dist_out, poly_out]=gpc_registered_polysys_check(sys_reg, dist_reg, poly_reg, varargin)

%GPC_CHECK_REGISTERED_POLYSYS() check triplets (SYS letter, DISTribution and POLYnomialSystem)
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
[sys, options] = get_option(options, 'sys', '');
[dist, options] = get_option(options, 'dist', {});
check_unsupported_options(options, mfilename);
%% If SYS and DIST is not defined, then send back the standard POLYSYS and
% the regristered ones
if isempty(sys) && isempty(dist)
    sys_s='HPTULM';
    dist_out=cell(6,1);
    poly_out=cell(6,1);
    for i=1:6
        sys=sys_s(i);
        [~, dist]=get_standard_dist(sys);
        poly=get_standard_polys_and_sys(dist);
        
        dist_out{i}=dist;
        poly_out{i}=poly;
    end
    if ~isempty(sys_reg)
        sys_out=[sys_s,sys_reg];
        dist_out=vertcat(dist_out, dist_reg);
        poly_out=vertcat(poly_out, poly_reg);
    else
        sys_out=sys_s;
    end
    
elseif ~isempty(sys) && isempty(dist)
    [sys_out, dist_out]=get_standard_dist(sys);
    if isempty(sys_out) %if sys is not among the standard polysys'
        ind=strmatch(upper(sys), sys_reg');
        if ~isempty(ind)
            % get sys, distribution and polynomial corresponding to SYS
            sys_out=sys_reg(ind);
            dist_out=dist_reg{ind,:};
            poly_out=poly_reg{ind};
        else
            sys_out='';
            dist_out={};
            poly_out={};
        end
    else
        [poly_out, ~,dist_out]=get_standard_polys_and_sys(dist_out);
    end
    %Normalize poly if needed
elseif ~isempty(dist) && isempty(sys)
    [poly_out, sys_out, dist_out]=get_standard_polys_and_sys(dist);
    %if isempty(sys_out) %if dist is not among the standard distributions
    %then registry should be checked, but right now
    % do nothing
    %end
else
    error('DIST and SYS can not be defined together, please define either one or the other')
end
end

%%
function [sys, dist]=get_standard_dist(sys)
switch(sys)
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
        sys='';
end
end

%%
function [poly, sys, dist_out]=get_standard_polys_and_sys(dist)
n=0;
if iscell(dist)
    switch(upper(dist{1}))
        case 'NORMAL'
            poly=HermitePolynomials();
            %poly='Hermite';
            sys='H';
        case 'UNIFORM'
            poly=LegendrePolynomials();
            %poly='Legendre';
            sys='P';
        case 'BETA'
            a=dist{2}{1};
            b=dist{2}{2};
            if a==0.5&&b==0.5
                %poly= 'ChebyshevT';
                poly=ChebyshevTPolynomials();
                sys= 'T';
            elseif  a==1.5&&b==1.5
                %poly= 'ChebyshevU';
                poly=ChebyshevUPolynomials();
                sys= 'U';
            else
                %poly= 'Jacobi';
                poly=JacobiPolynomials(a-1, b-1);
                sys= '';
            end
        case 'EXPONENTIAL'
            %poly='Laguerre';
            poly=LaguerrePolynomials();
            sys='L';
        case 'LOGNORMAL'
            poly='';
            sys='';
        case 'NONE'
            %poly='Monomials';
            poly=Monomials();
            sys='M';
        otherwise
            error('No such distribution is implemented')
    end
elseif isa(dist, 'Distribution')
    sys=dist.default_sys_letter(false);
    poly=dist.default_polys();
else
    error('DIST should be generated by the GENDIST_CREATE function or one of the DISTRIBUTION objects')
end
if nargout>2
    dist_out=poly.weighting_func;
end
end