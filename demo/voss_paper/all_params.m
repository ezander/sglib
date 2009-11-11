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
  'reltol', 1e-6, 'tol_$-log10(reltol)$', 2;
  'trunc_mode', [1,2,3], 'trm_$trunc_mode$', 2;
  'orth_mode', {'euc', 'klm'}, '$orth_mode$', 2;
  'eps_mode', {'eps', 'var'}, '$eps_mode$', 2;
  'eps', 10.^-[4,6,8], '1e$log10(eps)$', 2;
};

param_defs={
  'beta_a', [0.7], 'beta_1b$log2(beta_a)$', 1;
  'solver', {'cg'}, '$solver$', 2;
  'reltol', 1e-6, 'tol_$-log10(reltol)$', 2;
  'trunc_mode', [1], 'trm_$trunc_mode$', 2;
  'orth_mode', {'euc', 'klm'}, '$orth_mode$', 2;
  'eps_mode', {'eps'}, '$eps_mode$', 2;
  'eps', 10.^-[8], '1e$log10(eps)$', 2;
};

% parameter looping stuff
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
        param_desc{i}=strvarexpand(param_defs{i,3}); %#ok
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
        save( model_param_file, '-V6', 'beta_a', 'model_base' );
    end
    solver_param_file=['./mat/solver_params-' result_base '.mat'];
    if ~exist(solver_param_file, 'file')
        save( solver_param_file, '-V6', 'beta_a', 'solver', 'reltol', 'trunc_mode', 'orth_mode', 'eps_mode', 'eps', 'solver_base', 'result_base' );
    end
    test_run;

    % compute next index
    for k=1:n_params
        ind(k)=ind(k)+1;
        if ind(k)<=max_ind(k); break; end
        ind(k)=1;
    end
end
