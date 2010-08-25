% identification
model=mfilename;

% load continuous model
model_continuous_easy

% geometry discretisation
num_refine=2;
num_refine_after=1;

% right hand side
m_f=25;
p_f=3;
l_f=25;

% coefficient field
m_k=15;
p_k=3;
l_k=15;

% solution
p_u=3;
