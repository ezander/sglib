% DEMO
% ====
%
% This directory contains demonstration programs for SGLIB. Unfortunately
% many of them are outdated currently and have to be adapted to new calling
% mechanisms implemented in SGLIB. Further, in a next version there should
% be a distinction between demos that show how to do something efficiently,
% without using too many parameters and stuff; those should be named
% howto_*.m. The others are for showing of all possibilities there are,
% e.g. all the distributions, and covariance functions or all the different
% parameters there are to a certain function and their effect.
%
% Currently known working demos
%   demo_tensor_methods       - function demo_tensor_methods
%   demo_sparsity             -
%
% Demos with unknown status
%   demo_animation            - Shows a smoothly varying random field.
%   demo_b_over_a             - Show division of random variables.
%   demo_covariance_functions - This demo shows the different covariance functions available.
%   demo_distributions        - Demonstrate usage and some properties of the probability distribution functions.
%   demo_field_expand_2d      - Show the expansion of a 2D random field.
%   demo_gauss_hermite        - Show some properties of Gauss-Hermite quadrature.
%   demo_hermite_triples      - Demonstrate the HERMITE_TRIPLES functions and do
%   demo_kl_expand            - Demonstrate usage of the Karhunen-Loeve expansion functions
%   demo_klexpand_shapes      - DEMO_FIELD_EXPAND_2D Show the expansion of a 2D random field.
%   demo_pce_expand_1d        - DEMO_PCE_EXPAND_1D
%   demo_rf_expand_pce_sg     - DEMO_RF_EXPAND_PCE_SG
%   demo_tensor_2d            -
%
% Simluating content and results from some papers
%   paper_phoon               - Multivariate level incompatibility
%   paper_sakamoto_ghanem     - Test the ideas in a paper of Sakamoto and Ghanem.
%
% Helper functions
%   load_kl_model             - MODEL_KL Load or compute a random field model in KL expanded form.
%   load_kl_operator          -
%   load_operator             -
%   load_pdetool_geom         -
%   stochastic_kl_pce_bcs     -
%
% Obsolete
%   tensor_operator_normest   -
%   unittest_tictoc               -



%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.
