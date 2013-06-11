function y = logspace2( d1, d2, n )
% LOGSPACE2 Logarithmically spaced vector
%   y = LOGSPACE2(d1, d2) generates a row vector of 100 logarithmically
%   equally spaced points between d1 and d2.
%
%   LOGSPACE2 is an improved version of the matlab function LOGSPACE as it
%   is much more like LINSPACE its behaviour. LOGSPACE2 also uses 100 points
%   as the default, uses d1 and d2 as the endpoints of the intervall and not
%   10^d1 and 10^d2 and also avoids the silly special treatment of pi as
%   second parameter. So you can simply replace a call to LINSPACE by a call
%   to LOGSPACE2 if logarithmical scaling is desired without changing
%   anything else.
%
%   LOGSPACE2(d1, d2, N) generates N points.
%
%   See also LINSPACE, LOGSPACE :.

%    Copyright 2002 Elmar Zander, Institute of Scientific Computing, Braunschweig

if nargin==2
    n=100;
end

y=exp( linspace(log(d1),log(d2),n) );
