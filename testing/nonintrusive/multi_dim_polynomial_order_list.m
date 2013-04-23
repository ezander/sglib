
 function [ind, var_list] =multi_dim_polynomial_order_list( n, p)
 % input:
 % n -- the number of variables of polynomial, maximum n=10
 % p -- the maximum order 
 % output:
 % ind -- the order index list of polynomials
 % var_list -- the L2 norms of the polynomials
 
L= factorial(n+p)/factorial(n)/factorial(p);
L=round(L);  %% in case the division is not exact, happens even for theoretical exact divisions on large numbers
 
ind=zeros(L ,n); 
var_list=zeros(L ,1);

%s=n;   %% position to increase index

var_list_1D = zeros(p+1 ,1);

for j=0: p
   
  var_list_1D(j+1) = 2/(2*j+1);    
    
end
    
    
i=1;



if n==1
    
    for d1=0:p 
                ind(i, :) = [d1  ];
                i=i+1; 
    end
    
   var_list =  var_list_1D;
   
elseif n==2
    
    for d1=0:p
        for d2=0:p-d1
            
                ind(i, :) = [d2 d1  ];
                i=i+1;
            
        end
    end
    
    var_list =  var_list_1D( ind(:, 1)+1).*var_list_1D( ind(:, 2)+1);
    
elseif n==3
    
    for d1=0:p
        for d2=0:p-d1
            for d3=0:p-d1-d2
                ind(i, :) = [d3 d2 d1];
                i=i+1;
            end
        end
    end
    
 var_list =  var_list_1D( ind(:, 1)+1).*var_list_1D( ind(:, 2)+1).*var_list_1D( ind(:, 3)+1); 
 
elseif n==4
    
    for d1=0:p
        for d2=0:p-d1
            for d3=0:p-d1-d2     
                for d4=0:p-d1-d2-d3
                    ind(i, :) = [d4 d3 d2 d1];
                    i=i+1;
                end
            end
        end
    end
    
 var_list =  var_list_1D( ind(:, 1)+1).*var_list_1D( ind(:, 2)+1).*var_list_1D( ind(:, 3)+1).*var_list_1D( ind(:, 4)+1);  
 
elseif n==5
    
    for d1=0:p
        for d2=0:p-d1
            for d3=0:p-d1-d2     
                for d4=0:p-d1-d2-d3     
                    for d5=0:p-d1-d2-d3-d4
                        ind(i, :) = [d5 d4 d3 d2  d1];
                        i=i+1;
                    end
                end
            end
        end
    end
    
 var_list =  var_list_1D( ind(:, 1)+1).*var_list_1D( ind(:, 2)+1).*var_list_1D( ind(:, 3)+1).*var_list_1D( ind(:, 4)+1).*var_list_1D( ind(:, 5)+1);   
 
elseif n==6
    
    for d1=0:p
        for d2=0:p-d1
            for d3=0:p-d1-d2     
                for d4=0:p-d1-d2-d3     
                    for d5=0:p-d1-d2-d3-d4 
                        for d6=0:p-d1-d2-d3-d4-d5
                            ind(i, :) = [d6 d5 d4 d3  d2  d1];
                            i=i+1;
                        end
                    end
                end
            end
        end
    end
    
 var_list =  var_list_1D( ind(:, 1)+1).*var_list_1D( ind(:, 2)+1).*var_list_1D( ind(:, 3)+1).*var_list_1D( ind(:, 4)+1).*var_list_1D( ind(:, 5)+1) ...
                                      .*var_list_1D( ind(:, 6)+1) ;    
elseif n==7
    
    for d1=0:p
        for d2=0:p-d1
            for d3=0:p-d1-d2     
                for d4=0:p-d1-d2-d3     
                    for d5=0:p-d1-d2-d3-d4 
                        for d6=0:p-d1-d2-d3-d4-d5 
                            for d7=0:p-d1-d2-d3-d4-d5-d6
                                ind(i, :) = [d7 d6 d5 d4  d3  d2  d1];
                                i=i+1;
                            end
                        end
                    end
                end
            end
        end
    end
    
 var_list =  var_list_1D( ind(:, 1)+1).*var_list_1D( ind(:, 2)+1).*var_list_1D( ind(:, 3)+1).*var_list_1D( ind(:, 4)+1).*var_list_1D( ind(:, 5)+1) ...
                                      .*var_list_1D( ind(:, 6)+1).*var_list_1D( ind(:, 7)+1) ;  
                                  
elseif n==8
    
    for d1=0:p
        for d2=0:p-d1
            for d3=0:p-d1-d2     
                for d4=0:p-d1-d2-d3     
                    for d5=0:p-d1-d2-d3-d4 
                        for d6=0:p-d1-d2-d3-d4-d5 
                            for d7=0:p-d1-d2-d3-d4-d5-d6  
                                for d8=0:p-d1-d2-d3-d4-d5-d6-d7
                                    ind(i, :) = [d8 d7 d6 d5  d4  d3  d2 d1];
                                    i=i+1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
 var_list =  var_list_1D( ind(:, 1)+1).*var_list_1D( ind(:, 2)+1).*var_list_1D( ind(:, 3)+1).*var_list_1D( ind(:, 4)+1).*var_list_1D( ind(:, 5)+1) ...
                                      .*var_list_1D( ind(:, 6)+1).*var_list_1D( ind(:, 7)+1).*var_list_1D( ind(:, 8)+1) ;                                   
elseif n==9
    
    for d1=0:p
        for d2=0:p-d1
            for d3=0:p-d1-d2     
                for d4=0:p-d1-d2-d3     
                    for d5=0:p-d1-d2-d3-d4 
                        for d6=0:p-d1-d2-d3-d4-d5 
                            for d7=0:p-d1-d2-d3-d4-d5-d6  
                                for d8=0:p-d1-d2-d3-d4-d5-d6-d7    
                                    for d9=0:p-d1-d2-d3-d4-d5-d6-d7-d8
                                        ind(i, :) = [d9 d8 d7 d6  d5  d4  d3 d2  d1];
                                        i=i+1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
 var_list =  var_list_1D( ind(:, 1)+1).*var_list_1D( ind(:, 2)+1).*var_list_1D( ind(:, 3)+1).*var_list_1D( ind(:, 4)+1).*var_list_1D( ind(:, 5)+1) ...
                                      .*var_list_1D( ind(:, 6)+1).*var_list_1D( ind(:, 7)+1).*var_list_1D( ind(:, 8)+1).*var_list_1D( ind(:, 9)+1) ;                                       
elseif n==10
    
    for d1=0:p
        for d2=0:p-d1
            for d3=0:p-d1-d2     
                for d4=0:p-d1-d2-d3     
                    for d5=0:p-d1-d2-d3-d4 
                        for d6=0:p-d1-d2-d3-d4-d5 
                            for d7=0:p-d1-d2-d3-d4-d5-d6  
                                for d8=0:p-d1-d2-d3-d4-d5-d6-d7    
                                    for d9=0:p-d1-d2-d3-d4-d5-d6-d7-d8
                                           for d10=0:p-d1-d2-d3-d4-d5-d6-d7-d8-d9
                                                ind(i, :) = [d10 d9 d8 d7 d6  d5  d4  d3 d2  d1];
                                                 i=i+1;
                                           end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
 var_list =  var_list_1D( ind(:, 1)+1).*var_list_1D( ind(:, 2)+1).*var_list_1D( ind(:, 3)+1).*var_list_1D( ind(:, 4)+1).*var_list_1D( ind(:, 5)+1) ...
                                      .*var_list_1D( ind(:, 6)+1).*var_list_1D( ind(:, 7)+1).*var_list_1D( ind(:, 8)+1).*var_list_1D( ind(:, 9)+1) ...
                                      .*var_list_1D( ind(:, 10)+1) ;                                      
                                  
end

total_order= sum(ind, 2); 
[~, index ] = sort(total_order);
%[asa, index ] = sort(total_order)

ind = ind(index, :);
var_list = var_list(index);

 end
