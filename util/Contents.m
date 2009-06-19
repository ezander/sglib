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
%   funcall                   - Call a function with given parameters (extending feval).
%   funcall_funfun            - Make FUNCALL mechanism available for Matlab function functions.
%   isfunction                - Determine whether VAR is callable via FUNCALL.
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
%   format_poly               - Format a polynomial for output.
%
% Argument checking
%   check_boolean             - Check whether condition is true on input.
%   check_condition           - Check whether specified condition holds for input parameter(s).
%   check_range               - Check whether input argument is scalar and in range.
%
% Version checking
%   ismatlab                  - Determine whether Matlab is running (and not octave).
%   isoctave                  - Determine whether Octave is running (and not Matlab).
%   isversion                 - Check that running Matlab version fits into some range.
%
% Development goodies
%   run_example               - Runs the example for a command.
%   publish_to_latex          - Uses the matlab publishing with options set up for Latex.
%   edit_mfile                - Edit a new or existing m-file in the editor with path.
%
% Miscellaneous
%   merge_cells               - Merges two cell arrays with specified positions.
%   row_col_mult              - Multiply a matrix column- or row-wise with a vector.
%   sort_triple               - Sorts an index triple (obsolete). 
%


% PLEASE KEEP THE EMPTY LINE ABOVE SO THAT THE TEST FUNCTIONS DONT CLUTTER
% UP THE CONTENTS DISPLAY.
% Test functions
%   test_cached_funcall       - Test the CACHED_FUNCALL function.
%   test_format_poly          - Test the FORMAT_POLY functions.
%   test_funcall              - Test the FUNCALL function.
%   test_ismatoct             - Test the IS_MATLAB/IS_OCTAVE functions.
%   test_merge_cells          - Test the MERGE_CELLS function.
%   test_row_col_mult         - Test row_col_mult function.



%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.
