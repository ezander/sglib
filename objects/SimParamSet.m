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
        param_map@SimpleMap
        prefer_normalized_polys@logical
    end
    
    %% Constructor and basic methods
    methods 
        function set=SimParamSet(varargin)
            % SIMPARAMSET Returns a new SimParamSet object.
            options=varargin2options(varargin, mfilename);
            [normalized, options]=get_option(options, 'prefer_normalized_polys', true);
            check_unsupported_options(options);
            
            set.param_map = SimpleMap();
            set.prefer_normalized_polys = normalized;
        end
        
        function set_normalized(set, normalized)
            if nargin<2
                normalized=true;
            end
            set.prefer_normalized_polys = normalized;
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
            if set.param_map.iskey(param.name)
                warning('sglib:gpcsimparams_add_parameter', 'The given SimParameter name is already the name of a parameter in the SimParameterSet, and will be overwritten')
            end
            set.param_map.add(param.name, param);
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
    
    
    %% Basic accessor methods
    methods
        function m=num_params(set)
            % NUM_PARAMS Number of parameters.
            %   N=NUM_PARAMS(SIMPARAMETERSET) gives the number of
            %   SimParameters in the SimParameterSet
            % Example: 
            %     n = set.num_params()
            m = set.param_map.count();
        end
        
        function ind=find_rv(set)
            % FIND_RV Find indices of RVs in the parameters.
            %   IND=FIND_RV(SET) returns a logical array IND, indicating
            %   which parameter in the parameter set is random (not fixed).
            m=set.num_params;
            ind=false(m,1);
            for i=1:m
                ind(i)=~set.param_map.values{i}.is_fixed;
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
            names = set.param_map.keys;
        end
        
        function plot_names=param_plot_names(set)
            % PARAM_PLOT_NAMES Name of all parameters (fixed and RVs) for plotting.
            %   Gives the PLOT_NAMEs of SimParameters in the SimParameterSet
            %   Example: P_NAMES=PARAM_PLOT_NAMES(SIMPARAMETERSET)
            m=set.num_params;
            plot_names=cell(m, 1);
            for i=1:m
                plot_names{i}=set.param_map.values{i}.plot_name;
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
        
        function params=get_params(set)
            % GET_PARAM Get all parameters from the set.
            %   PARAMS=GET_PARAM(SET) gets all the parameter from the
            %   parameters set.
            params = set.param_map.values;
        end
        function param=get_param(set, ind_or_string)
            % GET_PARAM Get one parameter from the set.
            %   PARAM=GET_PARAM(SET, IND_OR_STRING) gets the parameter
            %   IND_OR_STRING from the parameters set, where IND_OR_STRING
            %   can be the name or numerical index of the parameter.
            param = set.param_map.get(ind_or_string);
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
    
    %% Some basic statistical methods
    methods
        function q_mean=mean(set)
            % MEAN Return the mean values of this parameter set.
            %   Q_MEAN=MEAN(SET) returns a column vector containing the mean
            %   values of the parameters. Note that for fixed parameters,
            %   the mean is the fixed value.
            m = set.num_params();
            params = set.get_params();
            q_mean = zeros(m,1);
            for i=1:m
                q_mean(i)=params{i}.mean;
            end
        end

        function q_var=var(set, ignore_fixed)
            % VAR Return the variances of this parameter set.
            %   Q_VAR=VAR(SET) returns a column vector containing the
            %   variances of the parameters. Note that for fixed
            %   parameters, the variance is zero.
            if nargin<2
                ignore_fixed = false;
            end
            
            m = set.num_params();
            params = set.get_params();
            q_var = zeros(m,1);
            for i=1:m
                q_var(i)=params{i}.var(ignore_fixed);
            end
        end
        
        function p_q=pdf(set,q)
            % PDF Gives the probability density of the parameters.
            %   P_Q=PDF(SET, Q) returns the probability density function of
            %   the parameter set at point Q (which is the product of the
            %   separate probabilty densities for each contained
            %   parameters). If one of the parameters is fixed, the
            %   corresponding density is 1 if the parameter value matches
            %   exactly the fixed value, and 0 otherwise.
            m=set.num_params;
            assert(size(q,1)==m);
            n=size(q,2);
            params = set.get_params();
            p_q = ones(1,n);
            for i=1:m
                p_q=p_q.*params{i}.pdf(q(i,:));
            end
        end
        
        function p_q=cdf(set,q)
            % PDF Gives the parameterwise cumulative density of the parameters.
            m=set.num_params;
            assert(size(q,1)==m);
            n=size(q,2);
            params = set.get_params();
            p_q = nan(m,n);
            for i=1:m
                p_q(i,:)=params{i}.cdf(q(i,:));
            end
        end
    end
    
    %% Spectral methods
    methods
        function V_q=get_germ(set)
            % GET_GERM Generate the germ for this parameter set.
            % V_Q=GET_GERM(SET) creates the germ for active parameters
            % (i.e. the ones that are not fixed) and returns the
            % corresponding germ. Note, that for polynomial systems are
            % also registered for not-active parameters, so that the
            % resulting SYSCHARS are reproducible between calls (though I
            % don't know, whether that is really necessary...)
            syschars = '';
            for i=1:set.num_params()
                param=set.get_param(i);
                syschar=param.get_gpc_syschar(set.prefer_normalized_polys);
                if ~param.is_fixed
                    syschars(end+1)=syschar; %#ok<AGROW>
                end
            end
            V_q = gpcbasis_create(syschars);
        end
        
        function V_q=get_gpcgerm(set)
            % GET_GPCGERM Obsolete method, use GET_GERM instead.
            obsoletion_warning('SimParamSet.get_gpcgerm', 'SimParamSet.get_germ', 'Just get used to it!!!');
            V_q=get_germ(set);
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
                if param.is_fixed
                    qi_beta = param.fixed_val;
                    V = gpcbasis_create('');
                else
                    options = {'normalized', set.prefer_normalized_polys, expand_options{:}};
                    [qi_beta, V, varerrs(i)]=param.gpc_expand(options{:});
                end
                
                [q_alpha, V_q]=gpc_combine_inputs(q_alpha, V_q, qi_beta, V);
            end
        end
        
        function q_j_k = germ2params(set, xi_i_k)
            % GERM2PARAMS convert values of the germ to values of the parameters.
            %   Q_J_K = GERM2PARAMS(SET, XI_I_K) if XI_I_K is an array of
            %   values of the germ for this parameter set, Q_J_K is an array
            %   corresponding to the actual values of the parameters.
            m = set.num_params();
            q_j_k = zeros(m, size(xi_i_k,2));
            
            ind_rv = find(set.find_rv());
            ind_fixed = find(set.find_fixed());
            
            for i=1:length(ind_rv)
                j = ind_rv(i);
                q_j_k(j,:) = set.get_param(j).germ2param(xi_i_k(i,:));
            end
            for i=1:length(ind_fixed)
                j = ind_fixed(i);
                q_j_k(j,:) = set.get_param(j).fixed_val;
            end
        end
        
        function xi_i_k = params2germ(set, q_j_k)
            % PARAMS2GERM convert values of the parameters to values of the germ.
            %   XI_I_K = PARAMS2GERM(SET, Q_J_K) if Q_J_K is an array
            %   corresponding to the actual values of the parameters, then
            %   XI_I_K is an array of values of the germ for this parameter
            %   set,
            m = set.num_rv();
            ind_rv = find(set.find_rv());
            ind_fixed = find(set.find_fixed());
            
            xi_i_k = zeros(m, size(q_j_k,2));
            for i=1:length(ind_rv)
                j = ind_rv(i);
                xi_i_k(i,:) = set.get_param(j).param2germ(q_j_k(j,:));
            end
            
            for i=1:length(ind_fixed)
                j = ind_fixed(i);
                % assert(all(q_j_k(j,:) == set.get_param(j).fixed_val));
            end
        end
        
        function [q_i, xi_i]=sample(set, N, varargin)
            % SAMPLE Sample from the parameters.
            %   [Q_I, XI_I]=SAMPLE(SET, N, OPTIONS) returns a set of N
            %   samples for this parameter set. The XI_I are in "germ
            %   space", while the Q_I are in parameter space. The OPTIONS
            %   are passed on the GPCGERM_SAMPLE function (for options see
            %   there).
            %
            % See also GPCGERM_SAMPLE
            V_q = set.get_germ();
            xi_i = gpcgerm_sample(V_q, N, varargin{:});
            q_i = germ2params(set, xi_i);
        end
        
        function [q_i, w, xi_i]=get_integration_points(set, p_int, varargin)
            % GET_INTEGRATION_POINTS Generate integration points.
            %   [Q_I, W, XI_I]=GET_INTEGRATION_POINTS(SET, P_INT, OPTIONS)
            %   generates integration point for integration over this
            %   parameter set. For options see GPC_INTEGRATE.
            %
            % See also GPC_INTEGRATE
            V_q = set.get_germ();
            [xi_i, w] = gpc_integrate([], V_q, p_int, varargin{:});
            q_i = germ2params(set, xi_i);
        end
    end
    
        
    %% Other methods
    methods    
        function string=tostring(set, varargin)
            % TOSTRING Convert to string.
            %   STRING=TOSTRING(SET, OPTIONS) returns a string representing
            %   this parameter set. With the option 'as_cell_array' instead
            %   of one string, a cell array of string of all parameters if
            %   returned.
            options=varargin2options(varargin, mfilename);
            [as_cell_array, options]=get_option(options, 'as_cell_array', false);
            check_unsupported_options(options);
            
            m=set.num_params;
            str=cell(m,1);
            for i=1:m
                str{i}=set.get_param(i).tostring;
            end
            if as_cell_array
                string = str;
            else
                string = strvarexpand('$str$');
            end
        end
    end
end
