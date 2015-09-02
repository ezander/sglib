classdef SimParamSet1 < handle
    %SIMPARAMSET Constructs a set of optionally random parameters,
    %
    %MYPARAMSET=SIMPARAMSET() constructs parameterset supposing a set of independent
    % random variables
    %
    %Example 1 (<a href="matlab:run_example SimParamSet1 1">run</a>)
    %   dist1 = UniformDistribution(2,3);
    %   dist2 = NormalDistribution(1,0.1);
    %   dist3  =BetaDistribution(3,3);
    %   param1=SimParameter('p1', dist1);
    %   param2=SimParameter('p2', dist2) ;
    %   param3=SimParameter('p3', dist3);
    %   myparams=SimParamSet1(param1, param2);
    %   myparams.add_parameter(param3);
    %   xi=myparams.sample(10000);
    %   scatter3(xi(:,1), xi(:,2), xi(:,3));
    %   xlabel(myparams.param_names{1});
    %   ylabel(myparams.param_names{2});
    %   zlabel(myparams.param_names{3});
    %
    % Example 2 (<a href="matlab:run_example SimParamSet1 2">run</a>)
%         beta=SimParameter('beta',UniformDistribution(-10,-6.5), '\beta');
%         beta_t=SimParameter('beta_T',UniformDistribution(-1,0.1), '\beta_T');
%         c_t=SimParameter('c_t',UniformDistribution(0,0.2)); 
%         c_eh=SimParameter('c_eh',UniformDistribution(0,0.3), 'c_{\epsilon^h}');
%         c_wd=SimParameter('c_wd',UniformDistribution(2,30),  'c_{wd}');
%         c_dp=SimParameter('c_dp',UniformDistribution(0,0.395),  'c_{d,p}');
%         
%         PSet=SimParamSet1(beta, beta_t, c_t, c_eh, c_wd, c_dp);
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
        function set=SimParamSet1(varargin)
            % Returns a new SimParamSet object
            % that by default sets the simparams independent
            % e.g.: MYPARAMSET=SimParamset()
            %         MYPARAMSET=SimParamset(param1,param2)
            %where PARAM1 and PARAM2 are SIMPARAMETER objects
            
            % initialize properties
            set.simparams=struct;
            if nargin>0
                set.add_parameter(varargin);
            end
        end
          
        %% Add parameter(s) to SimParamSet
        function add_parameter(set, p)
            % Adds the P parameters to the SimParamSet object
            if ~iscell(p)
                p={p};
            end
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
         % Releases the 
            % SIMPARAMETERS from being fixed to random variables
            % with names PAR_NAMES in the
            % SIMPARAMSET. If no PARAM_NAMES is given, it changes all
            % SIMPARAMETERS
        function set_not_fixed(set, p)
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
            % Changes the distribution to DIST of  the
            % SIMPARAMETERS with names PAR_NAMES in the
            % SIMPARAMSET. The SIMPARAMETERS, that
            % were fixed are released. If no PARAM_NAMES is given, it changes all
            % SIMPARAMETERS. 
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
                set.simparams.(p{i}).set_dist(dist{i});
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
            check_unsupported_options(options, mfilename);
            
            % Properties description
            m                 =set.num_params();
            m_RV           =set.num_RVs();
            RVs              =set.RV_names();  
            ind_RV         =set.find_ind_RV();
            fixed_vals    =set.find_fixed_vals();
            
            % Send error if all SIMPARAMS are fixed
            if m_RV==0
                error('sglib:gpcsimparams_sample', 'can not sample, there are no random variables in the SIMPARAMSET, use SET_NOT_FIXED method to releas parameters')
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
                xi_RV(:,i)=set.simparams.(RVs{i}).dist.invcdf((U(:,i)));
            end
            % add  columns with the fixed values to the samples
            if m>m_RV
                xi=zeros(N,m);
                xi(:,ind_RV)=xi_RV;
                xi(:,~ind_RV)=repmat(fixed_vals', N, 1);
            else
                xi=xi_RV;
            end
        end
        
        %% Set gPC basis
        function  [a_beta, V_p, varserr]=gpc_expand(set, varargin)
            % Properties description
            
            options=varargin2options(varargin);
            [polysys,options]=get_option(options, 'polysys', '');
            [expand_options,options]=get_option(options, 'expand_options', {});
            check_unsupported_options(options, mfilename);
            
            m_RV           =set.num_RVs();
            RVs              =set.RV_names();
            
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
        function  [x, w, x_ref, gpc_vars_err] =generate_integration_points(set, p_int, varargin)
            % Generates integration points for the SimParameters in the SIMPARAMSET object, that are
            % not fixed
            options=varargin2options(varargin);
            [polysys,options]=get_option(options, 'polysys', '');
            [expand_options,options]=get_option(options, 'expand_options', {});
            [grid, options] = get_option(options, 'grid', 'smolyak');
            check_unsupported_options(options, mfilename);
            m                 =set.num_params();
            m_RV           =set.num_RVs();
            ind_RV         =set.find_ind_RV();
                                   
            % generate gpc basis for the parameters
            [a_beta, V_p, gpc_vars_err]=set.gpc_expand('polysys', polysys, 'expand_options', expand_options);
            % generate integration points for the gPC germs
            [x_ref, w] = gpc_integrate([], V_p, p_int, 'grid', grid);
            % transfer integration points to the parameter's domain with the gPCE  
            x=gpc_evaluate(a_beta, V_p, x_ref);
            % if there are fixed parameters, insert fixed values
            if m>m_RV
                x_new=zeros(m,length(w));
                x_new(ind_RV,:)=x;
                x_new(~ind_RV,:)=repmat(set.find_fixed_vals(), 1, length(w));
                x=x_new;                
            end
            
        end
         %% Number of parameters
         function m=num_params(set)
            m=length(fieldnames(set.simparams));
         end
        
         %% Number of random variables
        function m_RVs=num_RVs(set)
            p=set.param_names();
            m_RVs=0;
            for i=1:length(p)
                if ~set.simparams.(p{i}).is_fixed;
                    m_RVs=m_RVs+1;
                end
            end
         end
        
        %% Name of all parameters (fixed and RVs)
        function p=param_names(set)
            p=fieldnames(set.simparams);
        end
        
        %% Name of all parameters (fixed and RVs) for plot
        function p_names=param_plot_names(set)
            p=set.param_names();
            m=set.num_params;
            p_names=cell(m, 1);
            for i=1:m
                p_names{i}=set.simparams.(p{i}).plot_name;
            end
        end
        
        %% Name of Random Variables
        function RVs=RV_names(set)
            p=set.param_names();
            m=set.num_params();
            m_RVs=set.num_RVs();
            j=0;
            
            RVs=cell(m_RVs, 1);
            for i=1:m
                if ~set.simparams.(p{i}).is_fixed;
                    j=j+1;
                    RVs{j}=set.simparams.(p{i}).name;
                end
            end
        end
        
        %% Name of Random Variables for plot
         function RV_names=RV_plot_names(set)
            p=set.param_names();
            m=set.num_params();
            m_RVs=set.num_RVs();
            j=0;
            
            RV_names=cell(m_RVs, 1);
            for i=1:m
                if ~set.simparams.(p{i}).is_fixed;
                    j=j+1;
                    RV_names{j}=set.simparams.(p{i}).plot_name;
                end
            end
         end
        
         %% Find indices of RVs in the param names
         function ind_RV=find_ind_RV(set)
            p=set.param_names();
            RVs=set.RV_names();
            ind_RV=false(size(p));
            for i=1:length(RVs)
                ind_RV=ind_RV|strcmp(RVs{i}, p);
            end
         end
         
         function fixed_vals=find_fixed_vals(set)
             p=set.param_names();
             ind_RV=set.find_ind_RV();
             fixed_p=p(~ind_RV);
             fixed_vals=zeros(size(fixed_p));
             for i=1:length(fixed_p)
                 fixed_vals(i)=set.simparams.(fixed_p{i}).fixed_val;
             end
         end
         
 
    end
end
