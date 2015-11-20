classdef SimParameter < SglibHandleObject
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
        germ_dist
        param2germ_func
        germ2param_func
        plot_name
    end
    
    methods
        function simparam=SimParameter(name, dist, varargin)
            % Returns a new SimParameter object with the distribution DIST
            % which was specified as an argument, and IS_FIXED set to false
            
            % NAME is a string that contains a human readable form of the
            % parameter description
            % DIST is an object belonging to one of the subclass of 'DISTRIBUTION'
            %
            % e.g.: MYPARAM=SimParameter('kappa', NormalDistribution(0,0.1))
            options=varargin2options(varargin);
            [simparam.plot_name, options]=get_option(options, 'plot_name', '');
            [simparam.param2germ_func,options]=get_option(options, 'param2germ_func', {});
            [simparam.germ2param_func,options]=get_option(options, 'germ2param_func', {});
            check_unsupported_options(options, mfilename);
            
            %Check whether input is in the right format
            check_type( name, 'char', true, 'NAME', mfilename);
            check_type( dist, 'Distribution', false, 'DIST', mfilename);
            
            % initialize properties
            simparam.name=name;
            simparam.dist=dist;
            simparam.is_fixed=false;
            if isempty(simparam.plot_name)
                simparam.plot_name=name;
            end
            
        end
        
        function set_fixed(simparam, val)
            % Fixes the parameter to the value VAL and sets IS_FIXED
            simparam.is_fixed=true;
            if nargin<2
                mu=mean(simparam.dist);
                simparam.fixed_val=mu;
            else
                simparam.fixed_val=val;
            end
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
        
        function xi=sample(simparam, n)
            %   Draw random samples from the parameter.
            %   XI=SAMPLE(DIST,N) draws N random samples from the random
            %   distribution DIST. If N is a scalar value XI is a column vector of
            %   random samples of size [N,1]. If N is a vector XI is a matrix (or
            %   tensor) of size [N(1), N(2), ...].
            xi=simparam.dist.sample(n);
        end
        
        function [polysys, germ_dist]=default_sys_letter(simparam, varargin)
            % Gets the default polynomial system used for the gpc expansion of the
            % RV. For some distribution polysys can be assigned
            % automaticaly. Otherwise it has to be set.
            % example:
            % MYPARAM= SIMPARAMETER( 'kappa', Normaldistribution(2,0.1))
            % MYPARAM.SET_POLYSYS()
            % MYPARAM.SET_POLYSYS('p')
            options=varargin2options(varargin);
            [is_normalized,options]=get_option(options, 'normal', false);
            check_unsupported_options(options, mfilename);
            
            polysys=simparam.dist.default_sys_letter(is_normalized);
            [polysys, germ_dist]=gpc_register_polysys(polysys);
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
                [polysys, g_dist]=default_sys_letter(simparam);
            else
                % check wheter polysys is valid, if not change to default
                % and send a warning
                [polysys, g_dist]=gpc_register_polysys(polysys);
            end
            [a_alpha, V, varerr]=gpc_param_expand(simparam.dist, polysys, expand_options);
            simparam.set_germdist(g_dist);
            simparam.germ2param_func=@(x)gpc_evaluate(a_alpha, V,x);
        end
        
        function set_germ2param_func(simparam, map_func)
            %Sets function for mapping from germ to parameter
            simparam.germ2param_func=map_func;
        end
        function set_param2germ_func(simparam, map_func)
            %Sets function for mapping from parameter to germ
            simparam.param2germ_func=map_func;
        end
        
        function set_germdist(simparam, germ_dist)
            %Sets distribution of the germ
            simparam.germ_dist=germ_dist;
        end
        function [dist, germ2dist_func, dist2germ_func]=get_set_germdist(simparam)
            %Gets and sets distribution of the germ automaticaly
            %and gives the corresponding mappings(dist2germ/germ2dist)
            dist=simparam.dist.get_base_dist();
            germ2dist_func=@(x)simparam.dist.base2dist(x);
            dist2germ_func=@(x)simparam.dist.dist2base(x);
            simparam.germ_dist=dist;
            simparam.germ2param_func=germ2dist_func;
            simparam.param2germ_func=dist2germ_func;
        end
        function x=param2germ(simparam, y)
            if isempty(simparam.param2germ_func)
                dist=get_set_germdist(simparam);
                string_warn=strvarexpand('There was no mapping set, the param is mapped to $dist.tostring$');
                warning(string_warn);
            end
            x=feval(simparam.param2germ_func,y);
        end
        function y=germ2param(simparam, x)
            if isempty(simparam.germ2param_func)
                dist=get_set_germdist(simparam);
                string_warn=strvarexpand('There was no mapping set, the param is mapped from $dist.tostring$');
                warning(string_warn);
            end
            y=feval(simparam.germ2param_func,x);
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
        function mu=mean(simparam)
            %Gives the mean value of the SimParameter
            mu=mean(simparam.dist);
        end
        
        function var=var(simparam)
            %Gives the variance of the SimParameter
            [~, var]=moments(simparam.dist);
        end
        
        function prob=pdf(simparam,x)
            %Gives the probability that SimParameter takes value x
            prob=simparam.dist.pdf(x);
        end
        
        function disp(simparam)
            disp(simparam.tostring());
        end
    end
end
