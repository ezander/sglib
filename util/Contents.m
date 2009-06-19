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
%   publish_to_latex          - parse options
%   edit_mfile                - Edit a new or existing m-file in the editor with path.
%
% Miscellaneous
%   merge_cells               - Merges two cell arrays with specified positions.
%   row_col_mult              - Multiply a matrix column- or row-wise with a vector.
%   sort_triple               - Sorts an index triple (obsolete). 
%
% Test functions
%   test_cached_funcall       - Test the CACHED_FUNCALL function.
%   test_format_poly          - Test the FORMAT_POLY functions.
%   test_funcall              - Test the FUNCALL function.
%   test_ismatoct             - Test the IS_MATLAB/IS_OCTAVE functions.
%   test_merge_cells          - Test the MERGE_CELLS function.
%   test_row_col_mult         - Test row_col_mult function.
