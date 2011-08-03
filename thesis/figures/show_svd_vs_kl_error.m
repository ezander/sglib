function show_svd_vs_kl_error

if fasttest('get')
    model_medium_easy
else
    model_medium_easy
    %model_large_easy
end

m_f=min(m_f,10);
num_refine_after=0;
define_geometry
cache_script discretize_model
cache_script setup_equation
cache_script solve_by_standard_pcg
solution_vec2mat

kmax=rank(U_mat);
K=round(sqrspace(1,kmax,30));
errK1=truncSVD(U_mat,G_N,G_X,I_u,K);
errK2=truncKL(U_mat,G_N,G_X,I_u,K);

%%
multiplot_init(2,1);

multiplot;
semilogy(K,errK1,'x-',K,errK2,'o-.')
logaxis([],'y')
legend('SVD', 'KL')
xlabel('k');
ylabel('$L_2$ error')

multiplot;
plot(K,(errK1-errK2),'x-')
xlabel('k');
ylabel('$\Delta L_2$ error')

multiplot([],1); save_figure( [], 'svd_vs_kl_L2-error' );
multiplot([],2); save_figure( [], 'svd_vs_kl_L2-error_diff' );


function errK=truncKL(R,G1,G2,I,K)
R(:,1)=0;

L1=chol(G1);
L2=chol(G2);
[U,S,V]=svd(L1*R*L2');
U=L1\U;
V=L2\V;
assert( norm(U*S*V'-R,'fro')<1e-9 )
assert( norm(U'*G1*U-eye(size(G1)),'fro')<1e-10 )
assert( norm(V'*G2*V-eye(size(G2)),'fro')<1e-10 )

errK=[];
for k=K
    Sk=S;
    Sk(k+1:end,k+1:end)=0;
    Rk=U*Sk*V';
    err=L2error( R, Rk, I, G1, G2 );
    errK(end+1)=err;
end

function errK=truncSVD(R,G1,G2,I,K)
R(:,1)=0;

[U,S,V]=svd(R);
assert( norm(U*S*V'-R,'fro')<1e-10 )
assert( norm(U'*U-eye(size(G1)),'fro')<1e-10 )
assert( norm(V'*V-eye(size(G2)),'fro')<1e-10 )


errK=[];
for k=K
    Sk=S;
    Sk(k+1:end,k+1:end)=0;
    Rk=U*Sk*V';
    err=L2error( R, Rk, I, G1, G2 );
    errK(end+1)=err;
end


function err=L2error( R, Rk, I, G1, G2 )
DR=R-Rk;
v=sqrt(sum((DR*G2).*DR,2));
err=sqrt(v'*G1*v);
