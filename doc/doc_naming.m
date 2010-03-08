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
% Index notation, ordering of indices, and tensors:
% =================================================
%    Two things have to be noted about indices:
%      1) Many quantities here have two or more indices. Since it is
%         difficult to remember which comes at which position, an index
%         indicates the order of indices, where indices belonging to
%         certain concepts have fixed names. E.g. the number of point in a
%         set of points is i, a multiindex is alpha, one specific KL
%         eigenfunction and related quantities have a k, ... So for example
%         r_i_alpha is the coefficient in the PCE in the random field r at
%         position x_i belongin to multiindex alpha (exactly: for
%         r_i_alpha(j) the corresponding alpha is I_r(j,:))
%      2) Duality is an important concept: if a prime index has usually
%         position 1 or 2 then the "dual" index should have position 2 or
%         1. One sees that good in the call to e.g. pce_field_realization(
%         x, u_i_alpha, I_alpha, xi, varargin ). Here the dimensions are: 
%         x is spatial dimension times number of points, u_i_alpha is
%         number of points times size of multiindex set, I_alpha is size of
%         multiindex set times number of Gaussians, xi is number of
%         Gaussian times number of realizations. 
%         This reminds much of matrix multiplication and makes it much
%         easier to have things consistent then trying to always put an
%         index belonging to a concept into one position (this really
%         doesn't work). 
%    Some examples:
%       r_i_alpha: pce of random field r, first index position, second
%                  multiindex
%       r_i_k:     KL eigenfunction of r, first index position, second number
%                  of eigenfunction
%       mu_r_i:    mean of random field r at position i
%       sigma_k:   KL eigenvalue of KL eigenfunction k (should be
%                  sigma_r_k) probably
%       I_r:       (should be I_r_alpha_j) first index multiindex number,
%                  second number of Gaussian
%       x or pos:  should be x_j_i, first index spatial coordinate, second
%                  is point number
%       xi:        a random vector for stochastic field generation, (should
%                  be xi_j_?) first coordinate number of 
%     Old text (revamp or delete)
%         Duality between indices: one certain kind of index should always
%         be in the same position (i.e. dimension) if there is a dual index
%         (explain later what is) it should always occupy the "dual"
%         position e.g. the random var index in a multiindex is in dim 2,
%         thus when evaluating with repect to a multiindex the actual
%         values for the random vars should be in dim 1 the linear index of
%         a multiindex is in dim 1, so a pce expansion of some random
%         variable should be in dim 2; so the spatial index of the pce
%         should be in dim 1
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
% Some specific names
% ====================
%  * Specific names
%     d : dimension R^d (mostly spatial)
%     r : dimension R^r (rather general)
%     r : can also be a general unspecified random field
%     n : number of points in one spatial dimension (N=n^d)
%  * General schemes
%     X_func : function handle for function which does 'X'
%     Xi     : inner points corresponding to var X, e.g. fi, Ki, ui, ..
%     Xb     : boundary points corresponding to var X, e.g. gb, ..
%  * Geometry
%     els : elements of the geometry, list of nodes, els(i,:) contains the
%           node numbers of the points bounding element i
%     pos : position of nodes, pos(i,:) gives the coordinates of node i
%     bnd : points on the boundary
%  * FEM stuff
%     K  : stiffness matrix
%     Ki : K reduced to the inner nodes
%     M  : mass matrix (can have arbitrary mass distribution)
%     G  : spatial Gramian, equal to mass matrix with constant mass density
%          one (sometimes G_N to distinguish from the stochastic Gramian)
%
%  names for matrices (A,M), tensors (T,U,A,X,Y), linear operators (L),
%
%
% Structs and the like
% ====================
% There are certain sets of variables the come along in groups very often.
% E.g. for the geometry the elements and points, for the Kl the mean, the
% KL eigenfunctions and the KL random variables, for the PCE the
% coefficients and the index set, and so on. While it would be possible to
% put them into structs to make this grouping clear and lessen the need to
% pass lots of variables around, the author refrains from doing so. The
% reason are the following:
%   * When arguments are passed explicitly in and out it is absolutely
%     clear which of the arguments are actually used or produced. In
%     structs this is not clear (I've seen cases where it would take
%     man-years to figure out what is actually done in a function).
%   * Grouping in structs is rather inflexible. Sometimes you want to have
%     a little different grouping, e.g. a function needs parameter 1 from
%     struct A and parameter 2 from struct B, then you can either put both
%     parameters into a new struct, which is ugly and somehow contrary to
%     grouping the variable that way in the first place, or you put both
%     structs into some agglomerate struct. The second struct is especially
%     annoying for users who don't want to use your whole framework, but
%     only single functions out of it, since they are forced to set up the
%     whole structs and figure out (usually by reading the source), which
%     structure fields are indeed used.
%   * If the associated parameters in in and out argument lists are always
%     side by side and in the same order they can be stored in cell arrays
%     and the sequenced with {:} into the argument list. E.g. the elements
%     and points for the geometry always appear in this order. So you can
%     write e.g.
%       [pos,els,bnd]=create_mesh_1d( 0, 2, 5 );
%       geom={pos,els};
%       K=stiffness_matrix( geom{:}, ones(size(pos)) );
%     You can even place the cell array in the output argument lists:
%       [geom{1:3}]=create_mesh_1d( 0, 2, 5 );
%       K=stiffness_matrix( geom{1:2}, ones(size(pos)) );
%     But as you can see, you are free to include information about
%     boundary nodes into your struct or not.
%     You can to the same with the KL e.g. and the PCE: Instead of writing
%       % snip
%       [f_i_alpha, I_f]=expand_field_pce_sg( stdnor_f, cov_f, [], pos, G_N, p_f, m_f );
%       [f_i_k,phi_k_alpha]=pce_to_kl( f_i_alpha, I_f, l_f, G_N );
%     you can write
%       [pce_f{1:2}]=expand_field_pce_sg( stdnor_f, cov_f, [], pos, G_N, p_f, m_f );
%       [kl_f{1:2}]=pce_to_kl( pce_f{:}, l_f, G_N );
%     and later:
%       plot_kl_pce_realizations_1d( pos, kl_f{:}, pce_f{2}, 'realizations', 50 );
%     Here you see one problem: you have to reference the second field of
%     the pce cell array which contains the multiindex array since the
%     function needs to know that. You could, of course, put that into the
%     Kl cell array or pce_to_kl could have returned it. However, there is
%     a problem with matlab in doing so: there are no pointers or reference
%     variables, each cell array has its own copy. Ok, it's copy on write,
%     so as long as you don't modify it they share the same memory, but if
%     you modify it (take e.g. multiindex_combine) you need to remember to
%     update both cell arrays. (BTW, no, objects make this even worse,
%     don't use them ...).
%     However, SGLIB leaves that open to you how you want to do it.
%
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




%

0176/61287253;
