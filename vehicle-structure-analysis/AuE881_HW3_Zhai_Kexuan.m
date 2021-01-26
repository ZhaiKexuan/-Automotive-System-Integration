clear; clc;
%===============================%
%Task 1

%Set up
xy=[0, 0 ;1000, 0; 2000, 0; 3000, 0; 4000, 0; 0, 250; 1200, 350; 2900, 350; 4000, 250; 1000, 500; 1500, 1200; 3400, 1200; 2500, 1200];
L=[1,2; 1,6; 1,7; 2,3; 2,7; 3,4; 3,7; 3,8; 4,5; 4,8; 5,8; 5,9; 6,7; 6,10; 7,10; 7,11; 8,9; 8,12; 8,13; 9,12; 10,11; 11,13; 12,13];

plotTruss(xy,L,true);
title('Undeflected frame','FontName','Times New Roman','FontWeight','Bold','FontSize',10);

%===============================%
%Task 2
%Plot undeflected frame
plotTruss(xy,L,true);
hold on;
forceJ=[2,1,1; 0,0,0; -1,0,-9800; 0,0,0; 2,1,1; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0];
[Jforce,Mforce,Jdispl,Mdispl] = solveTruss( xy , L , forceJ);
%Plot deflected frame
plotTruss(xy,L,false,Jdispl);
text(xy(3,1)+Jdispl(3,1)*10,xy(3,2)+Jdispl(3,2)*10,strcat('defl=',num2str(Jdispl(3,2)),'mm'));
ylim([-1000,1600]);
title('Deflected frame(in red)under 1000kg load at joint 3','FontName','Times New Roman','FontWeight','Bold','FontSize',10);
hold off;

%================================%
%Task 3
xy=[0, 0 ;1000, 0; 2000, 0; 3000, 0; 4000, 0; 0, 250; 1200, 350; 2900, 350; 4000, 250; 1000, 500; 1500, 1200; 3400, 1200; 2500, 1200];
L0=[1,2; 1,6; 1,7; 2,3; 2,7; 3,4; 3,7; 3,8; 4,5; 4,8; 5,8; 5,9; 6,7; 6,10; 7,10; 7,11; 8,9; 8,12; 8,13; 9,12; 10,11; 11,13; 12,13];
P=[3,11; 3,13; 7,8; 7,13; 8,11];% define a matrix that contain five different situations;
forceJ=[2,1,1; 0,0,0; -1,0,-9800; 0,0,0; 2,1,1; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0];
for k= 1:5
    L=[P(k,:); L0]; % Define L.
    figure(k)
    plotTruss(xy,L,true);
    hold on;
    [~,~,Jdispl,~] = solveTruss( xy , L , forceJ);% Jforce,Mforce,Mdispl are unused.
    [Jdispl_max, Jdispl_idx] = max(sqrt(sum(Jdispl.^2,2))); %Obtain the value of max deflection and its position.
    plotTruss(xy,L,false,Jdispl);
    text(xy(Jdispl_idx,1)+10*Jdispl(Jdispl_idx,1)+50, xy(Jdispl_idx,2)+10*Jdispl(Jdispl_idx,2)-30,strcat('defl= ',num2str(Jdispl_max,'%5.2f'),'mm'));
    ylim([-1000,1600]);
    title('Deflected frame(in red)under 1000kg load at joint 3','FontName','Times New Roman','FontWeight','Bold','FontSize',10);
    hold off
end
%================================%
%Task 4.2
xy=[0, 0 ;1000, 0; 2000, 0; 3000, 0; 4000, 0; 0, 250; 1200, 350; 2900, 350; 4000, 250; 1000, 500; 1500, 1200; 3400, 1200; 2500, 1200];
L=[1,2; 1,6; 1,7; 2,3; 2,7; 3,4; 3,7; 3,8; 4,5; 4,8; 5,8; 5,9; 6,7; 6,10; 7,10; 7,11; 8,9; 8,12; 8,13; 9,12; 10,11; 11,13; 12,13];
forceJ=[2,1,1; 0,0,0; -1,0,-9800; 0,0,0; 2,1,1; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0];
[~,~,Jdispl,~] = solveTruss( xy , L , forceJ);
Dist1 = zeros(1, 23);
Dist2 = zeros(1, 23);

for i=1:length(L)
    temp1=xy(L(i,1),:);
    temp2=xy(L(i,2),:);
    Dist1(1,i) = abs( norm(temp2-temp1) ); % The length of undeflected member.
end

for i=1:length(L)
    temp3=xy(L(i,1),:)+ Jdispl(L(i,1),:);
    temp4=xy(L(i,2),:)+ Jdispl(L(i,2),:);
    Dist2(1,i) = abs( norm(temp4-temp3) ); % The length of deflected member.
end
Dist= Dist2 - Dist1; % a matrix include all length differences.