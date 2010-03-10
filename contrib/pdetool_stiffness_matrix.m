function K=pdetool_stiffness_matrix( ptdata, k )

p=ptdata{1};
t=ptdata{3};
cp=k';
ct=sum(cp(t(1:3,:)),1)/3;
K=assema(p,t,ct,0,0);

% left here for comparison
%K2=stiffness_matrix( p, t(1:3,:), k );
%assert_equals( K, K2 );
