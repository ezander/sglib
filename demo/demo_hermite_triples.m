% DEMO_HERMITE_TRIPLES Demonstrate the HERMITE_TRIPLES functions and do
% some timings on them.

%%
t=zeros(6,6,3);
for k=0:2; 
    for i=0:5; 
        for j=0:5; 
            t(i+1,j+1,k+1)=hermite_triple_product(i,j,k); 
        end; 
    end; 
end

% should all give one
disp('There should be six ones following...');
disp(all(all( t(:,:,1)==diag([1,1,2,6,24,120]) )));
disp(all(all( t(:,:,2)==diag([1,2,6,24,120],-1)+diag([1,2,6,24,120],1) )));
disp(all(all( t(:,:,3)==diag([2,6,24,120],-2)+diag([0,2,8,36,192,1200])+diag([2,6,24,120],2) )));

disp(all(all( t(:,:,1)==diag(factorial(0:5)) )));
disp(all(all( t(:,:,2)==diag(factorial(1:5),-1)+diag(factorial(1:5),1) )));
disp(all(all( t(:,:,3)==diag(factorial(2:5),-2)+diag(factorial(2:5),2)+diag( 2*(0:5).*factorial(0:5) ) )));

%% profiling section

tic
disp('Initializing hermite_triple_fast function...');
hermite_triple_fast( 7 );
toc

N=100;%00;
a=[1 2 3 4];
b=[3 4 5 6];
c=[4 5 6 7];
disp('Setting up multiindices...');
tic
for i=1:4; a=[a a]; b=[b b]; c=[c c]; end
toc
fprintf('Size of multiindices: %d\n', length(a) );

for i=1:8
    N=round(10^(0.5*(i-1)));
    fprintf('Trial %d (std.): N=%5d %d,  ',i,N);
    tic; 
    for j=1:N; hermite_triple_product( a,b,c ); end; 
    t1=toc;
    fprintf('elapsed time: %9.6f seconds (%9.6f ms per cycle) \n',t1, t1/N*1000);
    tic; 
    fprintf('Trial %d (fast): N=%5d %d,  ',i,N);
    for j=1:N; hermite_triple_fast( a,b,c ); end; 
    t2=toc;
    fprintf('elapsed time: %9.6f seconds (%9.6f ms per cycle) \n',t2, t2/N*1000);
end
