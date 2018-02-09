%%
clear all;
R0=30;
x0=0;
y0=0;
phi0=pi/6;
%��ʱ����ʼԲ
% DrawCircle(R0,x0+R0*cos(phi0+pi/2),y0+R0*sin(phi0+pi/2),0,2*pi);
hold on;
% %˳ʱ����ʼԲ
% DrawCircle(R0,x0+R0*cos(phi0-pi/2),y0+R0*sin(phi0-pi/2),0,2*pi);
% % hold on;
quiver(x0,y0,R0*cos(phi0),R0*sin(phi0));
%%
R1=30;
x1=400;
y1=400;
phi1=pi/2;
%��ʱ����ֹԲ
% DrawCircle(R1,x1+R1*cos(phi1+pi/2),y1+R1*sin(phi1+pi/2),0,2*pi);
% hold on;
%˳ʱ����ֹԲ
% DrawCircle(R1,x1+R1*cos(phi1-pi/2),y1+R1*sin(phi1-pi/2),0,2*pi);
hold on;
quiver(x1,y1,R1*cos(phi1),R1*sin(phi1));
%%
%Բ�ľ�
L1=sqrt(((x0+R0*cos(phi0+pi/2))-(x1+R1*cos(phi1+pi/2)))^2+...
        ((y0+R0*sin(phi0+pi/2))-(y1+R1*sin(phi1+pi/2)))^2);
L2=sqrt(((x0+R0*cos(phi0+pi/2))-(x1+R1*cos(phi1-pi/2)))^2+...
        ((y0+R0*sin(phi0+pi/2))-(y1+R1*sin(phi1-pi/2)))^2);
L3=sqrt(((x0+R0*cos(phi0-pi/2))-(x1+R1*cos(phi1+pi/2)))^2+...
        ((y0+R0*sin(phi0-pi/2))-(y1+R1*sin(phi1+pi/2)))^2);
L4=sqrt(((x0+R0*cos(phi0-pi/2))-(x1+R1*cos(phi1-pi/2)))^2+...
        ((y0+R0*sin(phi0-pi/2))-(y1+R1*sin(phi1-pi/2)))^2);
%%
%��ʱ����ʼԲ+��ʱ����ֹԲ
Theta=atan(((y0+R0*sin(phi0+pi/2))-(y1+R1*sin(phi1+pi/2)))/...
           ((x0+R0*cos(phi0+pi/2))-(x1+R1*cos(phi1+pi/2))));
Alpha=asin((R0-R1)/L1);
DrawCircle(R0,x0+R0*cos(phi0+pi/2),y0+R0*sin(phi0+pi/2),phi0-pi/2,Theta+Alpha+3*pi/2);
hold on;
%��ʼԲ�뿪��
SF=[x0+R0*cos(phi0+pi/2)+R0*cos(Theta+Alpha-pi/2)...
    y0+R0*sin(phi0+pi/2)+R0*sin(Theta+Alpha-pi/2)];
%��ֹԲ�����
FS=[x1+R1*cos(phi1+pi/2)+R1*cos(Theta+Alpha-pi/2)...
    y1+R1*sin(phi1+pi/2)+R1*sin(Theta+Alpha-pi/2)];
DrawCircle(R1,x1+R1*cos(phi1+pi/2),y1+R1*sin(phi1+pi/2),Theta+Alpha-pi/2+2*pi,2*pi);
hold on;
plot([SF(1) FS(1)],[SF(2) FS(2)],'b-','linewidth',1);
axis equal;
Length(1)=sqrt((SF(1)-FS(1))^2+(SF(2)-FS(2))^2)+ArcLen(R0,phi0-pi/2,Theta+Alpha+3*pi/2)+ArcLen(R1,Theta+Alpha-pi/2+2*pi,2*pi);
 %%
%��ʱ����ʼԲ+˳ʱ����ֹԲ
Theta=atan(((y0+R0*sin(phi0+pi/2))-(y1+R1*sin(phi1-pi/2)))/...
           ((x0+R0*cos(phi0+pi/2))-(x1+R1*cos(phi1-pi/2))));
Alpha=acos((R0+R1)/L2);
%��ʼԲ�뿪��
SF=[x0+R0*cos(phi0+pi/2)+R0*cos(Theta-Alpha)...
    y0+R0*sin(phi0+pi/2)+R0*sin(Theta-Alpha)];
DrawCircle(R0,x0+R0*cos(phi0+pi/2),y0+R0*sin(phi0+pi/2),phi0-pi/2,Theta-Alpha);
hold on;
%��ֹԲ�����
FS=[x1+R1*cos(phi1-pi/2)+R1*cos(Theta-Alpha+pi)...
    y1+R1*sin(phi1-pi/2)+R1*sin(Theta-Alpha+pi)];
DrawCircle(R1,x1+R1*cos(phi1-pi/2),y1+R1*sin(phi1-pi/2),phi1+pi/2,Theta-Alpha+pi);
hold on;
plot([SF(1) FS(1)],[SF(2) FS(2)],'b-','linewidth',1);
axis equal;
Length(2)=sqrt((SF(1)-FS(1))^2+(SF(2)-FS(2))^2)+ArcLen(R0,phi0-pi/2,Theta-Alpha)+ArcLen(R1,phi1+pi/2,Theta-Alpha+pi);
%%
%˳ʱ����ʼԲ+��ʱ����ֹԲ
Theta=atan(((y0+R0*sin(phi0-pi/2))-(y1+R1*sin(phi1+pi/2)))/...
           ((x0+R0*cos(phi0-pi/2))-(x1+R1*cos(phi1+pi/2))));
Alpha=asin((R0+R1)/L1);
DrawCircle(R0,x0+R0*cos(phi0-pi/2),y0+R0*sin(phi0-pi/2),Theta-Alpha+pi/2,phi0+pi/2);
hold on;
%��ʼԲ�뿪��
SF=[x0+R0*cos(phi0-pi/2)+R0*cos(Theta-Alpha+pi/2)...
    y0+R0*sin(phi0-pi/2)+R0*sin(Theta-Alpha+pi/2)];
%��ֹԲ�����
FS=[x1+R1*cos(phi1+pi/2)+R1*cos(Theta-Alpha-pi/2)...
    y1+R1*sin(phi1+pi/2)+R1*sin(Theta-Alpha-pi/2)];
DrawCircle(R1,x1+R1*cos(phi1+pi/2),y1+R1*sin(phi1+pi/2),Theta-Alpha-pi/2+2*pi,2*pi);
hold on;
plot([SF(1) FS(1)],[SF(2) FS(2)],'b-','linewidth',1);
axis equal;
Length(3)=sqrt((SF(1)-FS(1))^2+(SF(2)-FS(2))^2)+ArcLen(R0,Theta-Alpha+pi/2,phi0+pi/2)+ArcLen(R1,Theta-Alpha-pi/2+2*pi,2*pi);
%% 
%˳ʱ����ʼԲ+˳ʱ����ֹԲ
Theta=atan(((y0+R0*sin(phi0-pi/2))-(y1+R1*sin(phi1-pi/2)))/...
           ((x0+R0*cos(phi0-pi/2))-(x1+R1*cos(phi1-pi/2))));
Alpha=asin((R0-R1)/L1);
DrawCircle(R0,x0+R0*cos(phi0-pi/2),y0+R0*sin(phi0-pi/2),Theta-Alpha+pi/2,phi0+pi/2);
hold on;
%��ʼԲ�뿪��
SF=[x0+R0*cos(phi0-pi/2)+R0*cos(Theta-Alpha+pi/2)...
    y0+R0*sin(phi0-pi/2)+R0*sin(Theta-Alpha+pi/2)];
%��ֹԲ�����
FS=[x1+R1*cos(phi1-pi/2)+R1*cos(Theta-Alpha+pi/2)...
    y1+R1*sin(phi1-pi/2)+R1*sin(Theta-Alpha+pi/2)];
DrawCircle(R1,x1+R1*cos(phi1-pi/2),y1+R1*sin(phi1-pi/2),phi1+pi/2,Theta-Alpha+pi/2);
hold on;
plot([SF(1) FS(1)],[SF(2) FS(2)],'b-','linewidth',1);
axis equal;
Length(4)=sqrt((SF(1)-FS(1))^2+(SF(2)-FS(2))^2)+ArcLen(R0,Theta-Alpha+pi/2,phi0+pi/2)+ArcLen(R1,phi1+pi/2,Theta-Alpha+pi/2);