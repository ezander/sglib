function show_compare_modes

% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

format short g

multiplot_init(4,3)

[pos,els,u_i_k,u_k_alpha,I_u]=get_accurate_sol;
plot_stuff(pos,els,u_i_k,u_k_alpha,I_u)

[pos,els,u_i_k2,u_k_alpha2,I_u]=get_tensor_sol;
for k=2:5
    if dot(u_i_k(:,k),u_i_k2(:,k))<0
        u_i_k2(:,k)=-u_i_k2(:,k);
        u_k_alpha(k,:)=-u_k_alpha(k,:);
    end
    alpha=norm(u_i_k(:,k));
    alpha=alpha/norm(u_i_k2(:,k));
    u_i_k2(:,k)=alpha*u_i_k2(:,k);
    u_k_alpha(k,:)=1/alpha*u_k_alpha(k,:);
end
plot_stuff(pos,els,u_i_k2,u_k_alpha2,I_u)
plot_stuff(pos,els,u_i_k(:,1:5)-u_i_k2(:,1:5),u_k_alpha2,I_u)

%%
for k=1:4
    multiplot([], k); 
    save_figure( [], {'sol_true_kl_mode_%d', k}, 'type', 'raster' );
end
for k=1:4
    multiplot([], k+4); 
    save_figure( [], {'sol_tensor_kl_mode_%d', k}, 'type', 'raster' );
end
for k=1:4
    multiplot([], k+8); 
    save_figure( [], {'sol_diff_kl_mode_%d', k}, 'type', 'raster' );
end

function plot_stuff(pos,els,u_i_k,u_k_alpha,I_u )
for k=2:5
    % overrides stupid matlab behaviour in the plots
    u_i_k(:,k)=u_i_k(:,k)+1e-10;
    
    multiplot
    %set(gca,'ZTickLabelMode','manual')
    plot_field( pos, els, u_i_k(:,k), 'view', 3, 'show_mesh', true );
    plot_field_contour( pos, els, u_i_k(:,k), 'color', 'auto' );
    %change_tick_mode( [], 'z', [] );
end


function [pos,els,u_i_k,u_k_alpha,I_u]=get_accurate_sol
model_medium_easy

define_geometry
cache_script discretize_model
cache_script setup_equation

tol=1e-6;
cache_script solve_by_standard_pcg
cache_script solution_vec2kl

function [pos,els,u_i_k,u_k_alpha,I_u]=get_tensor_sol
model_medium_easy

define_geometry
cache_script discretize_model
cache_script setup_equation
tol=1e-2;
abstol=tol;
reltol=tol;
eps=1e-8;
dynamic_eps=true;
cache_script solve_by_gsolve_tensor
cache_script solution_ten2kl
