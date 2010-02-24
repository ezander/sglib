function model()

global n pos els M
global p_f m_f l_f lc_f h_f cov_f f_i_alpha I_f mu_f f_k_alpha f_i_k
global p_k m_k l_k lc_k h_k cov_k k_i_alpha I_k mu_k k_k_alpha k_i_k
global p_u m_u I_u


rf_filename='ranfield_smd.mat';
reinit=true;
if ~reinit && exist( rf_filename, 'file' ) 
    load( rf_filename )
else
    % definition of the grid
    n=21;
    [pos,els]=create_mesh_1d(0,1,n);
    M=mass_matrix( pos, els );

    % expansion of the right hand side field (f)
    p_f=3;
    m_f=2;
    l_f=4;
    lc_f=2*0.3;
    h_f={@beta_stdnor,{4,2}};
    cov_f={@gaussian_covariance,{lc_f,1}};
    options_expand_f.transform.correct_var=1;
    [f_i_alpha, I_f]=expand_field_pce_sg( h_f, cov_f, [], pos, M, p_f, m_f, options_expand_f );
    f_i_alpha(:,1)=0.3*f_i_alpha(:,1); % set mean to zero
    
    [mu_f,f_i_k,f_k_alpha]=pce_to_kl( f_i_alpha, I_f, l_f, M );

    % expansion of the right hand side field (f)
    p_k=4;
    m_k=4;
    l_k=4;
    lc_k=0.3;
    h_k={@beta_stdnor,{4,2}};
    cov_k={@gaussian_covariance,{lc_f,1}};
    options_expand_k.transform.correct_var=1;
    [k_i_alpha, I_k]=expand_field_pce_sg( h_k, cov_k, [], pos, M, p_k, m_k, options_expand_k );
    k_i_alpha(:,1)=1+k_i_alpha(:,1); % shift mean
    k_i_alpha(:,2:end)=0.5*k_i_alpha(:,2:end); % scale variance
    [mu_k,k_i_k,k_k_alpha]=pce_to_kl( k_i_alpha, I_k, l_k, M );


    % In the expansion of the random fields f and k we have assumed that the
    % fields are independent. Now if we use both in the same application we
    % have to make sure that gamma_1 in the expansion of f has nothing to do
    % with gamma_1 in the expansion of k. We do this by combining multiindices
    % by pre- and postfixing them with the appropriate amount of zeros such
    % that those in the expansion of f are disjoint to those of k (with the
    % exception of the all-zero multiindex)
    [I_k,I_f,I_u]=multiindex_combine( {I_k, I_f}, -1 );
    %p_u=max(p_f,p_k);
    %m_u=m_f+m_k;
    %I_u=multiindex(m_u,p_u);


    save( rf_filename, '-V6' );
end



%%
