% UTIL
% ====
%
% This directory contains utility functions not directly related to
% stochastic Galerkin methods. Most of them could be used in any
% application, and it shouldn't be too hard to extract them from here into
% your own application.
%
% Function call mechanism
%   cached_funcall            - Store and retrieve the results of a function call from a file.
%   funarg                    - This is just a tag for positional arguments in FUNCREATE.
%   funcall                   - Call a function with given parameters (extending feval).
%   funcall_funfun            - Make FUNCALL mechanism available for Matlab function functions.
%   funcreate                 - Helps create partially parameterised functions for FUNCALL.
%   isfunction                - Determine whether VAR is callable via FUNCALL.
%   ellipsis                  - This is just a tag for positional arguments in FUNCREATE.
%   spatial_function          - Short description of spatial_function.
%   make_spatial_func         - Short description of make_spatial_function.
%
% Options mechanism
%   varargin2options          - Convert variable argument list to options structure.
%   get_option                - Get a user option or return the default.
%   check_unsupported_options - Check whether unsupported options were passed.
%
% Settings mechanism
%   settings_dialog           -
%
% Wait mechanism
%   userwait                  - Wait for the user to press a button or klick the mouse.
%   setuserwaitmode           - USERWAIT Sets the wait mode for USERWAIT.
%
% Output helper
%   underline                 - Underlines and outputs a given text.
%   save_format               - Saves current display formatting info.
%   restore_format            - Restores display formatting info.
%   erase_print               - Erase previous output and print new stuff.
%   strvarexpand              - Expand variables and expression inside a string.
%
% Argument checking
%   check_boolean             - Check whether condition is true on input.
%   check_condition           - Check whether specified condition holds for input parameter(s).
%   check_range               - Check whether input argument is scalar and in range.
%   check_function            - Check whether input is callable.
%   check_match               - Check whether input matrices are compatible.
%   check_matrix              - Check whether input is a matrix with certain properties.
%   check_scalar              - Check whether input is scalar.
%   check_type                - Check whether input is of the specified type.
%   check_vector              - Check whether input is a vector.
%
% Version checking
%   ismatlab                  - Determine whether Matlab is running (and not octave).
%   isoctave                  - Determine whether Octave is running (and not Matlab).
%   isversion                 - Check that running Matlab version fits into some range.
%
% Development goodies
%   run_example               - Runs the example for a command.
%   publish_to_latex          - Uses the matlab publishing with options set up for Latex.
%   medit                     - Edit a new or existing m-file in the editor with path.
%   medit_replace_edit        - Replaces the matlab edit function by medit.
%   settings_dialog           - 
%   get_mfile_path            - Return the complete path to the calling m-file.
%   openeps                   - Handler for opening EPS files from Matlab's OPEN function.
%
% Miscellaneous
%   merge_cells               - Merges two cell arrays with specified positions.
%   ifelse                    - Returns one of two arguments depending on condition.
%   makesavepath              - Making necessary subdirs for saving a file.
%
% Unclassified functions
%   cache_file_base           - Returns the base path where cache files are stored.
%   cache_script              - 
%   check_empty               - Checks that some variable is empty.
%   clear_funcall_cache       - Short description of clear_funcall_cache.
%   datestring                - Short description of datestring.
%   disable_toolboxes         - Disable unneccsary toolboxes.
%   disp_func                 - Convert function handle to string description.
%   estimate_rate             - Estimate rate exponent for algorithm runtime.
%   fullpath                  - 
%   generate_cache_filename   - Generate unique filename that can used for caching.
%   get_base_param            - Get parameter from base workspace or default.
%   getpid                    - Returns the process id (PID) of this Matlab process.
%   hash_matfile              - 
%   identity                  - Returns its argument unmodified.
%   la                        - 
%   log_file_base             - Returns the base path where log files are stored.
%   log_flush                 - Short description of log_flush.
%   log_start                 - Short description of log_start.
%   log_stop                  - Short description of log_stop.
%   logspace2                 - Logarithmically spaced vector
%   makehyperlink             - Short description of makehyperlink.
%   memstats                  - Short description of memstats.
%   never                     - Returns false.
%   package_function          - 
%   struct2options            - Short description of struct2options.
%   swallow                   - Just swallows its arguments
%   timers                    - Allows starting and stopping of timers for performance measurements.


% PLEASE KEEP THE EMPTY LINE ABOVE SO THAT THE TEST FUNCTIONS DONT CLUTTER
% UP THE CONTENTS DISPLAY.
% Test functions

%   unittest_cached_funcall   - Test the CACHED_FUNCALL function.
%   unittest_checks           - Test the CHECKS function.
%   unittest_funcall          - Test the FUNCALL function.
%   unittest_funcall_funfun   - Test the FUNCALL_FUNFUN function.
%   unittest_get_mfile_path   - Test the GET_MFILE_PATH function.
%   unittest_ifelse           - Test the IFELSE function.
%   unittest_isfunction       - Test the ISFUNCTION function.
%   unittest_ismatoct         - Test the IS_MATLAB/IS_OCTAVE functions.
%   unittest_isversion        - Test the ISVERSION function.
%   unittest_makesavepath     - Test the MAKESAVEPATH function.
%   unittest_merge_cells      - Test the MERGE_CELLS function.
%   unittest_options          - Test the OPTIONS function.
%   unittest_strvarexpand     - Test the STRVAREXPAND function.
%   unittest_underline        - Test the UNDERLINE function.
%   unittest_datestring       - Test the DATESTRING function.
%   unittest_estimate_rate    - Test the ESTIMATE_RATE function.
%   unittest_funcreate        - Test the FUNCREATE function.
%   unittest_get_base_param   - Test the GET_BASE_PARAM function.
%   unittest_makehyperlink    - Test the MAKEHYPERLINK function.
%   unittest_spatial_function - Test the SPATIAL_FUNCTION function.
%   unittest_struct2options   - Test the STRUCT2OPTIONS function.
%   unittest_timers           - Test the TIMERS function.

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

