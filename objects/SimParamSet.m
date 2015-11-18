classdef SimParamSet < handle
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
    %% Properties
    properties (GetAccess=public, SetAccess=protected)
        simparams
    end
    
    methods
        %% Constructor
        function set=SimParamSet(varargin)
            % Returns a new SimParamSet object
            % that by default sets the simparams independent
            % e.g.: MYPARAMSET=SimParamset()
            %         MYPARAMSET=SimParamset(param1,param2)
            %where PARAM1 and PARAM2 are SIMPARAMETER objects
            
            % initialize properties
            set.simparams=struct;
            if nargin>0
                set.add_parameter(varargin{:});
            end
        end
        
        %% Add parameter(s) to SimParamSet
        function add_parameter(set, varargin)
            % Adds the P parameters to the SimParamSet object
            p=varargin;
            for i=1:length(p)
                check_type(p{i}, 'SimParameter', true, 'Inputs of SimParamSet', mfilename);
                if isfield(set.simparams, p{i}.name)
                    warning('sglib:gpcsimparams_add_parameter', 'The given SimParameter name is already the name of a parameter in the SimParameterSet, and will be overwritten')
                end
                set.simparams.(p{i}.name)=p{i};
            end
        end
        %% Fix SimParameters in the ParamSet
        
        function set_fixed(set, p, vals)
            % Fixes the values of SimParams(P1, P2..)more, and accordingly the
            % probability distribution of them are ignored
            %
            % SET.SET_FIXED(SET, P1, VAL1)
            % SET_FIXED(SET, {P1, P2...}, [VAL1, VAL2])
            % fixes P_1, P_2... simparams to the values VAL_1 and VAL_2..
            %
            % SET_FIXED(SET, P_1)
            % SET_FIXED({SET, P_1, P_2...})
            % fixes  P_1, P_2... simparams to their mean values (calculated
            % from their distribution)
            %
            % SET_FIXED(SET)
            % fixes all SimParams in the SimParamSet SET to their mean
            % values
            %
            %P_1, P_2.. is the NAME of SimParameters that are already
            % added to the SimParamSet SET
            % but alternatively can be a SimParameter
            % itself, but in this case only the NAME of P1 is taken, the
            % other properties are ignored
            
            if nargin<2 || isempty(p)
                p=set.param_names();
            end
            if ~iscell(p)
                p={p};
            end
            if nargin>2&&isscalar(vals)
                vals=repmat(vals,size(p));
            elseif nargin>2&&~isscalar(vals)
                check_boolean(length(p)==length(vals), 'length of VAL does not match with the one of the SIMPARAMS', mfilename);
            end
            for i=1:length(p)
                if nargin>2 %if value is specified
                    if isa(p{i}, 'char')
                        set.simparams.(p{i}).set_fixed(vals(i));
                    elseif isa(p{i}, 'SimParameter')
                        set.simparams.(p{i}.name).set_fixed(vals(i));
                    else
                        error('sglib:gpcsimparams_set_fixed', 'wrong format of P: P parameter has to be either the name of the SimParameter, or the SimParameter itself')
                    end
                else %if value is not specified, fix at the mean value
                    if isa(p{i}, 'char')
                        set.simparams.(p{i}).set_to_mean();
                    elseif isa(p{i}, 'SimParameter')
                        set.simparams.(p{i}.name).set_to_mean();
                    else
                        error('sglib:gpcsimparams_set_fixed', 'wrong format of P: P parameter has to be either the name of the SimParameter, or the SimParameter itself')
                    end
                    
                end
            end
        end
        %% Release SimParameters in the ParamSet
        function set_not_fixed(set, p)
            % SET_NOT_FIXED(SET, P) releases the
            % SimParameters P  from being fixed to random variables
            % SET.SET_NOT_FIXED(SET, P1, VAL1)
            % SET_FIXED(SET, {P1, P2...})
            % releases P_1, P_2... simparams to be not fixed but Random
            % Variables
            %
            % SET_NOT_FIXED(SET)
            % releases all SimParams in the SimParamSet SET
            %
            % P_1, P_2.. is the NAME of SimParameters that are already
            % added to the SimParamSet SET
            % but alternatively can be a SimParameter
            % itself, but in this case only the NAME of P1 is taken, the
            % other properties are ignored
            if nargin<2
                p=fieldnames(set.simparams);
            end
            if ~iscell(p)
                p={p};
            end
            
            for i=1:length(p)
                if isa(p{i}, 'char')
                    set.simparams.(p{i}).set_not_fixed();
                elseif isa(p{i}, 'SimParameter')
                    set.simparams.(p{i}.name).set_not_fixed();
                else
                    error('sglib:gpcsimparams_set_fixed', 'wrong format of P: P parameter has to be either the name of the SimParameter, or the SimParameter itself')
                end
            end
        end
        
        %% Change Distribution of  SimParameters in the ParamSet
        function set_dist(set, p, dist)
            % SET_DIST(SET, P, DIST)
            % Changes the distribution of the SimParam(s) P in
            % the SimParamSet SET to have
            % distribution(s) DIST
            % If the SET.(P) SimParameter was fixed, it will be released
            % If no P is given, it changes all
            % SimParameters in the SimParamSet SET
            %
            % P={P_1, P_2, ..} or P=P1
            % where P1, P2, .. are the NAME of SimParameters that are already
            % added to the SimParamSet SET
            % Alternatively P1, P2, . can be a SimParameters
            % itself, but in this case only the NAME of P1, P2, .. is taken, the
            % other properties are ignored
            
            if isempty(p)
                p=set.names();
            end
            if ~iscell(p)
                p={p};
            end
            if ~iscell(dist)&&isa(dist, 'Distribution')&&length(dist)==1
                dist=repmat({dist},size(p));
            elseif iscell(dist)
                check_boolean(length(p)==length(dist), 'length of DIST does not match with the one of the PARAM_NAMES', mfilename);
            end
            
            for i=1:length(p)
                if isa(p{i}, 'char')
                    set.simparams.(p{i}).set_dist(dist{i});
                elseif isa(p{i}, 'SimParameter')
                    set.simparams.(p{i}.name).set_dist(dist{i});
                else
                    error('sglib:gpcsimparams_set_dist', 'wrong format of P: P parameter has to be either the name of the SimParameter, or the SimParameter itself')
                end
            end
        end
        
        %% Sample from SimParamSet
        function xi=sample(set, N, varargin)
            % Samples from the SimParamSet object
            %
            % e.g.: [samples, info]=param_set.sample(N, 'mode', 'qmc', 'qmc_options', {'shuffles', 'true'});
            % options: 'mode': 'mc' (Monte Carlo) /
            %                           'qmc' (quasi Monte Carlo, Halton sequence) /
            %                           'lhs' (quasi Monte Carlo,  Latin-hypercubic)
            %               'rand_func': any function handle generating
            %               samples rund_func(N, num_variables)
            
            options=varargin2options(varargin);
            [mode,options]=get_option(options, 'mode', 'default');
            [rand_func,options]=get_option(options, 'rand_func', []);
            [qmc_options,options]=get_option(options, 'qmc_options',  {});
            [sample_from_germ,options]=get_option(options, 'sample_from_germ',  false);
            check_unsupported_options(options, mfilename);
            
            % Properties description
            m              =set.num_params();
            m_RV           =set.num_RVs();
            RVs            =set.RV_names();
            ind_RV         =set.find_ind_RV();
            fixed_vals     =set.find_fixed_vals();
            
            % Send warning if all SIMPARAMS are fixed, and change N to 1
            if m_RV==0
                warning('sglib:gpcsimparams_sample', 'can not sample, only determinstic values are given because there are no random variables in the SIMPARAMSET, use SET_NOT_FIXED method to release parameters')
                xi=fixed_vals;
                return
            end
            % Generate standard uniform samples
            switch(mode)
                case {'mc', 'default'}
                    U = rand(N,m_RV);
                    if ~isempty(rand_func)
                        U = funcall(rand_func, N, m_RV);
                        if any(size(U)~=[N, m_RV])
                            error('sglib:gpcsimparams_sample', 'rand_func did not return an array of the expect size [%d,%d], but [%d,%d]', n, m, size(U,1), size(U,2));
                        end
                    end
                case 'qmc'
                    U = halton_sequence(N, m_RV, qmc_options);
                case 'lhs'
                    U = lhs_uniform(N, m_RV);
                otherwise
                    error('sglib:SimParamSet.sample, unknown paramter value "%s" for option "mode"', mode);
            end
            
            % Generate samples from the distributions of the unfixed
            % parameters
            xi_RV=zeros(size(U));
            for i=1:m_RV
                if sample_from_germ
                    dist_i= set.simparams.(RVs{i}).germ_dist;
                    if isempty(dist_i)
                        dist_i=get_set_germdist(set.simparams.(RVs{i}));
                    end
                    xi_RV(:,i)=dist_i.invcdf((U(:,i)));
                else
                    xi_RV(:,i)=set.simparams.(RVs{i}).dist.invcdf((U(:,i)));
                end
            end
            % add  columns with the fixed values to the samples
            if m>m_RV
                xi=zeros(N,m);
                xi(:,ind_RV)=xi_RV;
                
                if sample_from_germ
                    map_func=RVs2germ_func(set, 'ind', ~ind_RV);
                    vals=zeros(size(fixed_vals));
                    for j=1:length(fixed_vals)
                        vals(j)=feval(map_func{j}, fixed_vals(j));
                    end
                    xi(:,~ind_RV)=repmat(vals', N, 1);
                else
                    xi(:,~ind_RV)=repmat(fixed_vals', N, 1);
                end
            else
                xi=xi_RV;
            end
        end
        
        %% Set gPC basis
        function  [a_beta, V_p, varserr]=gpc_expand_RVs(set, varargin)
            % Expands the maping between reference parameters (germs)
            % with standard probability distribution to the global
            % parameters (set of not fixed SimParameters in the SimParamSet) in
            % general Polynomial Chaos, see more in  GPC_PARAM_EXPAND
            
            options=varargin2options(varargin);
            [polysys,options]=get_option(options, 'polysys', '');
            [expand_options,options]=get_option(options, 'expand_options', {});
            check_unsupported_options(options, mfilename);
            
            m_RV           =set.num_RVs();
            RVs            =set.RV_names();
            
            if m_RV==0;
                error('sglib:gpcsimparams_sample', 'can not sample, there are no random variables in the SIMPARAMSET, use SET_NOT_FIXED method to releas parameters')
            end
            varserr=zeros(1, m_RV);
            for i=1:m_RV
                [a_alpha, V, varerr]=gpc_expand(set.simparams.(RVs{i}), 'polysys', polysys, 'expand_options', expand_options);
                varserr(i)=varerr;
                
                if i==1
                    a_beta=a_alpha;
                    V_p=V;
                else
                    [a_beta, V_p]=gpc_combine_inputs(a_beta, V_p, a_alpha, V);
                end
            end
        end
        
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
            [polysys,options]=get_option(options, 'polysys', '');
            [expand_options,options]=get_option(options, 'expand_options', {});
            [grid, options] = get_option(options, 'grid', 'smolyak');
            check_unsupported_options(options, mfilename);
            
            % generate gpc basis for the parameters
            [p_beta, V_p, gpc_vars_err]=set.gpc_expand_RVs('polysys', polysys, 'expand_options', expand_options);
            % generate integration points for the gPC germs (x_ref)
            [x_ref, w] = gpc_integrate([], V_p, p_int, 'grid', grid);
            % map integration points to the parameter set
            x_p=set.gpc_evaluate( p_beta, V_p, x_ref);
        end
        %% Generate integration point from gPC
        function   x_p = gpc_evaluate(set, p_beta, V_p, x_ref, varargin)
            % [X, W, X_REF] = GPC_EVALUATE(P_BETA, V_P, X_REF)
            % Evaluate parameters X_REF germ coordinate points for the SimParameters in the
            % SIMPARAMSET object. Should be used in combination of
            % GENERATE_INTEGRATION_POINTS
            % with the inputs:
            %    -P_BETA, V_P: gPCE coefficient and basis of the set of the not fixed
            %        SimParameters in the SimParameterSet
            %    -X_REF:  coordinates of the gPCE germs
            %    -X : coordinates in the parameteric coordinate system
            
            % Example:
            % [p_beta, V_p, ~]=set.gpc_expand_RVs('polysys', 'h')
            % [x_ref, w] = gpc_integrate([], V_p, p_int, 'grid', 'smolyak');
            % x_p = gpc_evaluate(p_beta, V_p, x_ref)
            
            m              =set.num_params();
            m_RV           =set.num_RVs();
            ind_RV         =set.find_ind_RV();
            
            n=size(x_ref, 2);
            
            %map integration points to the parameter's domain with the gPCE
            x=gpc_evaluate(p_beta, V_p, x_ref);
            
            % if there are fixed parameters, insert fixed values
            if m>m_RV
                x_p=zeros(m,n);
                x_p(ind_RV,:)=x;
                x_p(~ind_RV,:)=repmat(set.find_fixed_vals(), 1, n);
            else
                x_p=x;
            end
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
        %% Number of parameters
        function m=num_params(set)
            % Gives the number of SimParameters in the SimParameterSet
            % Example: N=NUM_PARAMS(SIMPARAMETERSET)
            m=length(fieldnames(set.simparams));
        end
        
        %% Name of all parameters (fixed and RVs)
        function p=param_names(set)
            % Gives the NAMEs of SimParameters in the SimParameterSet
            % Example: P_NAMES=PARAM_NAMES(SIMPARAMETERSET)
            p=fieldnames(set.simparams);
        end
        
        %% Name of all parameters (fixed and RVs) for plot
        function p_names=param_plot_names(set)
            % Gives the PLOT_NAMEs of SimParameters in the SimParameterSet
            % Example: P_NAMES=PARAM_PLOT_NAMES(SIMPARAMETERSET)
            p=set.param_names();
            m=set.num_params;
            p_names=cell(m, 1);
            for i=1:m
                p_names{i}=set.simparams.(p{i}).plot_name;
            end
        end
        
        %% Find indices of RVs in the param names
        function ind_RV=find_ind_RV(set)
            % IND_RV=FIND_IND_RV(SIMPARAMSET)
            % gives a logical array IND_RV, telling which parameter in the
            % PARAMETERSET is random
            % Example:
            % ind_RV=find_ind_RV(SimParamSet)
            % List_of_RVs=SimParamSet.param_names
            
            p=set.param_names();
            m=set.num_params();
            ind_RV=false(m,1);
            
            for i=1:m
                if ~set.simparams.(p{i}).is_fixed;
                    ind_RV(i)=true;
                end
            end
        end
        
        %% Number of random variables
        function m_RVs=num_RVs(set)
            % gives the N_RV number of not fixed SimParameter's in the
            % SimParameterSet
            % N_RV=RV_NAMES(SIMPARAMETERSET)
            ind_RV=set.find_ind_RV;
            m_RVs=sum(ind_RV);
        end
        
        %% Name of Random Variables
        function RVs=RV_names(set)
            % collects  NAMES of not fixed SimParameter's
            % RV_NAMES=RV_NAMES(SIMPARAMETERSET)
            p=set.param_names();
            ind_RV=set.find_ind_RV();
            RVs=p(ind_RV);
        end
        
        %% Name of Random Variables for plot
        function RV_names=RV_plot_names(set)
            % collects  PLOT_NAMES of not fixed SimParameter's
            % RV_NAMES=RV_PLOT_NAMES(SIMPARAMETERSET)
            m_RV=set.num_RVs;
            RVs=set.RV_names();
            
            RV_names=cell(m_RV,1);
            for i=1:m_RV
                RV_names{i}=set.simparams.(RVs{i}).plot_name;
            end
        end
        
        
        %% Find fixed values of the fixed parameters in the parameterset
        function fixed_vals=find_fixed_vals(set)
            % collects fixed values of fixed parameters in the
            % SimParameterSet FIXED_VALS=FIND_FIXED_VALS(SIMPARAMSET)
            p=set.param_names();
            ind_RV=set.find_ind_RV();
            fixed_p=p(~ind_RV);
            
            fixed_vals=zeros(size(fixed_p));
            for i=1:length(fixed_p)
                fixed_vals(i)=set.simparams.(fixed_p{i}).fixed_val;
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
            p=set.param_names();
            m=set.num_params;
            str=cell(m,1);
            for i=1:m
                str{i}=set.simparams.(p{i}).tostring;
            end
            %string=strcat(str{:});
            string=str;
        end
        function disp(simparam)
            disp(simparam.tostring());
        end
    end
end

