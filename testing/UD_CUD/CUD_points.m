function  p= CUD_points(dim,  K ) 
 
%*****************************************************************************80
%
%%  CUD_points generates N sample points for  compound uncorrelated
%%  dimension  quadrature
 
%  Modified:
%
%    29 March 2010
%
%  Author:
%
%    Dishi Liu
 
%  Reference:

%   Liu, Dishi
%   Uncertainty Quantification with Shallow Water Equations
%   Phd Thesis, Institute of Scientific Computing, Technical University
%   Braunschweig, 2009

%  Parameters:
%
%    Input, integer DIM, the dimmension number
%
%    Input, integer K,   K= N/2^(dim-1) with N the number of sample points
%
 
%    Output, real p, the  N points

 

K_pool=[10  20   30  40  50  100  200 300 400 500  1000  2000  3000  4000  5000 10000];

good_level_set_9D=[ ...  %  12-Jun-2009 18:14:39   
   100000013   100000017   100000003   100000011   100000001   100000011   100000009   100000003  ; ...   
   100000009   100000003   100000031   100000021   100000017   100000013   100000007   100000033  ; ...   
   100000027   100000001   100000037   100000001   100000037   100000019   100000031   100000039  ; ...   
   100000051   100000027   100000061   100000007   100000007   100000067   100000063   100000019; ...   
   100000007   100000089   100000043   100000069   100000017   100000079   100000013   100000041; ...   
   100000161   100000169   100000169   100000193   100000031   100000187   100000071   100000137; ...   
   100000259   100000053   100000291   100000269   100000009   100000329   100000251   100000263; ...   
   100000361   100000297   100000241   100000043   100000319   100000337   100000141   100000579; ...   
   100000683   100000381   100000437   100000039   100000629   100000737   100000229   100000471; ...   
   100000891   100000651   100000467   100000093   100000809   100000929   100000467   100000781; ...   
   100001519   100001821   100001153   100000087   100000089   100000297   100001063   100000731; ...   
   100003239   100003097   100003267   100001139   100000063   100001017   100002551   100003461; ...   
   100002467   100002673   100001417   100000073   100005197   100002893   100004851   100005427; ...   
   100001449   100004903   100001903   100006191   100007837   100006831   100007089   100006641; ...   
   100001949   100004123   100002629   100001339   100000437   100009141   100004387   100001377; ...   
   100006223   100016183   100013389   100003953   100004687   100007011   100009441   100009323; ...   
 ] ; 

if  not(ismember(dim, [1:9]));
     error('Dimension number exceeds 9');
     return
end


  [tf, loc]=ismember(K, K_pool);
  
  if tf
      level_set= good_level_set_9D(loc, 1:dim-1);

      p=zeros(dim, K);
     
      delta=1/K;
      
      flag=zeros(2^(dim-1),  dim-1);

        for i=0:2^(dim-1)-1                      %% to make  the binary expression of i
                 for j=1:dim-1

                     resid=mod(i, 2^(dim -j ));

                     if   resid >=2^(dim-1-j)
                           flag(i+1,j) = 2;
                     else
                            flag(i+1,j) =1;
                     end
                 end
        end
      
      
      x1=delta/2 : delta: 1;
      index=1;
      
      for i=1:2^(dim-1)
          
            p(1, index:index+K-1) = x1;
           for j=2: dim
              p(j, index:index+K-1) = UCC_2D_function_v3(level_set(j-1),  flag(i,j-1),   p(j-1, index:index+K-1)) ;
           end
           
           index=index+K;   
           
      end
      
      
  else
      error('The K number should be within the set  [10  20   30  40  50  100  200 300 400 500  1000  2000  3000  4000  5000 10000 ]');
 
  end
       
 