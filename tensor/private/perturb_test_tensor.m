function T2=perturb_test_tensor(T1,delta)

t=tensor_to_array( T1 );
dt=randn(size(t));
dt=delta*dt/norm(dt,'fro');
t=t+dt;
[u,s,v]=svd( t );
T2={u*s,v};
