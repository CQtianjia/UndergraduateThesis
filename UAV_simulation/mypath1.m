function [L_best,L_go_t]=mypath1(t,S,B,U)%%����A*�㷨���
% function [Shortest_Route,Shortest_Length]=myaco(s,e,weight,flag0)
NC_max=50;                           %��������
%m��ʾ���Ͻṹ������˸�����,����ͬ���������
m.x=zeros(1,8);
m.y=zeros(1,8);
n=length(S.x(:,1));
a=40;
b=40;
c=1;
dt=20;
%����S����λ��
%S=refresh_S(t,S);
S_temp=S;
Uv=floor(0.7*U.v);%��б����ʱ���벻����U.v
grid=form_grid(a,b,c);
t_ori=t;
r_cost=U.v;%r_costΪ��Ϊ���ϰ�����ȴ���ʱ��������ʻ�ľ���
endflag=0;                            %��ֹ��־��������Ŀ���ʱΪ1��
Route=zeros(1,8);%��¼ÿ�ε����������·������
Tabu=zeros(n,n);                     %�洢����¼·��������
Tabu_t=zeros(n,n);
NC=1;      %����������
out_flag=ones(1,8);%�ж��Ƿ񳬳����Χ�ı߽磬1Ϊû��
L_best=inf.*ones(n,n);          %�������·�ߵĳ���
L_go_t=inf.*ones(n,n);
%while NC<=NC_max                     %ֹͣ����֮һ���ﵽ����������
    for i=1:length(S.x(:,1))
        for j=1:length(S.x(:,1))
           if(i~=j)
%                for t_temp=1:20
%                     S_temp=forsee_SB(S_temp,t,t_temp);
% 
%                end
            for p=1:8
            m.x(p)=b;
            m.y(p)=S.y(i,t);
            end
            while(endflag==0)
                S_temp=forsee_SB(S_temp,t,1);
                t=t+1;
                m.x(1)=m.x(1)+U.v;
                m.x(2)=m.x(2)+Uv;m.y(2)=m.y(2)-Uv;
                m.y(3)=m.y(3)-U.v;
                m.x(4)=m.x(4)-Uv;m.y(4)=m.y(4)-Uv;
                m.x(5)=m.x(5)-U.v;
                m.x(6)=m.x(6)-Uv;m.y(6)=m.y(6)+Uv;
                m.y(7)=m.y(7)+U.v;
                m.x(8)=m.x(8)+Uv;m.y(8)=m.y(8)+Uv;
                out_flag=judge_flag(m.x,m.y);%�ж��Ƿ����
                for p=1:8
                    if (out_flag(p))
                    place=refresh_place(grid,B,t);
                    delta_route=min(abs(m.x(p)-S_temp.x(j,t))+abs(m.y(p)-S_temp.y(j,t)),1.5*abs(m.x(p)-S_temp.x(j,t))+abs(abs(m.x(p)-S_temp.x(j,t))-abs(m.y(p)-S_temp.y(j,t))));
                    Route(p)=U.v+delta_route;
%                     if(mod(p,2)==0)
%                         Route(p)=Route(p)+0.5*U.v;
%                     end
                    if (place(m.x(p),m.y(p))==0)
                        Route(p)=Route(p)+r_cost;
                    end
                    else%%����Ļ�ʹ��·������Ϊ����
                        Route(p)=inf;
                    end
                 
                end
                r_decision=find(Route==min(Route));%r_decision��ʾ��С·���ķ���
                %�������ƶ�����С·�������Ӧ�ĵ� 
                for p=1:8
            m.x(p)=m.x(r_decision(1));
            m.y(p)=m.y(r_decision(1));
                end
                %������Ŀ��ʱ��ʹ��endflag��λ
                if(abs(m.x(1)-S_temp.x(j,t))<(U.v-S.v)&&abs(m.y(1)-S_temp.y(j,t))<(U.v-S.v))
                endflag=1;
                end
            %����i��j��ʱ�����
            Tabu(i,j)=(t-t_ori)*U.v;
            %������ʱ�䳬��20s��������λ�ó����߽�ʱ����Ϊinf��Ϊ���ɴ�
            if((t-t_ori>dt)||S_temp.x(j,t)>a||S_temp.y(j,t)>a||S_temp.x(j,t)<0||S_temp.y(j,t)<0)
               Tabu(i,j)=inf; 
               endflag=1;
            end
            end
            write_S(S_temp);
            Tabu_t(i,j)=t;
            t=t_ori;
            endflag=0;
           end
        end
    end
    
   for i=1:n
        for j=1:n
            if(Tabu(i,j)<L_best(i,j))
                L_best(i,j)=Tabu(i,j);
                L_go_t(i,j)=Tabu_t(i,j);
            end
        end
   end
 
%end
end