function t=toc(tin)

if nargin<1
    t=toc();
else
    t=(tic()-double(tin)) * 1e-6;
end
