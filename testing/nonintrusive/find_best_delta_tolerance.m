
%% To find the best convergence criteria
 
R=1/100; 

% setup the matrix A, and compute inverse(A) and its dimension m
[A, AI, m]=setup_matrix_for_elec_network( R );
  
maxiter=5000;

order_pool= [2 3 4 5];

acr_pool = eps*10.^[7:0.2:13];


N=1000;   % number of random samples
 

f0 = zeros(m,1);
f0(1) = 1;  

  
 
 K=length(acr_pool);
 
col_err=zeros(1, N);
 
jac_err=zeros(1, N);



 col_err_list=zeros(length(order_pool), length(acr_pool));
 
 jac_err_list=zeros(length(order_pool), length(acr_pool));

 eval_col_list =zeros(length(order_pool), length(acr_pool));  % list of number of residual evaluations
 
 eval_jac_list =zeros(length(order_pool), length(acr_pool));  % list of number of residual evaluations
 

%% calculate N reference results, for later error estimation  
  u_ref = zeros(m,N); % to save N reference u, evaluated at p_set
  p_set=rand(2, N);  % random sample

  acr_fine=eps;  % set a more strict convergence rate
  
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
 
  
%% estimate error of  Gauss_Ledendre_quadrature_solver at different convergence criteria and different polynomial order  
for i=1:length(order_pool)
    
  order=order_pool(i); %% maximum order of polynomials 
  qua_order=order +1; %% order of quadrature
  
  for j=1:length(acr_pool)
 
   acr=acr_pool(j);
  
  [ind, var_list] =multi_dim_polynomial_order_list( 2, order);  %
  
 
  [u_alpha, eval_col_list(j) ] = Gauss_Ledendre_quadrature_solver( R, f0, order, qua_order,acr );  % compute the coefficients using gauss-legendre quadrature   
   
  
 % [u_alpha_seidel, eval_sei_list(j)]    = Gauss_Seidel_solver( R, f0, order, qua_order ); %   using Gauss-Seidel iterations  
 
    
  %[u_alpha_jacobi, eval_jac_list(j) ]    = Gauss_Jacobi_solver( R, f0, order, qua_order ); %   using Gauss-Jacobi iterations
  
 
  
        % compute the error of each approximation on N random samples  

        for k=1:N
           % compare the approximations to the reference u    
          col_err(k) =  sqrt(mean((legendre_approx( u_alpha, ind, p_set(:,k) ) - u_ref(:,k)).^2));  
        end 

col_err_list(i,j)=mean(col_err);

end
  i
end
 
figure,

plot(acr_pool, col_err_list(1,:)); hold on
plot(acr_pool, col_err_list(2,:),'r'); hold on
plot(acr_pool, col_err_list(3,:),'m'); hold on
plot(acr_pool, col_err_list(4,:),'g'); hold on
 
   xlabel('Convergence criteria', 'FontSize', 16);
   ylabel('RMSE', 'FontSize', 16)
   title('Error sensitivity to convergence criteria for collocation method', 'FontSize', 16);
    %  axis([15 210  1e-4  1e1]);
 set(findobj('XScale','linear'),   'FontSize', 14 ); 
 set(findobj('XScale','linear'), 'XScale','log','YScale','log' );  
     
  legend(  '2nd order polynomial',  '3rd order polynomial', '4th order polynomial', '5th order polynomial' );

  
%   set(gca, 'YTickLabel',num2str(get(gca,'YTick')', '%1.0e'));
%   
%      set(gcf, 'Color', 'w');
%    export_fig  estimate_CD_exceed_3_Jan_2013  -pdf

 