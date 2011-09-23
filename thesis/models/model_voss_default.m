% identification
model=mfilename;

model_voss_continuous

% geometry
num_refine=2;
num_refine_after=0;

% right hand side
m_f=20;
p_f=3;
l_f=20;

% coefficient field
m_k=10;
p_k=3;
l_k=10;

% dirirchlet boundary conditions
m_g=0;
p_g=1;
l_g=0;

% neumann boundary conditions
m_h=0;
p_h=1;
l_h=0;

% solution
p_u=3;



%===
if false
% geometry
num_refine=1;
num_refine_after=0;

% right hand side
m_f=5;
p_f=1;
l_f=5;

% coefficient field
m_k=5;
p_k=1;
l_k=5;

% solution
p_u=2;
end;
