function show_solve_huge_model_prec_methods

clc
%do_compare( 'model_large_easy', get_solve_options )
%do_compare( 'model_medium_easy', get_solve_options )
do_compare( 'model_small_easy', get_solve_options )




function opts=get_solve_options
opts={};
opts{end+1}=varargin2options( {'longdescr', 'normal tensor solver', 'descr', 'normal'} );
opts{end+1}=varargin2options( {'longdescr', 'prec tensor solver', 'prec', {'same'}, 'descr', 'prec'} );
%opts{end+1}=varargin2options( {'longdescr', 'prec tensor solver', 'prec', {'ilu'}, 'descr', 'ilu nofill'} );
ilu_setup={'type', 'nofill'};
opts{end+1}=varargin2options( {'longdescr', 'ilu nofill prec tensor solver', 'prec', {'ilu', ilu_setup}, 'descr', 'ilu nofill'} );
% ilu_setup={'type', 'nofill', 'milu', 'row' };
% opts{end+1}=varargin2options( {'longdescr', 'ilu nofill row prec tensor solver', 'prec', {'ilu', ilu_setup}, 'descr', 'ilu nofill row'} );
ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'udiag', 1};
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 prec tensor solver', 'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2'} );
ilu_setup={'type', 'ilutp', 'droptol', 0.2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 0.2 row prec tensor solver', 'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 0.2e-2 row'} );
ilu_setup={'type', 'ilutp', 'droptol', 0.5e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 0.5 row prec tensor solver', 'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 0.5e-2 row'} );
ilu_setup={'type', 'ilutp', 'droptol', 1e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 1 row prec tensor solver', 'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 1e-2 row'} );
ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', 'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2 row'} );
ilu_setup={'type', 'ilutp', 'droptol', 4e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 4 row prec tensor solver', 'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 4e-2 row'} );

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', 'dyn', true, 'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2 row'} );

% ilu_setup=struct( 'type', 'nofill', 'milu', 'row', 'droptol', 2e-2 );
% ilu_setup=struct( 'type', 'ilutp', 'milu', 'row', 'droptol', 2e-2 );
