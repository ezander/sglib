function F=extend_rhs( F, I_k )

R=size(F{1},2);
M_k=size(I_k,1);
I=unitvector( ones(1,R), M_k, false);

F{3}=F{2};
F{2}=I;
