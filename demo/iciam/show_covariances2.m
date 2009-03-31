function show_covariances2( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u )
[X,Y]=meshgrid(x,x);
C_k=pce_covariance( k_alpha, I_k );
C_f=pce_covariance( f_alpha, I_f );
C_u=pce_covariance( u_alpha, I_u );
clf;
[mu_k,var_k]=pce_moments(k_alpha(2,:),I_k); %#ok
[mu_f,var_f]=pce_moments(f_alpha(2,:),I_f); %#ok
subplot(3,3,1); surf( X, Y, C_k )
[V,D]=eig(C_k);m=6;
l=tolog10(diag(D)); 
subplot(3,3,4); plot(l,'x'); xlim([1,length(l)]);
subplot(3,3,7); plot(x,V(:,1:m)*sqrt(D(1:m,1:m))); xlim([min(x),max(x)]);

subplot(3,3,2); surf( X, Y, C_f )
[V,D]=eig(C_f);m=6;
l=tolog10(diag(D)); 
subplot(3,3,5); plot(l,'x'); xlim([1,length(l)]);
subplot(3,3,8); plot(x,V(:,1:m)*sqrt(D(1:m,1:m))); xlim([min(x),max(x)]);

subplot(3,3,3); surf( X, Y, C_u )
[V,D]=eig(C_u);m=6;
l=tolog10(diag(D)); 
subplot(3,3,6); plot(l,'x'); xlim([1,length(l)]);
subplot(3,3,9); plot(x,V(:,1:m)*sqrt(D(1:m,1:m))); xlim([min(x),max(x)]);

%%
