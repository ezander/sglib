function demo_animation
% DEMO_ANIMATION Shows a smoothly varying random field.


kl_model_version=[];
[m_f, pos,els, f_i_k, f_i_alpha, I_f]=...
    load_kl_model( 'rf_kl_2d-1', kl_model_version, [], {'m_r', 'pos', 'els', 'r_i_k', 'r_k_alpha', 'I_r'} );

modes1=1:4;
modes2=5:8;
modes3=9:12;
fields={{f_i_k, f_i_alpha, I_f}, ...
    {f_i_k(:,modes1), f_i_alpha(modes1,:), I_f},...
    {f_i_k(:,modes2), f_i_alpha(modes2,:), I_f},...
    {f_i_k(:,modes3), f_i_alpha(modes3,:), I_f},...
    }

%animate_fields( pos, els, {{f_i_k(:,modes), f_i_alpha(modes,:), I_f}}, m_f )
animate_fields( pos, els, fields, 'rows', 2, 'renderer', 'opengl' );

