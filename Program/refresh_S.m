function [Y,flag]=refresh_S(t,Y)
%%��ʵ��������Ԥ�����ݲ�ͬʱ��Ҫ���и������ݡ�����ʵ������Ϊnan����Ŀ���Ѿ�������ʱ�������ع滮��־����Ҫ��Ϊһ
% x=xlsread('Stx_information',strcat('A1',':D',num2str(t)));
% Y_t.x=floor(x)';
% y=xlsread('Sty_information',strcat('A1',':D',num2str(t)));
% Y_t.y=ceil(y)';
% Y_t.v=1;
% Y_t.v_d=xlsread('Stvd_information',strcat('A1',':D',num2str(t)));
% Y_t.v_d=Y_t.v_d';
load S_t.mat;
Y_t.x=S_t.x;
Y_t.y=S_t.y;
Y_t.v_d=S_t.v_d;
Y_t.v=1;
flag=zeros(1,length(Y.v_d(:,1)));
for j=1:length(Y.v_d(:,1))
    %��ĳ����������˵��˶�״̬Ԥ��ĺ���ʵ�Ĳ�ͬ����flag��λ�����Ҹ�����ӦԤ����Ϣ
    if((Y.x(j,t)~=Y_t.x(j,t)))%&&~isnan(Y_t.x(j,t)))
        Y.x(j,t)=Y_t.x(j,t);
        flag(j)=1;
    end
    if((Y.y(j,t)~=Y_t.y(j,t)))%&&~isnan(Y_t.y(j,t)))
        Y.y(j,t)=Y_t.y(j,t);
        flag(j)=1;
    end
    if((Y.v_d(j,t)~=Y_t.v_d(j,t)))%&&~isnan(Y_t.v_d(j,t)))
        Y.v_d(j,t)=Y_t.v_d(j,t);
        flag(j)=1;
    end
    if(isnan(Y_t.x(j,t))||isnan(Y_t.y(j,t))||isnan(Y_t.v_d(j,t)))
      flag(j)=0;  
    end
end