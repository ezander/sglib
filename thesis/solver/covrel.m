d=3;


s=0;
for i=1:10000
    X=rand(d,1);
    Y=rand(d,1);
    Z=rand(d,1);
    r1=(X'*Z)*(Y'*Y)/((X'*Y)*(Y'*Z));
    X=X/norm(X);
    Y=Y/norm(Y);
    Z=Z/norm(Z);
    r2=(X'*Z)*(Y'*Y)/((X'*Y)*(Y'*Z));
    %t=(X'*Z)*(Y'*Y)>=(X'*Y)*(Y'*Z);
    cb=(X'*Z);
    ca=(X'*Y);
    cc=(Y'*Z);
    sa=sqrt(1-ca^2);
    sb=sqrt(1-cb^2);
    sc=sqrt(1-cc^2);
    t=cb>=ca*cc-sa*sc-(1e-5);
    if ~t
        X'
        Y'
        Z'
        clf
        zero=[0,0]; div=[NaN,NaN];
        P=[zero; X'; div; zero; Y'; div; zero; Z'; div];
        line( P(:,1)', P(:,2)' ) 

        zero=[0;0];
        P=[zero, X; zero, Y; zero, Z];
        line( P(1:2:end,:)', P(2:2:end,:)' ) 
        legend('X', 'Y', 'Z')
        axis equal
        keyboard
    end
    s=s+t;
end
        
