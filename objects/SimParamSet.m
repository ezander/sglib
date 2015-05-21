classdef SimParamSet < handle
    %SIMPARAMSET Constructs a set of optionally random parameters,
    %
    %MYPARAMSET=SIMPARAMSET() constructs parameterset supposing a set of independent
    % random variables
    %   
    % Example (<a href="matlab:run_example UniformDistribution">run</a>)
    %   dist1 = LogNormalDistribution(2,3);
    %   dist2 = NormalDistribution(1,0.1);
    %   param1=SimParameter('p1', dist1) 
    %   param2=SimParameter('p2', dist2) 
    %   param3=SimParameter('p3', translate(dist2,1,1) 
    %   myparams=SimParamSet(param1, param2)
    %   myparams.add_parameter(p3);
    %   
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
        num_params
        is_independent
        covariance
    end
    
    methods
        %% Constructor
        function simparamset=SimParamSet(varargin)
            % Returns a new SimParamSet object
            % that by default sets the simparams independent
            % e.g.: MYPARAMSET=SimParamset()
            %         MYPARAMSET=SimParamset(kappa,mass)
            
            % initialize properties
            simparamset.num_params=0;
            if nargin>0
                SimParameters=varargin;
            else
                SimParameters={};
            end
            % add parameters from the input to the set
            if ~isempty(SimParameters)
                simparamset.add_parameter(SimParameters);
            end
            simparamset.is_independent='true';
        end
        %% Add parameter(s) to SimParamSet
        function add_parameter(simparamset, params)
            % Adds parameters to the SimParamSet object
            %
            % e.g.: param_set.add_parameter(kappa);
            %         param_set.add_parameter(kappa);
            %Check whether inputs are from the class SIMPARAMETER
            
            if ~iscell(params)
                params={params};
            end
            for i=1:length(params)
                check_type(params{i}, 'SimParameter', true, 'Inputs of SimParamSet', mfilename);
                simparamset.num_params=simparamset.num_params+1;
                simparamset.simparams{end+1}=params{i};
            end
         end
        %% Sample from SimParamSet
        function [samples, varargout]=generate_samples(simparamset, n, varargin)
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
            
            % Get number of RV, and pointers for them 
           [num_RVs, pointer_to_RVs, RVs]= simparamset.get_pointer();
            
           % Generate standard uniform samples
            switch(mode)
                case {'mc', 'default'}
                    U = rand(n,num_RVs);
                    if ~isempty(rand_func)
                        U = funcall(rand_func, n, num_RVs);
                        if any(size(U)~=[n, num_RVs])
                            error('sglib:gpcgerm_sample', 'rand_func did not return an array of the expect size [%d,%d], but [%d,%d]', n, m, size(U,1), size(U,2));
                        end
                    end
                case 'qmc'
                    U = halton_sequence(n, num_RVs, qmc_options);
                case 'lhs'
                    U = lhs_uniform(n, num_RVs);
                otherwise
                     error('sglib:SimParamSet.sample, unknown paramter value "%s" for option "mode"', mode);
            end
            
            % Generate samples from the distributions of the unfixed
            % parameters
            sample_fromRV=zeros(size(U));
            for i=1:num_RVs
                sample_fromRV(:,i)=RVs{i}.sample((U(:,i)));
            end
            % add  columns with the fixed values to the samples
            samples=zeros(n,simparamset.num_params);
            samples(:,pointer_to_RVs)=sample_fromRV;
            pointer_c=setxor(pointer_to_RVs,1:simparamset.num_params);
            if ~isempty(pointer_c)
                for j=1:length(pointer_c)
                samples(:, pointer_c(j))=ones(1,n)*simparamset.simparams{pointer_c(j)}.fixed_val;
                end
            end
            
            % Output definition
            if nargout>1
                varargout{1}.params=simparamset.simparams;
                varargout{1}.pointer_to_RVs=pointer_to_RVs;
                if nargout>2
                    error('sglib:SimParamSet.sample: Too many input parameters');
                end
            end
        end
        %%   Get pointer to RVs 
        function [num_RVs, pointer_to_RVs, RVs]=get_pointer(simparamset)
            % Tracks from the parameters, the ones that are random
            % and gives
            % NUM_RVS:  number of random variables
            % POINTER_TO_RVs: gives pointer to the
            % random variables (the not fixed ones),
            % sor that the not fixed parameters are:
            % RVs=SIMPARAMETERS.SIMPARAMS{POINTER_TO_RVs},
            
            num_RVs=0;
            pointer=zeros(1,simparamset.num_params);
            for i=1:simparamset.num_params
                if ~simparamset.simparams{i}.is_fixed
                    num_RVs= num_RVs+1;
                    pointer(i)=1;
                end
                pointer_to_RVs=find(pointer);
            end
            RVs=simparamset.simparams(pointer_to_RVs);
        end
        %% Set gPC basis
        function V=get_gpce(simparamset, varargin)
            [num_RVs, pointer_to_RVs, RVs]=get_pointer(simparamset);
            polysys=[];
            for i=1:num_RVs
                polysys=[polysys, RVs{i}.get_default_polysys];
                
            end
            V=gpcbasis_create(polysys, varargin);
        end
        %% Generate integration points
        function  [x, w] =generate_integration_points(simparamset, p, varargin)
            % Generates integration points for the SimParameters in the SIMPARAMSET object, that are
            % not fixed
            V=simparamset.create_gpc_basis();
            [x, w] = gpc_integrate([], V, p);
        end
        
        
        
    end
end
