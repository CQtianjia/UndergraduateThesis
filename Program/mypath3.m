function [L_return,L_return_t]=mypath3(L_go_t,S,B)
%m��ʾ���Ͻṹ������˸�����,����ͬ���������
m.x=zeros(1,8);
m.y=zeros(1,8);
n=length(S.x(:,1));
a=40;
b=40;
c=1;
grid=form_grid(a,b,c);
place1=grid;
t=L_go_t;
t_ori=t;
r_cost=S.v;%r_costΪ��Ϊ���ϰ�����ȴ���ʱ��������ʻ�ľ���
endflag=0;                            %��ֹ��־��������Ŀ���ʱΪ1��
Route=zeros(1,8);%��¼ÿ�ε����������·������
Tabu=zeros(n,n);                     %�洢����¼·��������
Tabu_t=zeros(n,n);
NC=1;      %����������
L_return=inf*ones(n+1,n+1);          %�������·�ߵĳ���
L_return_t=inf*ones(n+1,n+1);
for i=1:length(S.x(:,1))
        for j=1:length(S.x(:,1))
            if (L_go_t(n+1,i)~=1000&&L_go_t(n+1,j)~=1000)
            ad_cost=0;
            if((i~=j)&&(t(i,j)~=inf))
                x=S.x(j,t(i,j));
                y=S.y(j,t(i,j));
                out_flag=judge_flag(x,y);
                if(out_flag(1))
                L_return(i,j)=b-S.x(j,t(i,j));
                L_return_t(i,j)=t(i,j)+L_return(i,j)/S.v;
                S_temp=S_information(L_return_t(i,j));
                B_temp=B;
                %test
                %B_temp=B_information(L_return_t(i,j));
                Route.x=zeros(1,L_return(i,j)/S.v);
                for temp1=1:L_return(i,j)/S.v
                    Route.x(temp1)=S.x(j,t(i,j))+temp1;
                end
                Route.y=S.y(j,t(i,j))*ones(1,L_return(i,j)/S.v);
                S_temp.x(j,:)=[];S_temp.y(j,:)=[];S_temp.v_d(j,:)=[];
               for t_temp=1:L_return(i,j)/S.v
                    place=refresh_place(grid,B_temp,t(i,j)+t_temp);
                   
                    place=refresh_place(place,S_temp,t(i,j)+t_temp);
                    place1=test_route(place1,Route.x(t_temp),Route.y(t_temp));
                    if(place(Route.x(t_temp),Route.y(t_temp))==0)
                        ad_cost=ad_cost+r_cost;%%additional cost
                    end
                   
               end
                 L_return(i,j)=L_return(i,j)+ad_cost;
                    L_return_t(i,j)=L_return_t(i,j)+ad_cost/S.v;
                
            end
        end
            Route.x=[];
            Route.y=[];
        end
        end
      
        
end
  for i=1:n+1
            L_return(n+1,i)=0;        
            L_return_t(n+1,i)=0;
            L_return(i,n+1)=0;        
            L_return_t(i,n+1)=0;

  end



end