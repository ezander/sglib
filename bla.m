s='sfdsdfsdfsdf';
fprintf('\n');
fprintf('\n');
fprintf('%s\fXXX',s);
fprintf('%s\rXXX',s);
fprintf('%s\nXXX',s);
fprintf('\n');
fprintf('\n');





return


clf;
x=[0 1];
y=[1 1];
plot(x,y); axis([-0.1 1.1 -0.1 1.1]);


k=.3;
k=1;

for i=1:8
    m=2*i;
    % 1/2 (+-1/4)
    % 1/4, 3/4 (+-1/16)
    % 1/8, 3/8, 5/8 7/8 (+-1/64)
    as=(1:2:(2^i-1))/(2^i);

    for a=as
        a1=a-k/(2^m);
        a2=a+k/(2^m);
        x=[x a1 a1 a2 a2];
        y=[y  1  0  0  1];
        [x,I]=sort(x);
        y=y(I);
        ind=2*find(y(1:2:end)~=y(2:2:end));
        ind(2:2:end)=ind(2:2:end)-2;
        ind=[ind ind+1];
        x(ind)=[]; y(ind)=[];
        plot(x,y); axis([-0.1 1.1 -0.1 1.1]);
    end
    waitforbuttonpress;
end




return

m=5;
tspan=[0,1];
n_inst=1000;
[t,W]=do_wiener_vector_kl(m,tspan,n_inst);




return




us=true;
I1=multiindex(6,3,[],'use_sparse', us)
I2=multiindex(3,2,[],'use_sparse', us)
[I1c,I2c,I3c]=multiindex_combine({I1,I2},-1)

us=false;
I1=multiindex(6,3,[],'use_sparse', us)
I2=multiindex(3,2,[],'use_sparse', us)
[I1c2,I2c2,I3c2]=multiindex_combine({I1,I2},-1)
I1c-sparse(I1c2)
I2c-sparse(I2c2)
