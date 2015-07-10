classdef SimParameter < handle
    %SIMPARAMETER Constructs a parameter,
    %   that may be a random variable or a deterministic one.
    %   PARAMETER=SIMPARAMETER(NAME,DIST) constructs parameter
    %   with name NAME and distribution DIST.
    %   by default the parameter is set to be random
    %   but can be fixed to the value VAL with SET_FIXED(PARAM, VAL)
    %   or to the mean value by SET_TO_MEAN(PARAM)
    %
    % Example (<a href="matlab:run_example SimParameter">run</a>)
    %   dist = LogNormalDistribution(2,3);
    %   param=SimParameter('kappa', dist) 
    %
    % See also DISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    %
    %  The POLYSYS is a letter defining the 
        %  orthogonal polynomial system which satisfyies the orthogonality condition
        % \Exp(\phi_i(Z)\phi_j(Z))=\delta_{ij}
        % Where  Z is a parameter with beta distribution
    
    %   Noemi Friedman and Elmar Zander
    %   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or
    %   modify it under the terms of the GNU General Public License as
    %   published by the Free Software Foundation, either version 3 of the
    %   License, or (at your option) any later version.
    %   See the GNU General Public License for more details. You should
    %   have received a copy of the GNU General Public License along with
    %   this program.  If not, see <http://www.gnu.org/licenses/>.
    properties (GetAccess=public, SetAccess=protected)
        name
        dist
        is_fixed
        fixed_val
        
        
    end
    
    methods
        function simparam=SimParameter(name, dist)
            % Returns a new SimParameter object with the distribution DIST
            % which was specified as an argument, and IS_FIXED set to false
            
            % NAME is a string that contains a human readable form of the
            % parameter description
            % DIST is an object belonging to one of the subclass of 'DISTRIBUTION'
            %
            % e.g.: MYPARAM=SimParameter('kappa', NormalDistribution(0,0.1))
            
            
            %Check whether input is in the right format
            check_type( name, 'char', true, 'NAME', mfilename);
            check_boolean(strcmp(superclasses(dist), 'Distribution'), 'input DIST has to be generated from a distribution object, e.g.: dist=NormalDistribution(mu, sigma)', mfilename);
            
            % initialize properties
            simparam.name=name;
            simparam.dist=dist;
            simparam.is_fixed=false;
         end
        
        function set_fixed(simparam, val)
            % Fixes the parameter to the value VAL and sets IS_FIXED
            simparam.is_fixed=true;
            simparam.fixed_val=val;
        end

        function set_to_mean(simparam)
            % Fixes the parameter to the value VAL to the mean of the
            % distribution
            simparam.is_fixed=true;
            mu=mean(simparam.dist);
            simparam.fixed_val=mu;
        end
        
        function set_dist(simparam, dist)
            % Sets a new distribution and resets the IS_FIXED variable
            simparam.dist=dist;
            simparam.is_fixed=false;
            simparam.fixed_val=[];
        end
        
        function set_not_fixed(simparam)
            % Sets the SimParam to be not fixed
            simparam.is_fixed=false;
            simparam.fixed_val=[];
        end
        
        function samples=sample(simparam, x)
            samples=simparam.dist.invcdf(x);
        end
        
              
        function polysys=get_default_polysys(simparam, varargin)
            % Gets the default polynomial system used for the gpc expansion of the
            % RV. For some distribution polysys can be assigned
            % automaticaly. Otherwise it has to be set.
            % example:
            % MYPARAM= SIMPARAMETER( 'kappa', Normaldistribution(2,0.1))
            % MYPARAM.SET_POLYSYS()
            % MYPARAM.SET_POLYSYS('p')
            options=varargin2options(varargin);
            [is_normalized,options]=get_option(options, 'normal', 'true');
           check_unsupported_options(options, mfilename);
           
           polysys=simparam.dist.default_polysys(is_normalized);
        end
        
        function [a_alpha, V, varerr]=gpc_expand(simparam, varargin)
            % Expands the parameter in the default
            % polynomyal system of the distribution (optionaly defined by
            % POYSYS). See EXPAND_OPTIONS more in GPC_PARAM_EXPAND
            options=varargin2options(varargin);
            [polysys,options]=get_option(options, 'polysys', '');
            [expand_options,options]=get_option(options, 'expand_options', {});
            check_unsupported_options(options, mfilename);
            
            if isempty(polysys)
                polysys=simparam.get_default_polysys;
            else
                % check wheter polysys is valid, if not change to default
                % and send a warning
            end
               [a_alpha, V, varerr]=gpc_param_expand(simparam.dist, polysys, expand_options);
        end
        
         function str=tostring(simparam)
             % Provides with a short display of the parameter's
             % name, distribution and whether the parameter is
             % deterministic (fixed) or random (not fixed)
             if simparam.is_fixed== true
                 fixed_char=' fixed';
             else
                 fixed_char=' not fixed';
             end
             str=sprintf('Parameter(%s,%s,%s)', simparam.name, simparam.dist.tostring(), fixed_char);
         end

         function disp(simparam)
             disp(simparam.tostring());
         end
    end
end
