function [U]=U_information(t)%U_information��ʼʱֻ��U��t=0ʱ��λ����Ϣ��������Ϣ��֮�����ڱ���ʱʱ״̬

U.x(:,1)=xlsread('Ux_information','A1:A3');
U.y(:,1)=xlsread('Uy_information','A1:A3');
U.v=3;
%U.v_d(:,1)=xlsread('Uvd_inforation','A1:Am');
end