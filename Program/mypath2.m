function [L_return,L_return_t]=mypath2(t0,L_go_t,S,B)

%m��ʾ���Ͻṹ������˸�����,����ͬ���������
m.x=zeros(1,8);
m.y=zeros(1,8);
n=length(S.x(:,1));
a=20;
b=20;
c=1;
grid=form_grid(a,b,c);
t=L_go_t;
t_ori=t;
r_cost=S.v;%r_costΪ��Ϊ���ϰ�����ȴ���ʱ��������ʻ�ľ���
endflag=0;                            %��ֹ��־��������Ŀ���ʱΪ1��
Route=zeros(1,8);%��¼ÿ�ε����������·������
Tabu=zeros(n,n);                     %�洢����¼·��������
Tabu_t=zeros(n,n);
NC=1;      %����������
L_return=inf.*ones(n,n);          %�������·�ߵĳ���
L_return_t=inf.*ones(n,n);
%����S����λ��
% S=refresh_S(t0,S);

%��������S�õ�t(i,j)ʱ��֮��20s��Ԥ����Ϣ,S_temp������ʱ���汾�ε�Ԥ����Ϣ

%while NC<=NC_max                     %ֹͣ����֮һ���ﵽ����������
    for i=1:length(S.x(:,1))
        for j=1:length(S.x(:,1))
            if(i~=j) 
                S_temp=S_information(t(i,j));
                place=refresh_place(grid,B,t(i,j));
                place=refresh_place(place,S_temp,t(i,j));
            for p=1:8
            m.x(p)=S_temp.x(i,t(i,j));
            m.y(p)=S_temp.x(i,t(i,j));
            end
            while(endflag==0)
                
                S_temp=forsee_SB(S_temp,t(i,j),1);
                t(i,j)=t(i,j)+1;
               m.x(1)=m.x(1)+S.v;
                m.x(2)=m.x(2)+S.v;m.y(2)=m.y(2)-S.v;
                m.y(3)=m.y(3)-S.v;
                m.x(4)=m.x(4)-S.v;m.y(4)=m.y(4)-S.v;
                m.x(5)=m.x(5)-S.v;
                m.x(6)=m.x(6)-S.v;m.y(6)=m.y(6)+S.v;
                m.y(7)=m.y(7)+S.v;
                m.x(8)=m.x(8)+S.v;m.y(8)=m.y(8)+S.v;
                out_flag=judge_flag(m.x,m.y);%�ж��Ƿ����
                for p=1:8
                    if (out_flag(p))
                   
                    delta_route=b-m.x(p);
                    Route(p)=S.v+delta_route;
                    if (place(m.x(p),m.y(p))==1)
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
                if(abs(b-m.x(1))<S.v)
                endflag=1;
                end
            %����i��j��ʱ�����
            Tabu(i,j)=(t(i,j)-t_ori(i,j))*S.v;
            %������ʱ�䳬��20s��������λ�ó����߽�ʱ����Ϊinf��Ϊ���ɴ�
            if(S_temp.y(j,t(i,j))>20||S_temp.y(j,t(i,j))<0||t(i,j)-t_ori(i,j)>20)
               Tabu(i,j)=inf; 
            end
            end
            Tabu_t(i,j)=t(i,j);
            t=t_ori;
            endflag=0;
        end
        end
    end
    
    
   for i=1:n
        for j=1:n
            if(Tabu(i,j)<L_return(i,j))
                L_return(i,j)=Tabu(i,j);
                L_return_t(i,j)=Tabu_t(i,j);
            end
        end
   end
 
%end
end
