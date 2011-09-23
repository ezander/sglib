% identification
model=mfilename;

% load continuous model
model_continuous_easy

% geometry discretisation
num_refine=0;
num_refine_after=0;

% right hand side
m_f=4;
p_f=2;
l_f=4;

% coefficient field
m_k=3;
p_k=2;
l_k=3;

% dirirchlet boundary conditions
m_g=0;
p_g=1;
l_g=0;

% neumann boundary conditions
m_h=0;
p_h=1;
l_h=0;

% solution
p_u=2;
