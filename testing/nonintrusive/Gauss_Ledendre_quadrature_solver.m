function [ u_alpha, total_residual_eval] = Gauss_Ledendre_quadrature_solver( R, f0, order, qua_order, acr ) 
% 
 
%%====================================================================================
 % compute the coefficients by collocation method
 
 % input:
 % R --  for the  electrical circuit testcase
 % f0 -- for the  electrical circuit testcase
 % order --  order of polynomials to approximate u
 % qua_order -- order of quadrature to approximate integral
 % acr -- convergence criteria for iterative solver
 
 % output:
 % u_alpha --  the coefficients u_{\alpha}
 % total_residual_eval -- number of solver evaluations
 
 
[A, AI, m]=setup_matrix_for_elec_network( R );
  
 
 
 
% get the order index for 2 dimensional polynomials with total degree 3,
% varlist is the list of L2 norms of the terms 
[ind, var_list] =multi_dim_polynomial_order_list( 2, order);  %

num_terms= length(var_list); % number of polynomial terms
 
% get the nodes and weights of 2-D Gauss-Legendre quadrature
[node,weight]=lgwt_2D(qua_order, -1, 1);

num_node= length(node);
 
 % u samples at the Gauss-Legendre nodes
  u_node=zeros(m, num_node);
  
  maxiter=1000;
  % acr = 1000*eps;  
  
u=zeros(m,1);
 

total_residual_eval=0;

for i=1:num_node
    p= node(:,i);
    u_old = zeros(m,1); % the initial guess
     
    for j=1:maxiter

      
        u = u_old + residual(p, AI, A, f0, u_old);

        if max(abs(u-u_old))<acr;
         % fprintf('Converged! iter= %d\n',j)
           break; 
        end
        u_old=u;
    end

    u_node(:, i) = u;
    total_residual_eval = total_residual_eval +j;
end


% integrate the coefficients of the polynomial terms by using
% Gauss-Legendre quadrature

u_alpha = zeros(m, num_terms);% the coefficients of the polynomial terms  

for i=1:num_terms    
    poly_eval = legendre_polynomial_2D( ind(i, :), node );
    
    for n=1:m
       u_alpha(n, i) =  sum(u_node(n, :).*poly_eval.*weight)/var_list(i) ;
        
    end  
end


end

