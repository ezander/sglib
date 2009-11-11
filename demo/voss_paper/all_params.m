% check size, accuracy
% check contractivity

clear
clc
if ~exist( './mat', 'dir' )
    mkdir( 'mat' );
end

param_sets={'model', 'solver'};
param_defs={
  'beta_a', [0.25, 1, 4], 'beta_1b$log2(beta_a)$', 1;
  'solver', {'cg', 'si'}, '$solver$', 2;
  'trunc_mode', [1,2,3], 'trm_$trunc_mode$', 2;
  'orth_mode', {'euc', 'klm'}, '$orth_mode$', 2;
  'eps_mode', {'eps', 'var'}, '$eps_mode$', 2;
  'eps', 10.^-[4,6,8], '1e$log10(eps)$', 2;
};

% parameter looping stuff
n_max=1;
n_params=size(param_defs,1);
ind=ones(1,n_params);
for i=1:n_params
    param_vals=param_defs{i,2};
    if ~iscell(param_vals)
        param_vals=num2cell(param_vals);
    end
    param_vals=param_vals(:);
    param_defs{i,2}=param_vals;
    
    max_ind(1,i)=length(param_vals);
end
n_max=prod(max_ind);

% do the parameter loop
for n=1:n_max
    % get current parameters
    full_desc={'',''};
    for i=1:n_params
        eval([param_defs{i,1}, '=param_defs{i,2}{ind(i)};']);
        param_desc{i}=strvarexpand(param_defs{i,3});
        set_num=param_defs{i,4};
        full_desc{set_num}=[full_desc{set_num} '-' param_desc{i}];
    end
    full_desc={full_desc{1}(2:end),full_desc{2}(2:end)};
    %fprintf('%s   %s \n', full_desc{:});
    
    model_base=full_desc{1};
    solver_base=full_desc{2};
    result_base=sprintf( '%s-%s', model_base, solver_base );

    fprintf( '%03d/%03d - %s\n', n, n_max, result_base );

    model_param_file=['./mat/model_params-' model_base '.mat'];
    if ~exist(model_param_file, 'file')
        %fprintf( '  %s\n', model_param_file );
        save( model_param_file, '-V6', 'beta_a', 'model_base' );
    end
    solver_param_file=['./mat/solver_params-' result_base '.mat'];
    if ~exist(solver_param_file, 'file')
        %fprintf( '  %s\n', solver_param_file );
        save( solver_param_file, '-V6', 'beta_a', 'solver', 'trunc_mode', 'orth_mode', 'eps_mode', 'eps', 'solver_base', 'result_base' );
    end
    test_run;

    % compute next index
    for k=1:n_params
        ind(k)=ind(k)+1;
        if ind(k)<=max_ind(k); break; end
        ind(k)=1;
    end
end
return
    
    


for dryrun=[true,false]
    n=0;
    for beta_a=[0.25, 1, 4]
        beta_a_desc=sprintf( 'beta_1b%1d', log2(beta_a) );
        
        for trunc_mode=[1,2,3]
            trunc_mode_desc=sprintf( 'trm_%1d', trunc_mode );

            for trunc_klmode=[false,true]
                trunc_klmodes={'euc','klm'};
                trunc_klmode_desc=trunc_klmodes{trunc_klmode+1};

                for solver_num=1:2
                    solvers={'cg','si'};
                    solver=solvers{solver_num};
                    solver_desc=solver;

                    for eps=10.^-[4]%,6,8]
                        eps_desc=sprintf('1e%d', log10(eps) );

                        for eps_var=[false]%, true]
                            eps_var_modes={'eps','var'};
                            eps_var_desc=eps_var_modes{eps_var+1};

                            model_base=sprintf( '%s', beta_a_desc );
                            solver_base=sprintf( '%s-%s_%s-%s_%s', solver_desc, trunc_mode_desc, trunc_klmode_desc, eps_var_desc, eps_desc );
                            result_base=sprintf( '%s-%s', model_base, solver_base );
                            
%                             model_base2=strvarexpand( 'beta_1b$log2(beta_a)$');
%                             solver_base2=strvarexpand( '$solver$-trm_$trunc_mode$_$trunc_klmodes{trunc_klmode+1}$-$eps_var_modes{eps_var+1}$_1e$log10(eps)$' );
%                             result_base2=sprintf( '%s-%s', model_base2, solver_base2 );
                            
                            n=n+1;
                            if dryrun; continue; end
                            fprintf( '%03d/%03d - %s\n', n, n_max, result_base );
                            
                        	model_param_file=['./mat/model_params-' model_base '.mat'];
                            if ~exist(model_param_file, 'file')
                                save( model_param_file, '-V6', 'beta_a', 'model_base' );
                            end
                        	solver_param_file=['./mat/solver_params-' result_base '.mat'];
                            if ~exist(solver_param_file, 'file')
                                save( solver_param_file, '-V6', 'beta_a', 'solver', 'trunc_mode', 'trunc_klmode', 'eps_mode', 'eps', 'solver_base', 'result_base' );
                            end
                            test_run;
                        end
                    end
                end
            end
        end
    end
    n_max=n;
end
