classdef SimParamSet < SglibHandleObject
    %SIMPARAMSET Constructs a set of optionally random parameters,
    %
    %MYPARAMSET=SIMPARAMSET() constructs parameterset supposing a set of independent
    % random variables
    %
    %Example 1 (<a href="matlab:run_example SimParamSet 1">run</a>)
    % %Define SimParameters
    %       param1=SimParameter('p1', UniformDistribution(2,3));
    %       param2=SimParameter('p2', NormalDistribution(1,0.1)) ;
    %       param3=SimParameter('p3', BetaDistribution(3,3));
    %       param4=SimParameter('p4', UniformDistribution(1,2));
    %
    % % Define SimParamSet MYPARAMS and
    % % add to it the SimParams PARAM1, PARAM2, PARAM3 and PARAM4
    %       myparams=SimParamSet(param1, param2);
    %       myparams.add_parameter(param3, param4);
    %
    % % Fix and release SimParams in MYPARAMS:
    % % Fix PARAM3 (with name 'P2') to the value 1.5 and
    % % PARAM4 (with name 'P4') to the value 2
    % % and then,
    % % release PARAM 4 to be not fixed
    %       myparams.set_fixed({'p3', param4}, [1.5, 2])
    %       myparams.set_not_fixed('p3')
    %
    % % Sample from MYPARAMS and plot sample points
    %   xi=myparams.sample(10000);
    %   scatter3(xi(:,1), xi(:,2), xi(:,3));
    %   xlabel(myparams.param_names{1});
    %   ylabel(myparams.param_names{2});
    %   zlabel(myparams.param_names{3});
    %
    % Example 2 (<a href="matlab:run_example SimParamSet 2">run</a>)
    %         beta=SimParameter('beta',UniformDistribution(-10,-6.5), '\beta');
    %         beta_t=SimParameter('beta_T',UniformDistribution(-1,0.1), '\beta_T');
    %         c_t=SimParameter('c_t',UniformDistribution(0,0.2));
    %         c_eh=SimParameter('c_eh',UniformDistribution(0,0.3), 'c_{\epsilon^h}');
    %         c_wd=SimParameter('c_wd',UniformDistribution(2,30),  'c_{wd}');
    %         c_dp=SimParameter('c_dp',UniformDistribution(0,0.395),  'c_{d,p}');
    %
    %         PSet=SimParamSet(beta, beta_t, c_t, c_eh, c_wd, c_dp);
    %         PSet.set_fixed({'beta', 'c_wd'})
    %
    %         x_MC=PSet.sample(1000);
    %         x_QMC=PSet.sample(1000, 'mode', 'qmc');
    %         x_LHS=PSet.sample(1000, 'mode', 'lhs');
    %         [x_int,w_int]=PSet.generate_integration_points( 5, 'grid', 'smolyak');
    
    % See also SIMPARAMETER DISTRIBUTION
    
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
        %simparams
        params
        normalized_polys
    end
    
    %% Constructor and basic methods
    methods 
        function set=SimParamSet(varargin)
            % SIMPARAMSET Returns a new SimParamSet object.
            options=varargin2options(varargin, mfilename);
            [normalized, options]=get_option(options, 'normalized_polys', true);
            check_unsupported_options(options);
            
            %set.simparams = struct();
            set.params = SimpleMap();
            set.normalized_polys = normalized;
        end
        
        function set_normalized(set, normalized)
            if nargin<2
                normalized=true;
            end
            set.normalized_polys = normalized;
        end
    end
    
    %% Basic accessor methods
    methods
        function m=num_params(set)
            % NUM_PARAMS Number of parameters.
            %   N=NUM_PARAMS(SIMPARAMETERSET) gives the number of
            %   SimParameters in the SimParameterSet
            % Example: 
            %     n = set.num_params()
            m = set.params.count();
        end
        
        function ind=find_rv(set)
            % FIND_RV Find indices of RVs in the parameters.
            %   IND=FIND_RV(SET) returns a logical array IND, indicating
            %   which parameter in the parameter set is random (not fixed).
            m=set.num_params;
            ind=false(m,1);
            for i=1:m
                ind(i)=~set.params.values{i}.is_fixed;
            end
        end

        function ind=find_fixed(set)
            % FIND_FIXED Find indices of fixed parameters.
            %   IND=FIND_FIXED(SET) returns a logical array IND, indicating
            %   which parameter in the parameter set SET is fixed.
            ind = ~find_rv(set);
        end

        function m_rv=num_rv(set)
            % NUM_RVS Number of random variables.
            %   N_RV=RV_NAMES(SIMPARAMETERSET) gives the N_RV number of not
            %   fixed SimParameter's in the SimParameterSet
            m_rv=sum(set.find_rv());
        end
        
        function names=param_names(set)
            % PARAM_NAMES Name of all parameters (fixed and RVs).
            %   Gives the NAMEs of SimParameters in the SimParameterSet
            %   Example: P_NAMES=PARAM_NAMES(SIMPARAMETERSET)
            %names=fieldnames(set.simparams);
            names = set.params.keys();
        end
        
        function plot_names=param_plot_names(set)
            % PARAM_PLOT_NAMES Name of all parameters (fixed and RVs) for plotting.
            %   Gives the PLOT_NAMEs of SimParameters in the SimParameterSet
            %   Example: P_NAMES=PARAM_PLOT_NAMES(SIMPARAMETERSET)
            m=set.num_params;
            plot_names=cell(m, 1);
            for i=1:m
                plot_names{i}=set.params.values{i}.plot_name;
            end
        end
        
        function rv_names=rv_names(set)
            % RV_NAMES Names of random variables.
            %   RV_NAMES=RV_NAMES(SIMPARAMETERSET) collects the NAMES of
            %   not fixed SimParameters
            names=set.param_names();
            ind_rv=set.find_rv();
            rv_names=names(ind_rv);
        end
        
        function rv_plot_names=rv_plot_names(set)
            % RV_PLOT_NAMES Name of Random Variables for plotting.
            %   RV_NAMES=RV_PLOT_NAMES(SIMPARAMETERSET) collects
            %   PLOT_NAMES of not fixed SimParameter's
            plot_names=set.param_plot_names();
            ind_rv=set.find_rv();
            rv_plot_names=plot_names(ind_rv);
        end
        
        function param=get_param(set, ind_or_string)
            param = set.params.get(ind_or_string);
        end
        
        function fixed_vals=get_fixed_vals(set)
            % FIND_FIXED_VALS Find fixed values of the fixed parameters.
            %   FIXED_VALS=FIND_FIXED_VALS(SET) collects fixed values of
            %   fixed parameters in the SimParameterSet.
            ind_fixed=find(set.find_fixed());
            
            fixed_vals=zeros(length(ind_fixed),1);
            for i=1:length(ind_fixed)
                fixed_vals(i)=set.get_param(ind_fixed(i)).fixed_val;
            end
        end
    end
    
    %% Adding parameters
    methods 
        function add(set, param, varargin)
            % ADD Add a parameter to the param set.
            if ischar(param)
                param = SimParameter(param, varargin{:});
            end
            check_type(param, 'SimParameter', true, 'Inputs of SimParamSet', mfilename);
            if set.params.iskey(param.name)
                warning('sglib:gpcsimparams_add_parameter', 'The given SimParameter name is already the name of a parameter in the SimParameterSet, and will be overwritten')
            end
            set.params.add(param.name, param);
        end
        
        
        function add_parameter(set, varargin)
            % ADD_PARAMETER Add parameter(s) to SimParamSet
            % Adds the P parameters to the SimParamSet object
            p=varargin;
            for i=1:length(p)
                set.add(p{i});
            end
        end
    end
    
    %% Fixing parameters
    methods 
        function set_fixed(set, name_or_ind, val)
            % SET_FIXED Fix SimParameters in the ParamSet to a constant value.
            %   SET.SET_FIXED(NAME, VAL) fixes simparam NAME to the value
            %   VAL. SET.SET_FIXED(INDEX, VAL) fixes simparam number INDEX
            %   to the value VAL.
            param = set.get_param(name_or_ind);
            param.set_fixed(val);
        end

        function set_to_mean(set, name_or_ind)
            % SET_TO_MEAN Fix SimParameters in the ParamSet to its mean value.
            %   SET.SET_TO_MEAN(NAME) or SET.SET_TO_MEAN(INDEX) fixes the
            %   parameter to its mean value (calculated from its
            %   distribution)
            % See also SET_FIXED, SET_NOT_FIXED
            param = set.get_param(name_or_ind);
            param.set_to_mean();
        end
        
        function set_not_fixed(set, name_or_ind)
            % SET_NOT_FIXED Release SimParameters in the ParamSet.
            %   SET_NOT_FIXED(SET, NAME) and SET_NOT_FIXED(SET, INDEX)
            %   releases the parameters indicated by NAME or INDEX from
            %   being fixed to random variables.
            param = set.get_param(name_or_ind);
            param.set_not_fixed();
        end
        
        function reset_fixed(set)
            % RESET_FIXED Resets fixed state for all parameters.
            %   RESET_FIXED(SET) resets the fixed state for all parameters
            %   in the ParamSet SET.
            % See also SET_NOT_FIXED
            for i=1:set.num_params
                set.set_not_fixed(i);
            end
        end
        
        function set_dist(set, name_or_ind, dist)
            % SET_DIST Change the distribution of a parameter.
            %   SET_DIST(SET, NAME, DIST)changes the distribution of the
            %   parameter indicated by NAME or INDEX in the SET to have
            %   distribution DIST. If the Parameter was fixed, it will be
            %   released.
            param = set.get_param(name_or_ind);
            param.set_dist(dist);
        end
    end
    
    %% GPC based methods
    methods
        function V_q=get_gpcgerm(set)
            % GET_GPCGERM Generate the GPC germ for this parameter set.
            % V_Q=GET_GPCGERM(SET) creates the germ for active parameters
            % (i.e. the ones that are not fixed) and returns the
            % corresponding GPC germ. Note, that for polynomial systems are
            % also registered for not-active parameters, so that the
            % resulting SYSCHARS are reproducible between calls (though I
            % don't know, whether that is really necessary...)
            syschars = '';
            for i=1:set.num_params()
                param=set.get_param(i);
                syschar=param.get_gpc_syschar(set.normalized_polys);
                if ~param.is_fixed()
                    syschars(end+1)=syschar; %#ok<AGROW>
                end
            end
            V_q = gpcbasis_create(syschars);
        end
        
        function  [q_alpha, V_q, varerrs]=gpc_expand(set, varargin)
            % GPC_EXPAND Expand parameters into GPC representation.
            %   Expands the maping between reference parameters (germs)
            %   with standard probability distribution to the global
            %   parameters (set of not fixed SimParameters in the
            %   SimParamSet) in general Polynomial Chaos.
            %   See also GPC_PARAM_EXPAND
            
            options=varargin2options(varargin);
            [expand_options,options]=get_option(options, 'expand_options', {});
            check_unsupported_options(options, mfilename);
            
            m = set.num_params();
            varerrs = zeros(1, m);
            q_alpha=zeros(0,1);
            V_q=gpcbasis_create('');
            for i=1:m
                param = set.get_param(i);
                if param.is_fixed()
                    qi_beta = param.fixed_val;
                    V = gpcbasis_create('');
                else
                    options = {'normalized', set.normalized_polys, 'expand_options', expand_options};
                    [qi_beta, V, varerrs(i)]=param.gpc_expand(options{:});
                end
                
                [q_alpha, V_q]=gpc_combine_inputs(q_alpha, V_q, qi_beta, V);
            end
        end
        
        %% Sample from SimParamSet
        function q_i = gpcgerm2params(set, xi_i)
            m = set.num_params();
            q_i = zeros(m, size(xi_i,2));
            
            ind_rv = find(set.find_rv());
            ind_fixed = find(set.find_fixed());
            
            for i=1:length(ind_rv)
                j = ind_rv(i);
                q_i(j,:) = set.get_param(j).germ2param(xi_i(i,:));
            end
            for i=1:length(ind_fixed)
                j = ind_fixed(i);
                q_i(j,:) = set.get_param(j).fixed_val;
            end
        end
        
        function [q_i, xi_i]=sample(set, N, varargin)
            V_q = set.get_gpcgerm();
            xi_i = gpcgerm_sample(V_q, N, varargin{:});
            q_i = gpcgerm2params(set, xi_i);
        end
        
        function [q_i, w, xi_i]=integrate(set, p_int, varargin)
            V_q = set.get_gpcgerm();
            [xi_i, w] = gpc_integrate([], V_q, p_int, varargin{:});
            q_i = gpcgerm2params(set, xi_i);
        end
    end
    
    
    
    %% Other methods
    methods    
        
        %% Generate integration points
        function  [x_p, w, x_ref, gpc_vars_err] =generate_integration_points(set, p_int, varargin)
            % [X, W, X_REF, GPC_VARS_ERR] =GENERATE_INTEGRATION_POINTS(SIMPARAMSET,
            % P_INT)
            % Generates integration points for the SimParameters in the
            % SIMPARAMSET object. The points are given from quadrature
            % rules for the not fixed SimParameters, while the coordinates
            % of the fixed SimParameters are set to the fixed value. First
            % a maping is defined in gPCE from some reference parameters (germs)
            % to the  not fixed SimParameters. The integration point
            % is generated in the reference coordinate system, and then maped
            % back with the gPCE-map to the coord sys. defined by the SimParameters
            %
            % with the inputs:
            %    -P_INT:  integration order (derived from P_INT-point univariate rule)
            % optional inputs
            %    -'POLYSYS': polynomial system of the gpc_maping
            % ('H'/'h': Hermite, 'P'/'p': Legendre...see more in GPCBASIS_CREATE)
            %        If not defined, then the polynomial system is
            %        generated depending on the distributions of the
            %        SimParameters
            %    - 'EXPAND_OPTIONS': see more in the optional inputs of GPC_PARAM_EXPAND
            %    - 'GRID': full tensor or sparse integration rule 'FULL_TENSOR' /'SMOLYAK'(default)
            % whith the outputs
            %
            %    -X : coordinates of the
            %        integration points in the parameteric coordinate system
            %    -W: weights
            %    -X_REF: coordinates in the reference
            %        coordinate system of the integration points
            %    -GPC_VARS_ERR: error in the variance from the gPCE
            
            
            options=varargin2options(varargin);
            [expand_options,options]=get_option(options, 'expand_options', {});
            [grid, options] = get_option(options, 'grid', 'smolyak');
            check_unsupported_options(options, mfilename);
            
            % generate gpc basis for the parameters
            V_q = set.get_gpcgerm();
            [p_beta, V_p, gpc_vars_err]=set.gpc_expand('expand_options', expand_options);
            % generate integration points for the gPC germs (x_ref)
            [x_ref, w] = gpc_integrate([], V_p, p_int, 'grid', grid);
            % map integration points to the parameter set
            x_p=gpc_evaluate( p_beta, V_p, x_ref);
        end
        
        %% Get mappings from germ to simparam in a cell for every random variable
        function map_func=germ2RVs_func(set, varargin)
            % all the mappings from germ to the parameters in a cell format
            % if there were no germs defined for the simparams, it
            % will be automatically generated from the base distribution of
            % the simparams distribution
            options=varargin2options(varargin);
            [ind,options]=get_option(options, 'ind', []);
            check_unsupported_options(options, mfilename);
            p=set.param_names();
            m=set.num_params;
            map_func=cell(m,1);
            for i=1:m
                if isempty(set.simparams.(p{i}).germ_dist)
                    [~, func_i, ~]=get_set_germdist(set.simparams.(p{i}));
                else
                    func_i=set.simparams.(p{i}).germ2param_func;
                end
                map_func{i}=func_i;
                if ~isempty(ind)
                    map_func=map_func(ind);
                end
            end
        end
                   %% Get mappings from simparamto germ in a cell for every random variable
        function map_func=RVs2germ_func(set, varargin)
            % all the mappings from germ to the parameters in a cell format
            % if there were no germs defined for the simparams, it
            % will be automatically generated from the base distribution of
            % the simparams distribution
            
            options=varargin2options(varargin);
            [ind,options]=get_option(options, 'ind', []);
            check_unsupported_options(options, mfilename);
            
            p=set.param_names();
            m=set.num_params;
            map_func=cell(m,1);
            for i=1:m
                if isempty(set.simparams.(p{i}).germ_dist)
                    [~, ~, func_i]=get_set_germdist(set.simparams.(p{i}));
                else
                    func_i=set.simparams.(p{i}).param2germ_func;
                end
                map_func{i}=func_i;
            end
            if ~isempty(ind)
                map_func=map_func(ind);
            end
        end
        
        
        
        %% Gives the mean values of the all the parameters in the parameterset
        function means=mean_vals(set)
            % gives the mean values of all the parameters in the
            % SIMPARAMETERSET
            p=set.param_names();
            m=set.num_params;
            means=zeros(m, 1);
            for i=1:m
                means(i)=set.simparams.(p{i}).mean;
            end
        end
        
        %% Gives the variances of the all the parameters in the parameterset
        %         function vars=vars(set)
        %             % gives the variances of all the parameters in the
        %             % SIMPARAMETERSET
        %             p=set.param_names();
        %             m=set.num_params;
        %             vars=zeros(m, 1);
        %             for i=1:m
        %                 vars(i)=set.simparams.(p{i}).var;
        %             end
        %         end
        %% Gives the variances of the all the parameters in the parameterset
        function v=var_vals(set)
            % gives the variances of all the parameters in the
            % SIMPARAMETERSET
            p=set.param_names();
            m=set.num_params;
            v=zeros(m, 1);
            for i=1:m
                v(i)=set.simparams.(p{i}).var;
            end
        end
        %% Gives the probability that the parameters
        % take value x
        function prob=pdf(set,x)
            
            p=set.param_names();
            m=set.num_params;
            
            prob=1;
            for i=1:m
                prob=set.simparams.(p{i}).pdf(x(i))*prob;
            end
            
        end
  
        %% give germ distributions in a cell
        function dists=germ_dist(set, varargin)
            % all the mappings from germ to the parameters in a cell format
            p=set.param_names();
            m=set.num_params;
            dists=cell(m,1);
            for i=1:m
                if set.simparams.(p{i}).is_fixed
                    dists{i}={};
                else
                    dists{i}=set.simparams.(p{i}).germ_dist;
                    if isempty(dists{i})
                        dist_i=get_set_germdist(set.simparams.(p{i}));
                        string_warn=strvarexpand('There was no mapping set, the param is mapped to $dist_i.tostring$');
                        warning(string_warn);
                        dists{i}=dist_i;
                    end
                end
            end
        end
        %%
        function string=tostring(set, varargin)
            % all the mappings from germ to the parameters in a cell format
            m=set.num_params;
            str=cell(m,1);
            for i=1:m
                str{i}=set.get_param(i).tostring;
            end
            %string=strcat(str{:});
            string=str;
        end
    end
end
