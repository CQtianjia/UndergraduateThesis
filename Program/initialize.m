%��ʼ��
function [S,U,B]=initialize(m,n,t)
a=20;
b=20;
%%�������˻��ṹ�壬��ʾ���˻���λ�ã��ٶȣ��ٶȷ���
U.x=40;
U.y=20;
U.v=4;
save('U','U');
%U=U_information(t,m);%���ú����õ����˻���ʼʱ����Ϣ
%%�����������˽ṹ�壬��ʾ�����˵�λ�ã��ٶȣ��ٶȷ���
S.x=[];
S.y=[];
S.v=[];
S.v_d=[];
% for i=1:n
%     S.x(i,t)=floor(unifrnd(10,30));
%     S.y(i,t)=floor(unifrnd(10,30));
%     S.v_d(i,t)=floor(unifrnd(1,8));
S.x(:,1)=[32 36 11 38 38]';
S.y(:,1)=[36 25 22 7 19]';
S.v_d(:,1)=[1 1 7 7 6]';
% S.x(:,1)=[26 13 20 11 20]';
% S.y(:,1)=[19 22 19 27 23]';
% S.v_d(:,1)=[4 7 6 1 4]';
% end
S.v=1;
save('S','S');

%S=S_information(t,n);
%%�����ϰ���ṹ�壬��ʾ�ϰ����λ�ã��ٶȣ��ٶȷ���
B.x=[];
B.y=[];
load Bx.mat;
load By.mat;
B.x=Bx;
B.y=By;

end