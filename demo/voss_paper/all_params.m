% check size, accuracy
% check contractivity

clear
clc
if ~exist( './mat', 'dir' )
    mkdir( 'mat' );
end
n_max=0;


% params_defs={
%   'beta_a', [0.25, 1, 4], 'beta_1b$log2(beta_a)$';
%   'solver', {'cg', 'si'}, 'solver_$solver$';
%   'trunc_mode', {'euc', 'klm'}, 'trm_$trunc_mode$';
%   'eps_mode', {'eps', 'var'}, '$eps_mode$';
%   'eps', 10.^-[4,6,8], '1e$log10(eps)$'
% }


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
                            res_base=sprintf( '%s-%s', model_base, solver_base );
                            
%                             model_base2=strvarexpand( 'beta_1b$log2(beta_a)$');
%                             solver_base2=strvarexpand( '$solver$-trm_$trunc_mode$_$trunc_klmodes{trunc_klmode+1}$-$eps_var_modes{eps_var+1}$_1e$log10(eps)$' );
%                             res_base2=sprintf( '%s-%s', model_base2, solver_base2 );
                            
                            n=n+1;
                            if dryrun; continue; end
                            fprintf( '%03d/%03d - %s\n', n, n_max, res_base );
                            
                        	model_param_file=['./mat/model_params-' model_base '.mat'];
                            if ~exist(model_param_file, 'file')
                                save( model_param_file, '-V6', 'beta_a' );
                            end
                        	solver_param_file=['./mat/solver_params-' res_base '.mat'];
                            if ~exist(solver_param_file, 'file')
                                save( solver_param_file, '-V6', 'beta_a', 'solver', 'trunc_mode', 'trunc_klmode', 'eps_var', 'eps' );
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
