%Plot points on Sweden map
%Martin Sundin, 2016-09-07

load('city45data.mat');

N = 45;
M = 45;
eta = 0.1;%1e-1;%1e-2;%1e-3;%*1e1;
epsilon1 = 0.01;%0.1;%0.01;%0.1*4/N^(3/2);
X = A45';
C = X*X';

e = ones(N,1);
E = ones(N,N)/N;
S = find(eye(N,N));
%Convex optimization program
cvx_begin sdp% quiet
    variable A(N,N) symmetric
    L = diag(A*e) - A;
    minimize( trace(X'*L*X)/M);% + eta*norm(A(:),1));
    subject to
        A*e == e;
        A(:) >= 0;
        A(S) == 0;
		% Connectedness contraint
        %L + E - epsilon1*eye(N,N) == hermitian_semidefinite( N );
        %e'*A*e >= 1;
cvx_end

drawmap = 0;
%A = A > 0.05;
if drawmap

%Draw map
worldmap([55 70],[5 25]);
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(land, 'FaceColor', 'green')
lakes = shaperead('worldlakes', 'UseGeoCoords', true);
geoshow(lakes, 'FaceColor', 'blue')

%Draw cities
load('city45data.mat');
L = length(coord45(:,1));
geom = {'Point'};
for k = 2:L
    geom{k} = 'Point';
end
cities = struct('Geometry',geom,'Lon',coord45(:,2),'Lat',coord45(:,1));
geoshow(cities, 'Marker', '.', 'Color', 'red','MarkerSize',15);

%Random matrix A
%N = 45;
%A = sprandn(45,45,0.1);
%A = abs(A);
%A = full(A + A');
%A = ones(45,45);

%Draw edges
lines = {};
longs = {};
lats = {};
bbox = {};
I = find(A);
for k = 1:length(I)
    t = I(k);
    i = 1+floor(t/N);
    j = t-N*(i-1);
    if j == 0
        j = N;
        i = i - 1;
    end
    lines{k} = 'Line';
    longs{k} = [coord45(i,2) coord45(j,2) NaN];
    lats{k} = [coord45(i,1) coord45(j,1) NaN];
    bbox{k} = [min(coord45(i,2),coord45(j,2)) min(coord45(i,1),coord45(j,1));max(coord45(i,2),coord45(j,2)) max(coord45(i,1),coord45(j,1)) ];
end
rivers = struct('Geometry',lines,'Lon',longs,'Lat',lats,'BoundingBox',bbox);
geoshow(rivers, 'Color', 'black');

%Draw cities
load('city45data.mat');
L = length(coord45(:,1));
geom = {'Point'};
for k = 2:L
    geom{k} = 'Point';
end
cities = struct('Geometry',geom,'Lon',coord45(:,2),'Lat',coord45(:,1));
geoshow(cities, 'Marker', '.', 'Color', 'red','MarkerSize',15);

%tightmap;
end