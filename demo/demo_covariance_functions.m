function demo_covariance_functions
% DEMO_COVARIANCE_FUNCTIONS This demo shows the different covariance functions available.


%% Gaussian
x=linspace(-5,5,300); y=x;
l=[0.2 0.5 1 2];
for i=1:length(l)
    y(i,:)=gaussian_covariance( x, [], l(i), 1 );
end
plot( x, y' );
userwait;

%% sharp Gaussian with smoothing
x=linspace(-5,5,300); y=x;
smooth=[0 0.2 0.5 1 2];
for i=1:length(smooth)
    y(i,:)=gaussian_covariance( x, [], 0.2, 1, smooth(i) ) ;
end
plot( x, y');
userwait;

%% normal Gaussian with smoothing
x=linspace(-5,5,300); y=x;
smooth=[0 0.2 0.5 1 2];
for i=1:length(smooth)
    y(i,:)=gaussian_covariance( x, [], 1, 1, smooth(i) ) ;
end
plot( x, y');
userwait;

%% combinations of smoothing and diff. correlation lengths
x=linspace(-5,5,300); y=x;
smooth=[0 0.2 0.5 1 2];
for i=1:length(smooth)
    y(i,:)=gaussian_covariance( x, [], 1/(1+smooth(i)), 1, smooth(i) ) ;
end
plot( x, y');
userwait;

%% exponential
x=linspace(-5,5,300); y=x;
l=[0.2 0.5 1 2];
for i=1:length(l)
    y(i,:)=exponential_covariance( x, [], l(i), 1 ) ;
end
plot( x, y');
userwait;

%% exponential with smoothing
x=linspace(-5,5,300); y=x;
smooth=[0 0.2 0.5 1 2];
for i=1:length(smooth)
    y(i,:)=exponential_covariance( x, [], 1, 1, smooth(i) ) ;
end
plot( x, y');
userwait;

%% spherical
x=linspace(-5,5,300); y=x;
l=[0.2 0.5 1 2];
for i=1:length(l)
    y(i,:)=spherical_covariance( x, [], l(i), 1 ) ;
end
plot( x, y');
userwait;

%% spherical with smoothing
x=linspace(-5,5,300); y=x;
smooth=[0 0.2 0.5 1 2];
for i=1:length(smooth)
    y(i,:)=spherical_covariance( x, [], 1, 1, smooth(i) ) ;
end
plot( x, y');
userwait;

%% all for l=1
x=linspace(-5,5,300); y=x;
l=1;
y(1,:)=gaussian_covariance( x, [], l, 1 ) ;
y(2,:)=exponential_covariance( x, [], l, 1 ) ;
y(3,:)=spherical_covariance( x, [], l, 1 ) ;
plot( x, y');
userwait;

%% all for l=1 with smoothing
x=linspace(-5,5,300); y=x;
l=1;
y(1,:)=gaussian_covariance( x, [], l, 1, 0.2 ) ;
y(2,:)=exponential_covariance( x, [], l, 1, 0.2 ) ;
y(3,:)=spherical_covariance( x, [], l, 1, 0.2 ) ;
plot( x, y');
userwait;

%% all for l=1 with more smoothing
x=linspace(-5,5,300); y=x;
l=1;
y(1,:)=gaussian_covariance( x, [], l, 1, 1.2 ) ;
y(2,:)=exponential_covariance( x, [], l, 1, 1.2 ) ;
y(3,:)=spherical_covariance( x, [], l, 1, 1.2 ) ;
plot( x, y');
userwait;

%% all for l=2
x=linspace(-5,5,300); y=x;
l=2;
y(1,:)=gaussian_covariance( x, [], l, 1 ) ;
y(2,:)=exponential_covariance( x, [], l, 1 ) ;
y(3,:)=spherical_covariance( x, [], l, 1 ) ;
plot( x, y');
userwait;

%% making them all look the same (almost)
x=linspace(-5,5,300); y=x;
l=1;
y(1,:)=gaussian_covariance( x, [], l, 1 ) ;
y(2,:)=exponential_covariance( x, [], l*0.4, 1, 2.8 ) ;
y(3,:)=spherical_covariance( x, [], l*0.9, 1, 1.2 ) ;
plot( x, y');
userwait
