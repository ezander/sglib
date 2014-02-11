% LINALG
%
% This directory contains functions for linear algebra related tasks. E.g.
% there are methods for computing the QR and SVD decompositions with
% respect to arbitrary inner products, for computing subspaces distances,
% for updating the SVD and several other.
%
% Files
%   frobenius_inner             - Computes the Frobenius inner product.
%   gram_schmidt                - Perform Gram-Schmidt orthogonalization.
%   khatriraorev                - Compute the reverse Khatri-Rao product.
%   matrix_gallery              - Short description of matrix_gallery.
%   qr_internal                 - 
%   revkron                     - Reversed Kronecker tensor product.
%   schattenp_truncate          - 
%   subspace_angles             - Compute the principal angles between subspaces.
%   subspace_distance           - Compute distance between subspaces.
%   svd_add                     - Efficiently add a decomposed matrix to an SVD.
%   svd_type_get                - Get type of SVD according to the middle argument.
%   svd_type_set                - Set the SVD type.
%   svd_update                  - Efficiently add columns to an SVD.
%   tridiagonal                 - Create tridiagonal matrix
%   unitvector                  - Creates one or more unit vectors.
%
% Unittests
%   unittest_frobenius_inner    - Test the FROBENIUS_INNER function.
%   unittest_gram_schmidt       - Test the GRAM_SCHMIDT function
%   unittest_khatriraorev       - Test the KHATRIRAOREV function.
%   unittest_qr_internal        - Test the QR_INTERNAL function.
%   unittest_revkron            - Test the REVKRON and function.
%   unittest_schattenp_truncate - Test the SCHATTENP_TRUNCATE function.
%   unittest_subspace_angles    - Test the SUBSPACE_ANGLES function.
%   unittest_subspace_distance  - Test the SUBSPACE_DISTANCE function.
%   unittest_svd_add            - Test the SVD_ADD function.
%   unittest_svd_type           - Test the SVD_TYPE_GET and _SET functions.
%   unittest_svd_update         - Test the SVD_UPDATE function.
%   unittest_tridiagonal        - Test the TRIDIAGONAL function.
%   unittest_unitvector         - Test the UNITVECTOR function.
