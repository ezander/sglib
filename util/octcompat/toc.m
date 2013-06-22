function t=new_toc(tin)

if nargin<1
    t=builtin('toc');
else
    t=(tic()-double(tin)) * 1e-6;
end
