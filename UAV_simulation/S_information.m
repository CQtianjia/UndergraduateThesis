function [S]=S_information(t)%S_information��ʼ��t=0ʱ���е�������˵�λ���ٶ���Ϣ(���������ĵ�һ��)
% 
% x=xlsread('Sx_information',strcat('A1',':D',num2str(t)));
% S.x=floor(x)';%%S.x/y/v_dΪn*��t/2�������б�ʾ��i��Ŀ�꣬�б�ʾ��j��ʱ���,����ֻ��ȡ��һ�е����ݣ�t=0ʱ��
% y=xlsread('Sy_information',strcat('A1',':D',num2str(t)));
% S.y=ceil(y)';
% S.v=1;%%S.v��ʾÿ��Ŀ����ٶȣ����٣�
% v_d=xlsread('Svd_information',strcat('A1',':D',num2str(t)));%strcat('A1',':C',num2str(t))');
% S.v_d=v_d';
% end
if((t~=inf)&&(t~=0))
    load S.mat;
S.x=Y.x(:,1:t);
S.y=Y.y(:,1:t);
S.v_d=Y.v_d(:,1:t);
S.v=Y.v;
end
end