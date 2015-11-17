function [sys_out, dist_out, poly_out]=gpc_register_polysys(sys, dist, poly, varargin)
% GPC_REGISTER  Registers new polynomial system with given parameters.
%   This functions allows one to create non standard POLYSYS (others, than
%   the ones, that can be defined automaticaly in GPCBASIS_CREATE) For
%   example beta distribution with differen parameters, or other standard
%   distribution with different polynomial system can be registered. See
%   example beneath
%
%
% Example 1: (<a href="matlab:run_example gpc_register_polysys 1">run</a>)
%    % add a new POLYSYS with BETA distribution (alpha=2, beta=2),
%    corresponding to the SYS letter 'J':
%    [sys, dist, poly]=gpc_register_polysys('j', gendist_create('beta', {2,2}))
% 
% Example 2: (<a href="matlab:run_example gpc_register_polysys 2">run</a>)
%    % check registered ans standard POLYSYS
%    [sys, dist, poly]=gpc_register_polysys('', [], [], 'show_standard_sys', true)
%
% Example 3: (<a href="matlab:run_example gpc_register_polysys 3">run</a>)
%    % checks registered POLYSYS
%    [sys, dist, poly]=gpc_register_polysys()
%
% Example 4: (<a href="matlab:run_example gpc_register_polysys 4">run</a>)
%    % checks a registered POLYSYS corresponding to the SYS letter 'J'
%    [sys, dist, poly]=gpc_register_polysys('j')
%
% See also GPC GPCBASIS_CREATE, GPC_REGISTERED_POLYSYS_CHECK

%   Noemi Friedman, Elmar Zander
%   Copyright 2015, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options = varargin2options(varargin);
[show_standard_sys, options] = get_option(options, 'show_standard_sys', false);
check_unsupported_options(options, mfilename);

persistent sys_reg
persistent dist_reg
persistent poly_reg

newreg=false;

%% If no input-> show all registered and standard POLYSYS
if nargin<1 || (isempty(sys)&& isempty(dist) &&isempty(poly))
    
    if ~show_standard_sys
        sys_out=sys_reg;
        dist_out=dist_reg;
        poly_out=poly_reg;
    else
        [sys_out, dist_out, poly_out]=gpc_registered_polysys_check(sys_reg, dist_reg, poly_reg);
    end
    
    %% If input is only the SYS letter, then give info about the corresponding
    % distribution and polynomial system
elseif nargin<2 || ( isempty(dist) && isempty(poly))
    [sys_out, dist_out, poly_out]=gpc_registered_polysys_check(sys_reg, dist_reg, poly_reg, 'sys', sys);
    if isempty(sys_out)
          error('sglib:gpc:polysys', 'Unknown polynomials system: %s', sys);
    end
    if  (lower(sys)==sys);
        sys_out=lower(sys_out);
        poly_out=poly_out.normalized;
    end
    %% If DIST or POLYS is defined in the input ->
    % decide whether new registry has to be made
else
    if ~isempty(dist)
        [sys_out, dist_out, poly_out]=gpc_registered_polysys_check(sys_reg, dist_reg, poly_reg, 'dist' , dist);
        if isempty(sys_out) %if there is no standard polys
            newreg=true;
            if nargin>2&&~isempty(poly)
                %check if the given polynomial is valid
                if isa(poly, 'PolynomialSystem')
                    poly_out=poly;
                else
                    warning('sglib:NoValidPolysRegistry', '%s  %s %s %s', 'polynomial system is not a valid, instead', upper(class(poly_out)), 'polynomials are registered')
                end
            end
            
        elseif nargin>2  &&  ~isempty(poly)
            if strcmpi(class(poly), class(poly_out));
                warning('sglib:NoValidPolysRegistry', 'No new registry made, because DIST with the given POLYS is a standard systems')
            else
                newreg=true;
                poly_out=poly;
            end
        else
            newreg='true';
        end
    else
        error('DIST has to be defined for new registry')
    end
end

%% Create new registry if NEWREG
if newreg
    if isempty(sys_reg)
        sys_reg='';
        dist_reg=cell(0,1);
        poly_reg=cell(0,1);
    end
    
    sys_r=gpc_registered_polysys_check(sys_reg, dist_reg, poly_reg);
    a_to_z='A':'Z';
    symbols= a_to_z(~ismember(a_to_z, sys_r));
    
    if isempty(sys)
        %get a random letter for the SYS
        sys_out=symbols( randi( numel(symbols) ) );
          % check wheter  the given SYS letter is still available
    elseif ismember(upper(sys), sys_r)
            sys_out=symbols( randi( numel(symbols) ) );
            warning('sglib:NoValidPolysRegistry', '%s %s %s %s', ' polynomial system', sys,  'is already reserved for other distribution,SYS was changed to', sys_out);
    else
            sys_out=upper(sys);
    end
    
    sys_reg(end+1)=upper(sys_out);
    dist_reg{end+1,1}=dist_out;
    poly_reg{end+1,1}=poly_out;
end
end
