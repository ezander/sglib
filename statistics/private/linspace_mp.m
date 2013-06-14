function [x1,x2]=linspace_mp( xmin, xmax )
x1=linspace(xmin,xmax,100);
x2=x1(1:end-1)+(x1(2)-x1(1))/2;

function F2=pdf_integrate( f, F, x )
F2=cumsum([F(1), f])*(x(2)-x(1));
