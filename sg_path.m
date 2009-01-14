function srcdir=sg_path( action )

srcdir="/home/ezander/projects/stochastics/sglib/trunk/scripts";
if nargin<1
  return;
end


switch action
  case 'get'
    return;
  case 'set'
    addpath( [srcdir '/munit' ] );
    addpath( [srcdir '/experimental' ] );
    addpath( [srcdir '/util' ] );
    addpath( [srcdir '/simplefem' ] );
end
