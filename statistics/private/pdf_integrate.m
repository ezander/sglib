function F2=pdf_integrate( f, F, x )
F2=cumsum([F(1), f])*(x(2)-x(1));
