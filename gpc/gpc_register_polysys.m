function [syschar_out, dist_out, poly_out]=gpc_register_polysys(syschar, dist, poly, varargin)
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
%    corresponding to the SYSCHAR letter 'J':
%    [syschar, dist, poly]=gpc_register_polysys('j', gendist_create('beta', {2,2}))
% 
% Example 2: (<a href="matlab:run_example gpc_register_polysys 2">run</a>)
%    % check registered ans standard POLYSYS
%    [syschar, dist, poly]=gpc_register_polysys('', [], [], 'show_standard_syschar', true)
%
% Example 3: (<a href="matlab:run_example gpc_register_polysys 3">run</a>)
%    % checks registered POLYSYS
%    [syschar, dist, poly]=gpc_register_polysys()
%
% Example 4: (<a href="matlab:run_example gpc_register_polysys 4">run</a>)
%    % checks a registered POLYSYS corresponding to the SYSCHAR letter 'J'
%    [syschar, dist, poly]=gpc_register_polysys('j')
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
[show_standard_syschar, options] = get_option(options, 'show_standard_syschar', false);
check_unsupported_options(options, mfilename);

persistent syschar_reg
persistent dist_reg
persistent poly_reg

newreg=false;

%% If no input-> show all registered and standard POLYSYS
if nargin<1 || (isempty(syschar)&& isempty(dist) &&isempty(poly))
    
    if ~show_standard_syschar
        syschar_out=syschar_reg;
        dist_out=dist_reg;
        poly_out=poly_reg;
    else
        [syschar_out, dist_out, poly_out]=gpc_registered_polysys_check(syschar_reg, dist_reg, poly_reg);
    end
    
    %% If input is only the SYSCHAR letter, then give info about the corresponding
    % distribution and polynomial system
elseif nargin<2 || ( isempty(dist) && isempty(poly))
    [syschar_out, dist_out, poly_out]=gpc_registered_polysys_check(syschar_reg, dist_reg, poly_reg, 'syschar', syschar);
    if isempty(syschar_out)
          error('sglib:gpc:polysys', 'Unknown polynomials system: %s', syschar);
    end
    if  (lower(syschar)==syschar);
        syschar_out=lower(syschar_out);
        poly_out=poly_out.normalized;
    end
    %% If DIST or POLYS is defined in the input ->
    % decide whether new registry has to be made
else
    if ~isempty(dist)
        [syschar_out, dist_out, poly_out]=gpc_registered_polysys_check(syschar_reg, dist_reg, poly_reg, 'dist' , dist);
        if isempty(syschar_out) %if there is no standard polys
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
    if isempty(syschar_reg)
        syschar_reg='';
        dist_reg=cell(0,1);
        poly_reg=cell(0,1);
    end
    
    syschar_r=gpc_registered_polysys_check(syschar_reg, dist_reg, poly_reg);
    a_to_z='A':'Z';
    symbols= a_to_z(~ismember(a_to_z, syschar_r));
    
    if isempty(syschar)
        %get a random letter for the SYSCHAR
        syschar_out=symbols( randi( numel(symbols) ) );
          % check wheter  the given SYSCHAR letter is still available
    elseif ismember(upper(syschar), syschar_r)
            syschar_out=symbols( randi( numel(symbols) ) );
            warning('sglib:NoValidPolysRegistry', '%s %s %s %s', ' polynomial system', syschar,  'is already reserved for other distribution,SYSCHAR was changed to', syschar_out);
    else
            syschar_out=upper(syschar);
    end
    
    syschar_reg(end+1)=upper(syschar_out);
    dist_reg{end+1,1}=dist_out;
    poly_reg{end+1,1}=poly_out;
end
end
