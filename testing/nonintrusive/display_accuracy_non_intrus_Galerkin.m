 
 
R=1/100; 
 


% setup the matrix A, and compute inverse(A) and its dimension m
[A, AI, m]=setup_matrix_for_elec_network( R );

f0 = zeros(m,1);
f0(1) = 1;  
maxiter=1000;
  

N=1000;   % number of reference results
 


 order_pool=[  2 3 4 5];  % order of Legendre polynomials to approximate u
 
 col_acr_pool=10.^[ -6 -7 -8 -9]; % convergence criteria
 
 jac_acr_pool=10.^[ -6 -7 -8 -9]; % convergence criteria
 

 K=length(order_pool);
 
col_err=zeros(1, N);
sei_err=zeros(1, N);
jac_err=zeros(1, N);

 col_err_list=zeros(1, K);
 sei_err_list=zeros(1, K);
 jac_err_list=zeros(1, K);

 eval_col_list =zeros(1, K);  % list of number of residual evaluations
 eval_sei_list =zeros(1, K);  % list of number of residual evaluations
 eval_jac_list =zeros(1, K);  % list of number of residual evaluations
 

 %% calculate N reference results, for later error estimation  
  u_ref = zeros(m,N); % to save N reference u, evaluated at p_set
  p_set=rand(2, N);  % generate N random samples of p

  acr_fine=eps;  % set a  strict convergence criteria
  
  for i=1:N
            p=p_set(:,i);  % a random sample

            u=zeros(m,1);
            u_old=u; 

            for k=1:maxiter
                     
                u = u_old + residual(p, AI, A, f0, u_old); 

                if max(abs(u-u_old))<acr_fine
                   %fprintf('Converged! iter= %d\n',k)
                   break; 
                end
                u_old=u;
            end
           u_ref(:,i)=u;

  end 
 
 
 %% Compute u_alpha using collocation and galerkin approaches, and compare their accuracy
 
for j=1:length(order_pool)
 
  order=order_pool(j); %%  order of Legendre polynomials to approximate u 
  qua_order=order +1; %% order of quadrature that approximate the integrals
  
  col_acr=col_acr_pool(j);
  jac_acr=jac_acr_pool(j);
  
  
  % generate Legendre polynomials (ind) and their L2 norms (var_list)  
  [ind, var_list] =multi_dim_polynomial_order_list( 2, order);  
  
 
  [u_alpha, eval_col_list(j) ] = Gauss_Ledendre_quadrature_solver( R, f0, order, qua_order, col_acr );  % compute the coefficients using gauss-legendre quadrature   
   
  
 % [u_alpha_seidel, eval_sei_list(j)]    = Gauss_Seidel_solver( R, f0, order, qua_order , jac_acr ); %   using Gauss-Seidel iterations  
 
    
  [u_alpha_jacobi, eval_jac_list(j) ]    = Gauss_Jacobi_solver( R, f0, order, qua_order, jac_acr ); %   using Gauss-Jacobi iterations
  
 
  
        % compute the error of each approximation on N random samples  

        for i=1:N

          % compare the approximations to the reference u    
          col_err(i) =  sqrt(mean((legendre_approx( u_alpha, ind, p_set(:,i) ) - u_ref(:,i)).^2));   
          jac_err(i) =  sqrt(mean((legendre_approx( u_alpha_jacobi, ind, p_set(:,i) ) - u_ref(:,i)).^2));  
        end 

col_err_list(j)=mean(col_err);
jac_err_list(j)=mean(jac_err);

j
end
  

figure,

plot(col_err_list); hold on
 
plot(jac_err_list, 'g'); hold on
 
   xlabel('order of polynomial', 'FontSize', 16);
   ylabel('RMSE', 'FontSize', 16)
   title('RMSE of collocation and Galerkin approaches', 'FontSize', 16);
 set(findobj('XScale','linear'), 'XScale','linear','YScale','log' );  
 legend(  'collocation',  'Galerkin'  );
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure,

plot(eval_col_list); hold on
 
plot(eval_jac_list, 'g'); hold on
 
   xlabel('order of polynomial', 'FontSize', 16);
   ylabel('number of evaluations', 'FontSize', 16)
   title('number of evaluations of collocation and Galerkin approaches', 'FontSize', 16);
     
 set(findobj('XScale','linear'),   'FontSize', 14 ); 
 
   legend(  'collocation',  'Galerkin'  );
   
   
   
   
 