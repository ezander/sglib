% DOC_NAMING Naming of variables and functions in SGLIB.
% Rational: not binding users but providing consistent interfaces
% Stochastics: naming, why and how, consistency, ...
% Other naming conventions
%
% THIS STUFF IS OLD AND JUST IMPORTANT. NEEDS SOME OVERHAUL.
% Common variable names
%   It was aspired to use consistent variable names for recurring concepts.
%   The following names usually have the same meaning in all of the code:
%     pcc                        = Coefficients of PC expansion
%                                  >> pcc( index, point )
%     pci                        = Indices of Hermite polynomials of PC
%                                  expansion
%     n                          = Spatial number of nodes/dofs
%     m                          = Number of independent gaussian rvs
%                                  i.e. number of terms in KL expansion
%     p                          = Degree of PCE expansion
% Naming conventions
%     * always include the name of the basic variable in the name where
%     this expansion or whatever is referring to, i.e. if a variable u is
%     expanded somehow the coefficients should be named after u e.g.
%     u_alpha etc. 
%     * the indices of the expansion invoked on the variable are put behind
%     the base name in order of the expansion
%     * Examples:
%
%                   coefficients of the kl eigenfunction
%     * How to name coefficients, eigenfunctions, random vars etc.
%
%
% Data structures
%   Hermite polynomials: 
%   Polynomials are usually expressed as column vectors in Matlab, i.e. a
%   polynomial p(x)=3x^2+5x-2 is represented as p=[3, 5, -2] (in this
%   order, highest index first). The coefficients for Hermite polynomials
%   in this package are represented a bit differently in that the lowest
%   index comes first (which, in my eyes, makes more sense from a
%   programmers point of view), i.e. if some PCE expansion of a random
%   variable returns something like p(x)=2 H_0(x) + 3 H_1(x) -4 H_2(x),
%   then the coefficients are stored as p=[2, 3, -4] (mark the order and
%   the semicolons). 
%   Matlab usually doesn't care whether you pass a row or a column vector
%   as a representation of a polynomial. Since we have to use arrays of
%   polynomial coefficients quite often, we have to make a difference. Thus
%   p=[2;3;-4] would mean 3 polynomial representations in Hermite
%   polynomials namely p1=2 H_0(x), p2=3 H_0(x) and p3=-4 H_0(x). Thus if
%   pcc represents the coefficients of a polynomials chaos expansion then
%   pcc(i,j) represents the coefficient of H_{j-1} in polynomial i. That
%   means:
%      p_i(x) = pcc(1,i) H_0(x) + pcc(2,i) H_1(x) + pcc(3,i) H_2(x) + ...
%   
%
%   Multivariate Hermite polynomials:  
%   For multivariate Hermite polynomials things get a bit more difficult
%   since the index of the polynomial can no longer be determined by the
%   order of the coefficient. Only for the very first coefficient we adopt
%   the convention that this should always refer to the constant
%   polynomial (i.e. H_0(xi1)*H_0(xi2)*H_0(xi3)*...). For all others we
%   have to remember which order the Hermite polynomials have for each of
%   the coefficients. The coefficients are ususally kept in an array by the
%   name of pci (polynomial chaos indices). 
%  
%   Coordinates:
%   In a coordinate array x the first index determines the point and the
%   seoncd index the dimension, i.e. x(i,2) is the y coordinate of point
%   x_i.



