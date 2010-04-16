function  y=UCC_2D_function_v3(cuts, num, x)
%   %% num is the identity number of a function of a certain level, for level
%   %% 1 there is two function, for other level, there is 2
  

delta=1/cuts;

 if num==1   
      y= cuts*mod(x, double( 1/cuts)) ;
 else
     y= 1- cuts*mod(x, double(1/cuts)) ;
 end
 
 
 if length(unique(x)) ==length(x)   %% if there is duplicate element (possible if cuts and refine are not good pair), not to do next action
   y = interp1(x,  x,  y, 'nearest', 'extrap')  ;   %%  to eliminate the error due to bad mod() accuracy ccaused by large cuts number

 end 