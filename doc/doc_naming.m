% DOC_NAMING Naming and storage of variables and functions in SGLIB.
%   
%   The intend of this document is not to bind the user to some naming
%   scheme, but rather to aid the user in using a consistent, mnemonical
%   naming scheme which can lead through the whole process of setting up
%   and solving a stochastic PDE. It should further be not too lengthy, not
%   too far away from the mathematical naming scheme, and also be
%   unambiguous and consistent (i.e. the same for all fields and similar
%   datatypes). I think that the naming scheme described below does a
%   fairly good job at that.
%
% Naming of random fields:
% ========================
%   * Random fields generally have small Latin names like k,r,f etc. except
%     some special cases 
%   * When a quantity derived from a random field is purely stochastic its
%     name will be the corresponding Greek letter, otherwise still Latin.
%   * Names for the indices and index variables are Latin for normal
%     indices (e.g. spatial and KL) and Greek for multiindices (e.g. PCE).
%   * The name of the field should be prefixed or postfixed to each
%     quantity related to it, depending on the usual mathematical notation
%     for the quantity.
%   * The name should be similar/equivalent to the usual mathematical
%     notation. The ordering of indices is the same as in the underlying
%     storage (see also the section on storage).
%   * Spatial functions are always vertical, stochastic functions are
%     always horizontal (see Note 1).
%   * Other expansions like e.g. the KL take the remaining dimensions. For 
%     the nice effect this has see Note 2.
%
% Example for a random field r(w,omega):
%   * PCE parameters and indices
%       p_r   : maximum degree of polynomials in PCE of r
%       m_r   : number of independent basic random variables (Gaussians) in
%               the PCE of r
%       I_r   : index set for the PC expansion of random field r, the first
%               dimension specifies the number of the multiindex, i.e.
%               multiindex number j is I_r(j,:)
%       M     : number of stochastic ansatz functions, M=size(I_r,1), also
%               for standard multiindex set M=(m+p)!/(m!p!).
%       alpha : a multiindex, element of I_r, i.e. I_r(j,:)=alpha for some
%               j in 1..M
%       j     : linear index into I_r, alpha=I_r(j,:)
%   * KL Expansion parameters and indices
%       l_r : number of terms in the KL expansion of r
%       k   : an index into the KL, element 1..l_r (see the mnemonic? k=1..l)
%   * Spatial 
%       N : number of spatial ansatz functions
%       i : a spatial index, element 1..N
%   * Random field expansions
%       r_i_alpha   : spatial PCE expansion, i spatial index, alpha
%                     stochastic index in I_r, r_i_alpha(i,j) is equal to
%                     r_i^(alpha(j)), must be accompanied by some I_r 
%       mu_r_i      : mean of r, r_i_mu(i) mean at position pos(i)
%       r_i_k       : spatial KL eigenfunction, r(:, k) is the k-th
%                     eigenfunction
%       rho_k_alpha : PC expansion of KL random variable rho_k (KL of r is
%                     r(x,omega)=mu_r(x) + Sum_k^l_r r_k(x) * rho_k(omega)
%
%    * Note 1: On Storage: It is essential that there is a constistent
%       storage concept for spatial/stochastic quantities. In most Matlab
%       routines it does not really matter whether a vector is a row or a
%       column vector, and is implicityly converted. Here, it leads to
%       disaster, since it makes pure spatial and pure stochastic vectors
%       indiscernible, and taking one for the other leads to either program
%       crashes or wrong results. Therefore the above conventions have
%       been adopted.
%
%   * Note 2: Here you see that the PCE index is always second, and the
%       spatial is always first. The KL is thus first for the PCE and
%       second for the spatial functions. The nice thing about this is that
%       you can simply write:
%           r_i_alpha = r_i_k*rho_k_alpha
%       assuming zero mean otherwise add repmat( mu_r_i, 1, M ), which is
%       also quite obvious from the indexing (isn't it?)
%
%   * Note 3: The sigma's of the KL are absorbed into the spatial
%       functions. Otherwise, we would have some sigma_k also.
%
% Other naming schemes
% ====================
%   There are also other naming schemes that apply to: polynomials, support
%   functions, integration, geometry, tensor products, function handles and
%   so on. TODO: describe the other naming schemes!
%
% See also: DOC_FUNCTION_HANDLE



% THIS STUFF IS OLD AND JUST IMPORTANT. NEEDS SOME OVERHAUL.
% Common variable names
%   The following names usually have the same meaning in all of the code:
%     pcc                        = Coefficients of PC expansion
%                                  >> pcc( index, point )
%     pci                        = Indices of Hermite polynomials of PC
%                                  expansion
%     n                          = Spatial number of nodes/dofs
%     m                          = Number of independent gaussian rvs
%                                  i.e. number of terms in KL expansion
%     p                          = Degree of PCE expansion
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



0176/61287253;
