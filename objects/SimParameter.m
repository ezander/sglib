classdef SimParameter < SglibHandleObject & matlab.mixin.Copyable
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
    
    %   Noemi Friedman, Elmar Zander
    %   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or
    %   modify it under the terms of the GNU General Public License as
    %   published by the Free Software Foundation, either version 3 of the
    %   License, or (at your option) any later version.
    %   See the GNU General Public License for more details. You should
    %   have received a copy of the GNU General Public License along with
    %   this program.  If not, see <http://www.gnu.org/licenses/>.
    properties (SetAccess=protected)
        name
        dist
        is_fixed
        fixed_val
        plot_name
    end
    
    properties (Transient, Access=protected)
        gpc_syschar
    end
    
%     properties(Transient, SetAccess=protected)
%         germ_dist
%         param2germ_func
%         germ2param_func
%     end
    
    %% Constructor and basic methods
    methods
        function param=SimParameter(name, dist_or_num, varargin)
            % Returns a new SimParameter object with the distribution DIST
            % which was specified as an argument, and IS_FIXED set to false
            
            % NAME is a string that contains a human readable form of the
            % parameter description
            % DIST is an object belonging to one of the subclass of 'DISTRIBUTION'
            %
            % e.g.: MYPARAM=SimParameter('kappa', NormalDistribution(0,0.1))
            options=varargin2options(varargin);
            [param.plot_name, options]=get_option(options, 'plot_name', '');
            %[param.param2germ_func,options]=get_option(options, 'param2germ_func', {});
            %[param.germ2param_func,options]=get_option(options, 'germ2param_func', {});
            check_unsupported_options(options, mfilename);
            
            if isnumeric(dist_or_num)
                fixed_val = dist_or_num;
                is_fixed = true;
                dist = NormalDistribution(fixed_val, 0);
            else
                fixed_val = [];
                is_fixed = false;
                dist = dist_or_num;
            end
            
            %Check whether input is in the right format
            check_type( name, 'char', true, 'NAME', mfilename);
            check_type( dist, 'Distribution', false, 'DIST', mfilename);
            
            % initialize properties
            param.name=name;
            param.dist=dist;
            param.is_fixed=is_fixed;
            param.fixed_val=fixed_val;
            if isempty(param.plot_name)
                param.plot_name=name;
            end
            
        end
        
        function str=tostring(param)
            % TOSTRING Convert to string representation.
            %   STR=TOSTRING(PARAM) converts this parameter object into a
            %   string, provising a short display of the parameter's name,
            %   distribution and whether the parameter is deterministic
            %   (fixed) or random (not fixed)
            if param.is_fixed== true
                str=sprintf('Param("%s", %g)', param.name, param.fixed_val);
            else
                str=sprintf('Param("%s", %s)', param.name, param.dist.tostring());
            end
        end
    end
    
    %% Setting to fixed values
    methods
        function set_fixed(param, val)
            % SET_FIXED Set parameter to fixed value.
            %   SET_FIXED(PARAM, VAL) fixes the parameter to the
            %   value VAL and sets IS_FIXED.
            % Note: Fixing the value has the effect, that the parameter is
            %   treated like a random variable with *constant* value,
            %   having an effect also on functions like MEAN, VAR, etc. The
            %   mean and variance of such a variable is equal to VAL and 0,
            %   respectively, and sampling will always return VAL.
            % See also SET_TO_MEAN, SET_NOT_FIXED
            param.is_fixed=true;
            param.fixed_val=val;
        end
        
        function set_to_mean(param)
            % SET_TO_MEAN Set parameter fixed to the mean value of its distribution.
            %   SET_TO_MEAN(PARAM) fixes the parameter to the mean
            %   value of the distribution.
            % See also SET_FIXED, SET_NOT_FIXED
            param.set_fixed(mean(param.dist));
        end
        
        function set_not_fixed(param)
            % SET_NOT_FIXED Undoes fixation of the parameter.
            %   SET_NOT_FIXED(PARAM) undoes the previous fixation of the
            %   parameter, which then varies again according to its
            %   distribution.
            % See also SET_FIXED, SET_TO_MEAN
            param.is_fixed=false;
            param.fixed_val=[];
        end
        
        function set_dist(param, dist)
            % SET_DIST(PARAM, DIST) Sets a new distribution and resets the IS_FIXED variable.
            %   SET_DIST(PARAM, DIST) sets DIST as new distribution and
            %   resets the IS_FIXED variable.
            % See also SET_NOT_FIXED, SET_FIXED, SET_TO_MEAN
            param.dist=dist;
            param.set_not_fixed();
        end
    end
       
    %% Basic distribution related function
    methods
        function mu=mean(param)
            % MEAN Return the mean value of the parameter.
            %   MU=MEAN(PARAM) returns the mean value of the SimParameter
            %   or the FIXED_VAL if the parameters has been set to fixed.
            if param.is_fixed
                mu = param.fixed_val;
            else
                mu = param.dist.mean();
            end
        end
        
        function var=var(param, ignore_fixed)
            % VAR Return the variance of the parameter.
            %   VAR=VAR(PARAM) returns the variance of the SimParameter
            %   or the 0 if the parameters has been set to fixed.
            if nargin<2
                ignore_fixed = false;
            end
            if param.is_fixed && ~ignore_fixed
                var = 0;
            else
                var = param.dist.var();
            end
        end
        
        function y=pdf(param, x)
            % PDF Return the pdf of the parameter.
            if param.is_fixed
                abstol = 1e-10;
                reltol = 1e-10;
                x0 = param.fixed_val;
                y = double(abs(x-x0)<=abstol+abs(x0)*reltol);
            else
                y = param.dist.pdf(x);
            end
        end

        function y=cdf(param, x)
            % CDF Return the cdf of the parameter.
            if param.is_fixed
                y = 0.5; % no sensible value here
            else
                y = param.dist.cdf(x);
            end
        end
        
        function xi=sample(param, n, varargin)
            % SAMPLE Draw samples from this parameter/
            %   XI=SAMPLE(PARAM, N, VARARGIN) draws N random samples from
            %   the random distribution DIST. If N is a scalar value XI is
            %   a column vector of random samples of size [N,1]. If N is a
            %   vector XI is a matrix (or tensor) of size [N(1), N(2),
            %   ...]. Any extra parameters are passed on to the
            %   distribution DIST.
            %   If the parameter is fixed only the fixed value is repeated
            %   N times.
            if param.is_fixed
                if isscalar(n)==1
                    xi = repmat(param.fixed_val,n,1);
                else
                    xi = repmat(param.fixed_val,n);
                end
            else
                xi=param.dist.sample(n, varargin{:});
            end
        end
    end
    
    methods
        function dist=get_gpc_dist(param)
            dist = param.dist.get_base_dist();
        end

        function polysys=get_gpc_polysys(param, normalized)
            dist = param.get_gpc_dist();
            polysys = dist.orth_polysys();
            if normalized
                polysys = polysys.normalized();
            end
        end
        
        function syschar=get_gpc_syschar(param, normalized)
            % Gets the default polynomial system used for the gpc expansion of the
            % RV. For some distribution polysys can be assigned
            % automaticaly. Otherwise it has to be set.
            if nargin<2
                normalized = true;
            end
            gpcreg = gpc_registry('object');
            syschar = param.gpc_syschar;
            
            if ~isempty(syschar)
                polysys = gpcreg.get(syschar);
                if polysys~=param.get_gpc_polysys(normalized)
                    syschar = '';
                end
            end
            if isempty(syschar)
                polysys = param.get_gpc_polysys(normalized);
                syschar = gpcreg.find(polysys);
                if isempty(syschar)
                    syschar = gpcreg.findfree();
                    gpcreg.set(syschar, polysys);
                end
            end
            param.gpc_syschar = syschar;
        end
        
      
        function [q_alpha, V_q, varerr]=gpc_expand(param, varargin)
            % Expands the parameter in the default
            % polynomyal system of the distribution (optionaly defined by
            % POYSYS). See EXPAND_OPTIONS more in GPC_PARAM_EXPAND
            options=varargin2options(varargin);
            [normalized,options]=get_option(options, 'normalized', true);
            [expand_options,options]=get_option(options, 'expand_options', {});
            check_unsupported_options(options, mfilename);
            
            syschar=param.get_gpc_syschar(normalized);
            [q_alpha, V_q, varerr]=gpc_param_expand(param.dist, syschar, expand_options);
        end
        
        function y=germ2param(param, x)
            y = param.dist.base2dist(x);
        end

        function x=param2germ(param, y)
            x = param.dist.dist2base(y);
        end
     
    end

%     methods
%         function set_germ2param_func(param, map_func)
%             %Sets function for mapping from germ to parameter
%             param.germ2param_func=map_func;
%         end
%         function set_param2germ_func(param, map_func)
%             %Sets function for mapping from parameter to germ
%             param.param2germ_func=map_func;
%         end
%         
%         function set_germdist(param, germ_dist)
%             %Sets distribution of the germ
%             param.germ_dist=germ_dist;
%         end
%         
%         function [dist, germ2dist_func, dist2germ_func]=get_set_germdist(param)
%             %Gets and sets distribution of the germ automaticaly
%             %and gives the corresponding mappings(dist2germ/germ2dist)
%             dist=param.dist.get_base_dist();
%             germ2dist_func=@(x)param.dist.base2dist(x);
%             dist2germ_func=@(x)param.dist.dist2base(x);
%             param.germ_dist=dist;
%             param.germ2param_func=germ2dist_func;
%             param.param2germ_func=dist2germ_func;
%         end
%         
%         function x=param2germ(param, y)
%             if isempty(param.param2germ_func)
%                 dist=get_set_germdist(param);
%                 string_warn=strvarexpand('There was no mapping set, the param is mapped to $dist.tostring$');
%                 warning(string_warn);
%             end
%             x=feval(param.param2germ_func,y);
%         end
%         
%         function y=germ2param(param, x)
%             if isempty(param.germ2param_func)
%                 dist=get_set_germdist(param);
%                 string_warn=strvarexpand('There was no mapping set, the param is mapped from $dist.tostring$');
%                 warning(string_warn);
%             end
%             y=feval(param.germ2param_func,x);
%         end
%     end

end
