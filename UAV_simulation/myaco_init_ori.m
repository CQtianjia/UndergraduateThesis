%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         ��Ⱥ�㷨��������滮����
%
%  ����: ss���������ϳ�ʼλ�ÿ�ѡ��   
%        ee��������ֹλ�õ����е㣻
%  �������Ⱥ�㷨·��         
%  ���ܣ���Ⱥ�㷨Ѱ������·��
%
%                     ������ƣ�۬��  ���ڣ�2013/1/10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [L_best,R_best]=myaco_init_ori(weight,delta)
NC_max=50;                           %��������

%�ж��Ƿ������м����ϵ���Ϊ1000������ǣ�û��һ����������һ���������˻�
count=0;
for i=1:length(weight(1,:))-1
    temp1=find(weight(:,i)==1000);
    temp2=find(weight(i,:)==1000);
    if(length(temp1)==length(weight(:,1))&&length(temp2)==length(weight(1,:)))
        count=count+1;
    end
    
end
flag=0;
for i=1:length(weight(1,:))-1
    temp1=find(weight(:,i)==1000);
    if(length(temp1)==length(weight(:,1))-1)
        flag=flag+1;
    end  
end

m=2;
if(count~=0)
    m=m+count;
end
if(flag~=0)
    m=m+flag-1;
end

%���ϸ���,ͬuav����
%%��ȡweight��ֵȫΪinf�ĸ�����
%%������2ʱ˵������һ����Ϊ����������Ĳ����������ͨ���������ϸ���


%%%

Alpha=5;                          
Beta=5;
Delta=delta; %��Ȩֵ
alph_Jl=1;%Jl���ϵ��
alph_Jt=1;%Jt���ϵ��
Rho=0.2;
Q=1;
n=size(weight,1);%��������Ŀ�����


Eta=1./weight;                       %EtaΪ�������ӣ�������Ϊ����ĵ���
Tau=ones(n,n);                       %TauΪ��Ϣ�ؾ���
NC=1;                                %����������
R=zeros(m,n,NC_max);                 %�������·��
L=inf.*ones(NC_max,1);               %����·�ߵĳ���


while NC<=NC_max                     %ֹͣ����֮һ���ﵽ����������
%%��һ������mֻ���Ϸŵ���Ϊm����ʼ�㴦
    for_visited=ones(1,n);%�����ʽ��
    
    Pk1=zeros(m,n);%�ȱ�Ķ���ά����kֻ���Ϸ��ʶ���Ĵ���
    Pk2=zeros(m,n);%�ȱ�Ķ�ά����Ӧ����ά����kֻ���Ϸ��ʶ���Ķ�
    Pk3=zeros(m,n);%�ȱ��Ȩ��ά����¼�õ㵽��һ�����Ȩ��
   %Ѱ��ÿֻ���ϵ�·�� 
   
   %%���ɶȽ��ɱ�Degree-based tabu list
D_Tabu=zeros(1,n);
%ȷ����һ�����ʵĶ���
%randnum=randperm(n+1);
for_visited(1,n)=0;
D_Tabu(n)=m;
% for i=1:n
%     if(i==randnum(1))
%         D_Tabu(i)=m;
%     end
% end
Randpos=[];%rand position���λ��
Randpos=[Randpos,randperm(n-1)];%randperm(nn)���ɲ�����n_s���������
for i=1:m
%     if(Randpos(i)<randnum(1))
    D_Tabu(Randpos(i))=1;%randposΪ����Ĵ���m�����У�ѡǰm��Ϊ���ϵ���ʼλ��
%     else
%         D_Tabu(Randpos(i)+1)=1;
%     end
    
end
for i=1:n
    if(D_Tabu(i)==0)
        D_Tabu(i)=2;
    end
end

% D_Tabu_Ori=D_Tabu;


for k=1:m
    
    s1=1;%��kֻ���ϵ�ǰ���ʵĸ���
    s2=2;%��kֻ���Ͻ�Ҫ���ʵ�s2��Ŀ��
    
    Pk1(k,s1)=n;%��ʼ������kֻ���ϵ�һ��������1
    Pk2(k,s1)=D_Tabu(n);%��ʼ������kֻ���ϵ�һ������Ķ�
    flag=D_Tabu(Pk1(k,s1));
    while(flag>0)%����ǰ���Ķ�Ϊ0ʱֹͣ����
    %�ҵ�����k����һ�����
    [for_visited_pos]=find(for_visited==1);
    P=[];
    %P=zeros(1,n);
    for i=1:length(for_visited_pos)
                    P(i)=(Tau(Pk1(k,s1),for_visited_pos(i))^Alpha)*(Eta(Pk1(k,s1),for_visited_pos(i))^Beta*(D_Tabu(for_visited_pos(i)))^Delta);
                    %����Ϣ��^��Ϣ��ϵ����*����������^��������ϵ����
                    %P(k)Ϊ��k������Ǳ�ڵ���һ���ڵ�֮���״̬ת�Ƹ��ʾ���
    end
    P=P/(sum(P));            %��һ��
    %������ԭ��ѡȡ��һ����
    Select=find(P==max(P));                   %�ӵڰ˸���ʼ�϶����1�ˣ�Ϊ��ѡ�������
    next_visit=for_visited_pos(Select(1));
    
    D_Tabu(Pk1(k,s1))=D_Tabu(Pk1(k,s1))-1;%��ǰ���ȼ�һ
    for_visited(next_visit)=0;
    Pk1(k,s2)=next_visit;
    Pk2(k,s2)=D_Tabu(next_visit);
    Pk3(k,s1)=weight(Pk1(k,s1),Pk1(k,s2));
    D_Tabu(Pk1(k,s2))=D_Tabu(Pk1(k,s2))-1;%������һ���ڵ�󣬴˽ڵ�ȼ�һ
    s1=s2;
    s2=s2+1;  
    flag=D_Tabu(Pk1(k,s1));
    end
end
 %������Ŀ�궼���ʹ��û���ʹ�õ���������һ��
    Left_forvisit_num=length(find(for_visited==1));
    if (Left_forvisit_num==0)
        %ͨ������õ���ͬ�Ľ��
%         L_temp=Pk1;
%         po1=find(Pk1(1,:)~=0);
%     
%         po2=find(Pk2(2,:)~=0);
%       
%         L_temp(1,po1(end))=Pk1(2,po2(end));
%         L_temp(2,po2(end))=Pk1(1,po1(end));
%         Jl_temp=zeros(length(L_temp(:,1)),1);
%        for i=1:length(L_temp(:,1))
%         for j=1:length(L_temp(1,:))-1
%             if(L_temp(i,j+1)~=0)
%             Jl_temp(i)=Jl_temp(i)+weight(L_temp(i,j),L_temp(i,j+1));
%             end
%         end
%        end
%         J_temp=sum(Jl_temp)+max(Jl_temp);
        
    %%���������·
     
    %���㱾�ε���Ĵ�С��
    Jl=0;%�������
    for i=1:m
        for j=1:n
            Jl=Jl+Pk3(i,j);
        end
    end
    Jt=0;%ʱ�����
    for i=1:m
        Jt=max(Jt,sum(Pk3(i,:)));
    end
    
    J=alph_Jl*Jl+alph_Jt*Jt;
   %�洢���ε���������Լ�����·��ֵ
%    if (J<J_temp) 
   L(NC)=J;
%    else
%        L(NC)=J_temp;
%        Pk1=L_temp;
%    end
%     Left_forvisit_num=length(find(for_visited==1));
%      if (Left_forvisit_num~=0)
%          L(NC)=100;
%      end
     
    for i=1:m
        for j=1:n
            R(i,j,NC)=Pk1(i,j);
        end
    end
    
%     %�жϱ��ε����õ�������·���Ƿ�������������·����Ҫ��
%     S_visited_temp=get_visited(S_visited_flag,R(:,:,NC));
%     flag=S_visited-S_visited_temp;
%     if(all(flag(:)==0))
   NC=NC+1;
   %%������Ϣ��  
   Delta_Tau=zeros(n,n);
    for i=1:m
        for j=1:n-1
            if Pk1(i,j+1)~=0
                Delta_Tau(Pk1(i,j),Pk1(i,j+1))=Delta_Tau(Pk1(i,j),Pk1(i,j+1))+Q/Pk3(i,j);
            %Delta_Tau(Tabu(i,j),Tabu(i,j+1))��iֻ���ϴ�Tabu(i,j)����Tabu(i,j+1)����delta
            else break
            end
        end
    end
    Tau=(1-Rho).*Tau+Delta_Tau;      %���º����Ϣ��
    end
    
    end
    
    
%     else
%         Delta_Tau=zeros(n,n);
%     for i=1:m
%         for j=1:n-1
%             if Pk1(i,j+1)==0
%                 Delta_Tau(Pk1(i,j),Pk1(i,j+1))=Delta_Tau(Pk1(i,j),Pk1(i,j+1))+Q/Pk3(i,j);
%             %Delta_Tau(Tabu(i,j),Tabu(i,j+1))��iֻ���ϴ�Tabu(i,j)����Tabu(i,j+1)����delta
%             else break
%             end
%         end
%     end
%     Tau=(1-Rho).*Tau+Delta_Tau;      %���º����Ϣ��
%     end
   
    
    
    
   
    %%�����ʹ��λ
%     D_Tabu=D_Tabu_Ori;
    


L_best_NC=find(L==min(L));
L_best=L(L_best_NC(1));
R_best=R(:,:,L_best_NC);

end

