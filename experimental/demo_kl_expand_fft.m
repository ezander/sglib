%% Demonstrate usage of the Karhunen-Loeve expansion functions

%% Setup grid
clear; subplot(1,1,1); clf; hold off
n=30;
x=linspace(0,1,n)';
els=[1:n-1; 2:n]';
M=mass_matrix( els, x );

size(M)
%% Create covariance matrix 
cov_u={@gaussian_covariance, {0.1}};

%% Plot the covariance function
x1=linspace(-1,1,100)'; x2=zeros(size(x1));
plot( x1, funcall( cov_u, x1, x2 ) );
%userwait

m=10;
%% Create KL with variance correction on and M=I
M=eye(size(M));
[v_u,sq_v]=kl_expand_fft( x, cov_u, M, m, 'correct_var', false );
subplot(2,1,1); plot( x, v_u );
%legend( 'v_1', 'v_2', 'v_3' );
%userwait

[v_u2,sq_v2]=kl_expand( covariance_matrix( x, cov_u ), M, m, 'correct_var', false );
subplot(2,1,2); plot( x, v_u2 );



%C=round(max(0,abs(v_u'*M*v_u2*10)-5))*2;
C=round(100*abs(v_u'*M*v_u2))/100;
for i=1:m; 
	subplot(4,m,0*m+i); plot( x, v_u(:,i) ); 
	%subplot(4,m,1*m+i); plot( abs(fftshift(fft(v_u(:,i)))) ); 
    f=abs(fft(v_u(:,i))); f=f(1:i+2);
    %[mf,find]=max(f);
    find=sum( (1:i+2)'.*f )/sum(f);
	subplot(4,m,1*m+i); plot( 1:i+2, f, [find find], [0 5] ); xlim( [1, i+2]);
    [c,ind]=max(C(i,:)); title([num2str(ind) '(' num2str(c) ')' ' : (' num2str(find/2) ',' num2str(v_u(:,i)'*M*v_u(end:-1:1,i)) ')']); 
end
for i=1:m; 
    subplot(4,m,2*m+i); plot( x, v_u2(:,i) ); 
	%subplot(4,m,3*m+i); plot( abs(fftshift(fft(v_u2(:,i)))) ); 
    f=abs(fft(v_u2(:,i))); f=f(1:i+2);
    %[mf,find]=max(f);
    find=sum( (1:i+2)'.*f )/sum(f);
	subplot(4,m,3*m+i); plot( 1:i+2, f, [find find], [0 5] ); xlim( [1, i+2]);
    [c,ind]=max(C(:,i)); title([num2str(ind) '(' num2str(c) ')' ' : (' num2str(find/2) ',' num2str(v_u2(:,i)'*M*v_u2(end:-1:1,i)) ')']); 
end


