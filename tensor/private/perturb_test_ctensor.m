function T2=perturb_test_ctensor(T1,delta)

t=ctensor_to_array( T1 );
dt=randn(size(t));
dt=delta*dt/norm(dt,'fro');
t=t+dt;
[u,s,v]=svd( t );
T2={u*s,v};
