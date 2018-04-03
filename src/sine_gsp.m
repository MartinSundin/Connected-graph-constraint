%Finding the sparse matrix such that X = A*X
%When X contains sine signals
%Martin Sundin, 2016-09-06

N = 50;
M = 50;
eta = 1e-2;%1e-3;%*1e1;
epsilon1 = 0.01;%0.01/4*N^(3/2);%1e-3;%1e-5;
savename = 'graph_sine3_50_test3';

X = zeros(N,M);
f0 = 2*pi/N;%3*pi/N;
for k = 1:M
    t = 1:N;
    phi = 1*2*pi*rand;
    f = f0 + 0.1*(rand-0.5);%Nyqvist fequency?
    X(:,k) = abs(randn)*sin(f*t + phi)';
end
%plot(X);

e = ones(N,1);
E = ones(N,N)/N;
S = find(eye(N,N));
cvx_begin sdp %quiet
    variable A(N,N) symmetric
    %variable B(N,N) symmetric
    L = diag(A*e) - A;
    minimize( trace(X'*L*X)/M + eta*norm(A(:),1));
    subject to
        %L + E - epsilon1*eye(N,N) == hermitian_semidefinite( N );
        %B >= A;
        %-B <= A;
        A*e == e;
        A(:) >= 0;
        A(S) == 0;
        %trace(A) >= 0.9*N;
cvx_end

cvx_begin sdp %quiet
    variable A2(N,N) symmetric
    %variable B(N,N) symmetric
    L = diag(A2*e) - A2;
    minimize( trace(X'*L*X)/M + eta*norm(A2(:),1));
    subject to
        L + E - epsilon1*eye(N,N) == hermitian_semidefinite( N );
        %B >= A;
        %-B <= A;
        A2*e == e;
        A2(:) >= 0;
        A2(S) == 0;
        %trace(A) >= 0.9*N;
cvx_end

xy = zeros(N,2);
for i = 1:N
    theta = 2*pi/N*(i-1);
    %theta2 = 2*pi/N*(i-1+0.17);
    xy(i,:) = [-2 0] + [cos(theta) sin(theta)];
    %xy(i+5,:) = [2 0] + [cos(theta2) sin(theta2)];
end

tol1 = 0.001;%1e-4;%1e-4;%0.01;
figure;
subplot(1,3,1);
plot(X);
title('(a)');
xlim([1 N]);
subplot(1,3,2);
%tol1 = 0.05;%(1e-5)*max(A(:));%7.5*1e-2;%5*1e-3;%1e8;%0.03;
%spy(abs(A) >= tol1);
gplot(abs(A) >= tol1,xy);
hold on;
scatter(xy(:,1),xy(:,2),'MarkerFaceColor','r','LineWidth',0.5);
title('(b)');
axis off;
subplot(1,3,3);
%tol1 = 0.05;%(1e-5)*max(A2(:));%7.5*1e-2;%5*1e-3;%1e8;%0.03;
%spy(abs(A2) >= tol1);
gplot(abs(A2) >= tol1,xy);
hold on;
scatter(xy(:,1),xy(:,2),'MarkerFaceColor','r','LineWidth',0.5);
title('(c)');
axis off;


figure;
subplot(1,2,1);
hist(abs(A(:)),N);
xlim([-0.01 1.01]);
title('(a)');
subplot(1,2,2);
hist(abs(A2(:)),N);
xlim([-0.01 1.01]);
title('(b)');
ylim([0 60]);
% figure;contour(flip(A));colorbar;colormap gray;
% 
% %keyboard;
% 
% tol1 = mean(A(:))*0.5;%7.5*1e-2;%5*1e-3;%1e8;%0.03;
% xy = zeros(N,2);
% for i = 1:N
%     theta = 2*pi/N*(i-1);
%     %theta2 = 2*pi/N*(i-1+0.17);
%     xy(i,:) = [-2 0] + [cos(theta) sin(theta)];
%     %xy(i+5,:) = [2 0] + [cos(theta2) sin(theta2)];
% end
% figure;spy(abs(A) >= tol1);
% figure;
% gplot(abs(A) >= tol1,xy);
% hold on;
% scatter(xy(:,1),xy(:,2),'MarkerFaceColor','r');

save([savename '.mat'],'A','A2','eta','epsilon1','X','N','f0');
