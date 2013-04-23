function [ u_alpha, total_residual_eval ] = Gauss_Seidel_solver( R, f0, order, qua_order, acr ) 
 
%%====================================================================================
 % compute the coefficients by stochastic Galerkin method, using Gauss-Seidel iterations
 
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
 
 
  u_alpha  = zeros(m, num_terms); % the coefficients of the polynomial terms 
  temp=zeros(m,num_node);
  
  maxiter=1000;
 % acr = 1000*eps;  
  
  poly_eval= zeros(num_terms, num_node);
  
      for i=1:num_terms   
         poly_eval(i,:) = legendre_polynomial_2D( ind(i, :), node );  % evaluate the ith polynomial term at the Gauss-Legendre nodes
      end
  
  for j=1:maxiter
       u_alpha_old =  u_alpha;
       
    for i=1:num_terms   
         
       u_cur = legendre_approx( u_alpha, ind, node );  % u approximated by polynomials using the most recent updated  coefficients. 
             
       % evaluate A^(-1)*(p_2 f - (2+p_1) (u'*u) *u) 
       for k=1:num_node
          temp(:,k) = u_cur(:,k) + residual(node(:,k), AI, A, f0, u_cur(:,k));
       end
       
       % integrate for the coefficients
        u_alpha(:, i) = sum( repmat(poly_eval(i,:), m, 1).* temp.* repmat(weight, m, 1), 2)/var_list(i);
    end  
   
    % exit condition
   % if  max(max(abs(u_alpha_old - u_alpha)))<acr
    if   sqrt(mean((u_alpha_old(:) - u_alpha(:)).^2))  <acr    
        % fprintf('Gauss_Seidel converged! num. residual evaluations = %d\n',num_node*num_terms*j);
         total_residual_eval = num_node*num_terms*j;
         break;
    end
  end


end

