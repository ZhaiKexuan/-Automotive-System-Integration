
function plotTruss(xy , L , textOn, deflection)
if nargin == 3
    c = 'black'; ls = '-' ; 
elseif nargin == 4
    xy = xy + deflection.*10;
    c = 'red'; ls = '--' ;
else
    error('wrong input variable number');   
end
for i=1:length(L)
    temp1=xy(L(i,1),:);
    temp2=xy(L(i,2),:);
    x=[temp1(1),temp2(1)];%The abscissa of the two points to be connected
    y=[temp1(2),temp2(2)];%The coordinates of the two points to be connected
    line(x,y, 'Color' , c , 'LineStyle' ,ls );
    hold on;
end
axis equal;
axis([-500 4500 -500 1750]);
grid on;
xlabel('X-position[mm]','FontName','Times New Roman','FontSize',14);
ylabel('Y-position[mm]','FontName','Times New Roman','FontSize',14);
if textOn== true
    dx=75; dy=100;% displacement so the text does not overlay the data points
    text([0 1000 2000 3000 4000 0 1200 2900 4000 1000 1500 3400 2500]+dx,[0 0 0 0 0 250 350 350 250 500 1200 1200 1200]+dy,{'j_1 ','j_2 ','j_3 ','j_4 ','j_5 ','j_6 ','j_7 ','j_8 ','j_9 ','j_1_0 ','j_1_1 ','j_1_2 ','j_1_3 '},'HorizontalAlignment','left');
end
end



