% SGLib (WiRe)
% Version 0.9.8 28-JUL-2013
%
% This directory contains the essential methods for the startup, settings
% and testing of sglib. Funtion for working with stochastic Galerkin
% methods i.e. dealing with stochastic distributions, orthogonal
% polynomials, random field creation, stochastic expansion methods etc can
% be found in SFEM, PCE, GPC and STOCHASTICS. Helper functions can be found
% in the UTIL subdirectory, a unit testing framework in MUNIT, plotting
% functions in PLOT and some methods for simple fem computations in
% FEM/SIMPLEFEM (only meant for testing, not for real fem computations,
% where some decent fem software should be called from here).
%
% Multiindices
%   multiindex                    - Generate a table of multiindices.
%   multiindex_anisotropic        - Short description of multiindex_anisotropic.
%   multiindex_combine            - Combine multiindices from different sources.
%   multiindex_factorial          - Compute the factorial of a multiindex.
%   multiindex_find               - Find a multiindex in a list of indices.
%   multiindex_order              - Compute the order of a multiindex.
%   multiindex_size               - Return the size of a multiindex set.
%
% Miscellaneous system routines
%   sglib_addpath                 - Set paths for sglib.
%   sglib_check_setup             - Checks whether SGLIB was setup correctly.
%   sglib_get_appdata             - Retrieves SGLib application specific data.
%   sglib_help                    - Show SGLIB help overview.
%   sglib_set_appdata             - Stores SGLib application specific data.
%   sglib_settings                - before running the setup should have been performed at least partly
%   sglib_startup                 - Called automatically by Matlab at startup.
%   sglib_testsuite               - Run all unit tests in this directory.
%   sglib_version                 - Returns version information for sglib.
%   startup                       - Called automatically by Matlab at startup.
%   stop_check                    - 


% PLEASE KEEP THE EMPTY LINE ABOVE SO THAT THE TEST FUNCTIONS DONT CLUTTER
% UP THE CONTENTS DISPLAY.
% Test and demo functions/scripts
%   unittest_multiindex           - Test the MULTIINDEX function.
%   unittest_multiindex_combine   - Test the MULTIINDEX_COMBINE function.
%   unittest_multiindex_factorial - Test the MULTIINDEX_FACTORIAL function.
%   unittest_multiindex_find      - Test the MULTIINDEX_FIND function.
%   unittest_multiindex_order     - Test the MULTIINDEX_ORDER function.

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.
