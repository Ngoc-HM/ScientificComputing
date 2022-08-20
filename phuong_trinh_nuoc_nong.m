clf;
clear all; % xóa cmd
% tạo kích cỡ đồ thị
n = 50;
dt = 0.01;
dx = 1;
dy = 1;
g = 9.8;
 
U = ones(n+2,n+2); 
F = zeros(n+2,n+2);
G = zeros(n+2,n+2);
% vẽ cột sóng ở thời điểm ban đầu 
grid = surf(U);
colormap('bone');
shading interp;
zlim([-2 5]);
caxis([-2 5]);
alpha 0.7;
axis([1 n 1 n -5 5]);
colorbar;
hold all;
% tạo cột sóng mẫu
[x,y] = meshgrid( linspace(-5,5,10) ); % vẽ đồ thị hàm 2 biến f(x,y)
R = sqrt(x.^2 + y.^2);
Z = 5*(sin(R)./R);
Z = max(Z,0);
Z(1:2,:) = 0;
Z(9:10,:) = 0;
% đặt cột sóng ở các vị trí i và j 
w = size(Z,1);
i = 10:w+9;
j = 20:w+19;
U(i,j) = U(i,j) + Z;
%i = 20:w+19;
%j = 40:w+39;
%U(i,j) = U(i,j) + Z;
% tạo các ma trận để tính toán 
Ux = zeros(n+1,n+1); 
Uy = zeros(n+1,n+1);
Fx = zeros(n+1,n+1); 
Fy = zeros(n+1,n+1);
Gx = zeros(n+1,n+1);
Gy = zeros(n+1,n+1);
figure(1);
[x, y] = meshgrid(linspace(0,1,n+2),linspace(0,1,n+2));

while 1==1
 
 % redraw the mesh
 subplot(1,2,1);
 surf(x, y, U);
 zlim([-2 5]);
 caxis([-2 5]);
 shading interp; 
 colormap('bone');
 alpha 0.7;

 subplot(1,2,2);
 surf(x, y, U);
 caxis([-2 5])
 view(0,90);
 shading flat;
 colormap('bone');
 alpha 0.7;
 
 drawnow;
 
 %tính giá trị biên
 U(:,1) = U(:,2); 
 U(:,n+2) = U(:,n+1); 
 U(1,:) = U(2,:); 
 U(n+2,:) = U(n+1,:); 
 
 % sóng phản xạ khi tiếp xúc với biên theo x
 F(1,:) = -F(2,:);
 F(n+2,:) = -F(n+1,:);
 
 % sóng phản xạ khi tiếp xúc với biên theo y
 G(:,1) = -G(:,2);
 G(:,n+2) = -G(:,n+1);
 
 
 % bước 1 
 i = 1:n+1;
 j = 1:n+1;
 
 % chiều cao
 Ux(i,j) = (U(i+1,j+1)+U(i,j+1))/2 - dt/(2*dx)*(F(i+1,j+1)-F(i,j+1)); 
 Uy(i,j) = (U(i+1,j+1)+U(i+1,j))/2 - dt/(2*dy)*(G(i+1,j+1)-G(i+1,j));
 
 % hướng di chuyển theo x
 Fx(i,j) = (F(i+1,j+1)+F(i,j+1))/2 - dt/(2*dx)*( F(i+1,j+1).^2./U(i+1,j+1)...
           - F(i,j+1).^2./U(i,j+1) + g/2*U(i+1,j+1).^2 - g/2*U(i,j+1).^2 );
 
 Fy(i,j) = (F(i+1,j+1)+F(i+1,j))/2 - ...
 dt/(2*dy)*( (G(i+1,j+1).*F(i+1,j+1)./U(i+1,j+1)) - (G(i+1,j).*F(i+1,j)./U(i+1,j)) );
 
 % hướng di chuyển theo y
 Gx(i,j) = (G(i+1,j+1)+G(i,j+1))/2 - ...
 dt/(2*dx)*((F(i+1,j+1).*G(i+1,j+1)./U(i+1,j+1)) - ...
 (F(i,j+1).*G(i,j+1)./U(i,j+1)));
 
 Gy(i,j) = (G(i+1,j+1)+G(i+1,j))/2 - ...
 dt/(2*dy)*((G(i+1,j+1).^2./U(i+1,j+1) + g/2*U(i+1,j+1).^2) - ...
 (G(i+1,j).^2./U(i+1,j) + g/2*U(i+1,j).^2));
 
 % bước 2 
 i = 2:n+1;
 j = 2:n+1;
 
 % tính chiều cao 
 U(i,j) = U(i,j) - (dt/dx)*(Fx(i,j-1)-Fx(i-1,j-1)) - (dt/dy)*(Gy(i-1,j)-Gy(i-1,j-1));
 % hướng di chuyển theo x
 F(i,j) = F(i,j) - (dt/dx)*((Fx(i,j-1).^2./Ux(i,j-1) + g/2*Ux(i,j-1).^2) - ...
 (Fx(i-1,j-1).^2./Ux(i-1,j-1) + g/2*Ux(i-1,j-1).^2)) ...
 - (dt/dy)*((Gy(i-1,j).*Fy(i-1,j)./Uy(i-1,j)) - (Gy(i-1,j-1).*Fy(i-1,j-1)./Uy(i-1,j-1)));
 % hướng di chuyển theo y
 G(i,j) = G(i,j) - (dt/dx)*((Fx(i,j-1).*Gx(i,j-1)./Ux(i,j-1)) - ...
 (Fx(i-1,j-1).*Gx(i-1,j-1)./Ux(i-1,j-1))) ...
 - (dt/dy)*((Gy(i-1,j).^2./Uy(i-1,j) + g/2*Uy(i-1,j).^2) - ...
 (Gy(i-1,j-1).^2./Uy(i-1,j-1) + g/2*Uy(i-1,j-1).^2));
 
end