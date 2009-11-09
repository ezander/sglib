clear
n_max=0;

for dryrun=[true,false]
    n=0;
    for beta_a=[0.25, 1, 4]
        beta_a_desc=sprintf( 'beta_1b%+1d', log2(beta_a) );

        for trunc_mode=[1,2,3]
            trunc_mode_desc=sprintf( 'trm_%1d', trunc_mode );

            for trunc_klmode=[false,true]
                trunc_klmodes={'euc','klm'};
                trunc_klmode_desc=trunc_klmodes{trunc_klmode+1};

                for solver={'cg','si'}
                    solver_desc=solver{1};

                    for eps=10.^-[4,6,8]
                        eps_desc=sprintf('1e%d', log10(eps) );

                        for eps_var=[false, true]
                            eps_var_modes={'eps','var'};
                            eps_var_desc=eps_var_modes{eps_var+1};

                            model_base=sprintf( '%s', beta_a_desc );
                            solver_base=sprintf( '%s-%s_%s-%s_%s', solver_desc, trunc_mode_desc, trunc_klmode_desc, eps_var_desc, eps_desc );
                            res_base=sprintf( '%s-%s', model_base, solver_base );

                            n=n+1;
                            if dryrun; continue; end
                            %solver_base=sprintf('%s-%s_1e%d-tm%d', solver{1}, eps_mode{eps(2)+1}, log10(eps(1)), trunc_mode(1));
                            %disp({eps(1),eps(2),, trunc_mode(2), delta,})
                            fprintf( '%3d/%3d - %s\n', n, n_max, res_base );
                            % check size, accuracy
                            % check contractivity
                            
                            save( ''
                        end
                    end
                end
            end
        end
    end
    n_max=n;
end
