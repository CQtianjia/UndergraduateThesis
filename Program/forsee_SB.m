function Y_temp=forsee_SB(Y,t,i)
% %��ȡ�������õ���ʵ����ֵ������ֻ��ǰt��Ϊʵʱ���ݣ�Ϊ������棬���Ը���������񡣣�
% n=5;
% x=xlsread('Stx_inforation','A1:An');
% Y_t.x(:,1)=floor(x);
% y=xlsread('Sty_inforation','A1:An');
% Y_t.y(:,1)=ceil(y);
% Y_t.v(:,1)=xlsread('Stv_inforation','A1:An');
% Y_t.v_d(:,1)=xlsread('Stvd_inforation','A1:An');

Yv=0.7*Y.v;
for j=1:length(Y.v_d(:,1))
%     %��ĳ����������˵��˶�״̬Ԥ��ĺ���ʵ�Ĳ�ͬ����flag��λ�����Ҹ�����ӦԤ����Ϣ
%     if(Y.x(j,t)~=Y_t.x(j,t))
%         Y.x(j,t)=Y_t.x(j,t);
%         flag=1;
%     end
%     if(Y.y(j,t)~=Y_t.y(j,t))
%         Y.y(j,t)=Y_t.y(j,t);
%         flag=1;
%     end
%     if(Y.v_d(j,t)~=Y_t.v_d(j,t))
%         Y.v_d(j,t)=Y_t.v_d(j,t);
%         flag=1;
%     end
    
    %���ݷ����Ԥ�������и���
switch Y.v_d(j,t)
case 1 
    Y.x(j,t+i)=Y.x(j,t)+i*Y.v;Y.y(j,t+i)=Y.y(j,t);
    Y.v_d(j,t+i)=Y.v_d(j,t);
    case 2
         Y.x(j,t+i)=floor(Y.x(j,t)+i*Yv);
         Y.y(j,t+i)=floor(Y.y(j,t)-i*Yv);
         Y.v_d(j,t+i)=Y.v_d(j,t);
          case 3
              Y.y(j,t+i)=Y.y(j,t)-i*Y.v;
              Y.x(j,t+i)=Y.x(j,t);
              Y.v_d(j,t+i)=Y.v_d(j,t);
              case 4
                   Y.y(j,t+i)=floor(Y.y(j,t)-i*Yv);
                   Y.x(j,t+i)=floor(Y.x(j,t)-i*Yv);
                   Y.v_d(j,t+i)=Y.v_d(j,t);
                   case 5
                       Y.x(j,t+i)=Y.x(j,t)-i*Y.v;
                       Y.y(j,t+i)=Y.y(j,t);
                       Y.v_d(j,t+i)=Y.v_d(j,t);
                       case 6
                           Y.y(j,t+i)=floor(Y.y(j,t)+i*Yv);
                           Y.x(j,t+i)=floor(Y.x(j,t)-i*Yv);
                           Y.v_d(j,t+i)=Y.v_d(j,t);
                           case 7
                               Y.y(j,t+i)=Y.y(j,t)+i*Y.v;
                               Y.x(j,t+i)=Y.x(j,t);
                               Y.v_d(j,t+i)=Y.v_d(j,t);
                               case 8
                                   Y.y(j,t+i)=floor(Y.y(j,t)+i*Yv);
                                   Y.x(j,t+i)=floor(Y.x(j,t)+i*Yv);
                                   Y.v_d(j,t+i)=Y.v_d(j,t);
end

Y_temp=Y;        

end
    

end