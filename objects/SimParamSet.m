classdef SimParamSet < handle
    %SIMPARAMSET Constructs a set of optionally random parameters,
    %
    %MYPARAMSET=SIMPARAMSET() constructs parameterset supposing a set of independent
    % random variables
    %
    % Example (<a href="matlab:run_example SimParamSet">run</a>)
    %   dist1 = UniformDistribution(2,3);
    %   dist2 = NormalDistribution(1,0.1);
    %   dist3  =BetaDistribution(3,3);
    %   param1=SimParameter('p1', dist1);
    %   param2=SimParameter('p2', dist2) ;
    %   param3=SimParameter('p3', dist3);
    %   myparams=SimParamSet(param1, param2);
    %   myparams.add_parameter(param3);
    %   xi=myparams.sample(10000);
    %   scatter3(xi(:,1), xi(:,2), xi(:,3));
    %   xlabel(myparams.names(1));
    %   ylabel(myparams.names(2));
    %   zlabel(myparams.names(3));
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
        names
        num_params
        is_fixed
        num_RVs
        is_independent
        covariance
        mean_vals
        fixed_vals
    end
    
    methods
        %% Constructor
        function params=SimParamSet(varargin)
            % Returns a new SimParamSet object
            % that by default sets the simparams independent
            % e.g.: MYPARAMSET=SimParamset()
            %         MYPARAMSET=SimParamset(param1,param2)
            %where PARAM1 and PARAM2 are SIMPARAMETER objects
            
            % initialize properties
            params.simparams={};
            params.names={};
            params.num_params=0;
            params.num_RVs=0;
            
            if nargin>0
                params.add_parameter(varargin);
            end
            params.is_independent='true';
        end
        %% Add parameter(s) to SimParamSet
        function add_parameter(params, p)
            % Adds the P parameters to the SimParamSet object
            
            if ~iscell(p)
                p={p};
            end
            for i=1:length(p)
                check_type(p{i}, 'SimParameter', true, 'Inputs of SimParamSet', mfilename);
                params.simparams{end+1, 1}=p{i};
                params.names{end+1,1}=p{i}.name;
                params.num_params=params.num_params+1;
                params.mean_vals(end+1,1)=p{i}.dist.mean;
                if p{i}.is_fixed
                    params.is_fixed(end+1,1)=true;
                    params.fixed_vals(end+1,1)=p{i}.fixed_val;
                else
                    params.is_fixed(end+1,1)=false;
                    params.num_RVs=params.num_RVs+1;
                    params.fixed_vals(end+1,1)=NaN;
                end
            end
        end
        %% Fix SimParameters in the ParamSet
        function set_fixed(params, par_names, val)
            if nargin<2 || isempty(par_names)
                par_names=params.names;
            end
            if ~iscell(par_names)
                par_names={par_names};
            elseif nargin>2&&isscalar(val)
                val=repmat(val,size(par_names));
            elseif nargin>2&&~isscalar(val)
                check_boolean(length(par_names)==length(val), 'length of VAL does not match with the one of the PARAM_NAMES', mfilename);
            end
            
            for i=1:length(par_names)
                ind=strcmpi(par_names{i}, params.names);
                if ~any(ind); error('%s%s', 'The SimParamSet does not have parameter', par_names{i});end
                if nargin>2
                    params.simparams{ind}.set_fixed(val(i));
                else
                    params.simparams{ind}.set_to_mean();
                end
                if ~params.is_fixed(ind)
                    params.is_fixed(ind)=true;
                    params.num_RVs=params.num_RVs-1;
                end
                params.fixed_vals(ind)=params.simparams{ind}.fixed_val;
            end
        end
        %% Release SimParameters in the ParamSet
        
        function set_not_fixed(params, par_names)
            if nargin<2
                par_names=params.names;
            elseif ~iscell(par_names)
                par_names={par_names};
            end
            
            for i=1:length(par_names)
                ind=strcmpi(par_names{i}, params.names);
                if ~any(ind); error('%s%s', 'The SimParamSet does not have parameter', par_names{i});end
                
                params.simparams{ind}.set_not_fixed();
                if params.is_fixed(ind)
                    params.is_fixed(ind)=false;
                    params.num_RVs=params.num_RVs+1;
                    params.fixed_vals(ind)=NaN;
                end
            end
        end
        %% Change Distribution of  SimParameters in the ParamSet
        function set_dist(params, par_names, dist)
            if isempty(par_names)
                par_names=params.names;
            end
            if ~iscell(par_names)
                par_names={par_names};
            end
            if ~iscell(dist)&&isa(dist, 'Distribution')&&length(dist)==1
                dist=repmat({dist},size(par_names));
            elseif iscell(dist)
                check_boolean(length(par_names)==length(dist), 'length of DIST does not match with the one of the PARAM_NAMES', mfilename);
            end
            
            for i=1:length(par_names)
                ind=strcmpi(par_names{i}, params.names);
                if ~any(ind); error('%s%s', 'The SimParamSet does not have parameter', par_names{i});end
                params.simparams{ind}.set_dist(dist{i});
                if params.is_fixed(ind)
                    params.is_fixed(ind)=false;
                    params.num_RVs=params.num_RVs+1;
                    params.fixed_vals(ind)=NaN;
                end
            end
        end
        %% Sample from SimParamSet
        function xi=sample(params, n, varargin)
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
            m_RV           =params.num_RVs;
            m                 =params.num_params;
            ind_f            =params.is_fixed;
            ind_RV         =~ind_f;
            RV                =params.simparams(ind_RV);
            
            
            % Generate standard uniform samples
            switch(mode)
                case {'mc', 'default'}
                    U = rand(n,m_RV);
                    if ~isempty(rand_func)
                        U = funcall(rand_func, n, m_RV);
                        if any(size(U)~=[n, m_RV])
                            error('sglib:gpcgerm_sample', 'rand_func did not return an array of the expect size [%d,%d], but [%d,%d]', n, m, size(U,1), size(U,2));
                        end
                    end
                case 'qmc'
                    U = halton_sequence(n, m_RV, qmc_options);
                case 'lhs'
                    U = lhs_uniform(n, m_RV);
                otherwise
                    error('sglib:SimParamSet.sample, unknown paramter value "%s" for option "mode"', mode);
            end
            
            % Generate samples from the distributions of the unfixed
            % parameters
            xi_RV=zeros(size(U));
            for i=1:m_RV
                xi_RV(:,i)=RV{i}.dist.invcdf((U(:,i)));
            end
            % add  columns with the fixed values to the samples
            if any(ind_f)
                xi=zeros(n,m);
                xi(:,ind_RV)=xi_RV;
                xi(:,ind_f)=repmat(params.fixed_vals(ind_f), n, 1);
            else
                xi=xi_RV;
            end
        end
        
        %% Set gPC basis
        function V=gpcbasis_create(params, varargin)
            % Properties description
            m_RV           =params.num_RVs;
            ind_RV         =~ind_f;
            RV                =params.simparams(ind_RV);
            
            polysys=[];
            for i=1:m_RV
                polysys=[polysys, RV{i}.get_default_polysys];
            end
            V=gpcbasis_create(polysys, varargin);
        end
        %% Generate integration points
        function  [x, w] =generate_integration_points(params, p, varargin)
            % Generates integration points for the SimParameters in the SIMPARAMSET object, that are
            % not fixed
            V=simparams.create_gpc_basis();
            [x, w] = gpc_integrate([], V, p);
        end
        
        
        
    end
end
