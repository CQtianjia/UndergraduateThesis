function [B]=B_information(t)%B_informationȷ���ı���ÿһʱ���ϰ����λ����Ϣ
x=xlsread('Bx_information',strcat('A1',':C',num2str(t)));
B.x=floor(x)';
y=xlsread('By_information',strcat('A1',':C',num2str(t)));
B.y=ceil(y)';
% B.v=xlsread('Bv_information','A1:S4');
% B.v_d=xlsread('Bvd_information','A1:S4');
end