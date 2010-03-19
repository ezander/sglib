klr=3; klc=3; res=3;

model_large
m_f=1;
m_k=1;

num_refine=1;
show_mesh=false;
define_geometry

stdnor_f={@gendist_stdnor,dist_f};
lc_f=0.6;
lc_f=0.02;
cov_f_func=@gaussian_covariance;
cov_f={cov_f_func,{lc_f,1}};

edges=[ els([1;2],:), els([2;3],:), els([3;1],:)];
dx=pos(1,edges(1,:))-pos(1,edges(2,:));
dy=pos(2,edges(1,:))-pos(2,edges(2,:));
h=sqrt(dx.^2+dy.^2);
min(h)

phi_f=pce_expand_1d(stdnor_f,6);
C_f=covariance_matrix( pos, cov_f, 'max_dist', 5*lc_f );
%C_f=covariance_matrix( pos, cov_f );

[v_f,sigma_f]=kl_solve_evp( C_f, G_N, 40 );

if false; 
[v_f,sigma_f2]=kl_solve_evp( C_f, G_N, 200 );
%if eps>.01; warning(); end

tab=zeros(0,3);
for n=4:30
    [v_f,sigma_f]=kl_solve_evp( C_f, G_N, n );

    eps_est=kl_estimate_eps(sigma_f);
    eps_true=norm(sigma_f2(length(sigma_f)+1:end))/norm(sigma_f2)
    tab(end+1,:)=[n, eps_est, eps_true];
end
clf
plot( tab(:,1), tab(:,2:3)', 'x-' )
end

x=linspace(0,sqrt(2));
subplot( klr,klc,1); plot( x, funcall( cov_f, x, []) );
subplot( klr,klc,2,'replace'); plot( sigma_f, 'x-' );


subplot( klr,klc,3,'replace'); 
n=10;
s=sum((v_f(:,1:n)*diag(sigma_f(1:n))).^2,2);
plot_field( pos, els, s ); caxis([0,1]); colorbar('location', 'northoutside');

for i=1:klr*klc-res
    subplot( klr,klc,i+res,'replace'); plot_field( pos, els, v_f(:,i) ); caxis([-1,1]); colorbar('location', 'northoutside');
end


%C_gam=transform_covariance_pce( C_f, phi_f );
%clf
