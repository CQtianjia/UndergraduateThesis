clc;
% clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%1.��ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% m=input('���������˻��ĸ���');
% n=input('���������Ŀ��ĸ���');
t=1;
m=2;
n=5;
 [S,U,B]=initialize(m,n,t);
dt=40;
%%��ʼ��ʱ�����

S_visited=[];
S_visited_flag=zeros(1,n);
% %%%test set%%%
% U.x=[20,20];
% U.y=[1;2];
% U.v=3;
% S.x=[1;2;3];
% S.y=[10;15;15];
% S.v=1;
% S.v_d=[1;2;4];
% B.x=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1;
%     1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1;
%     1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
% B.y=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1;
%     1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
%     1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1];
% %%%%


% %%%%%%%%%%%%%%%%%
%%�˴���Ϊ�˷������ÿ�ζ���ʵ��Ŀ��̬�ƽ�����á���Ҫ��Ƴ������ڴ˸���S_t
%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:dt
    S=forsee_SB(S,t,i);
end
write_S(S);
load S_t.mat;
for i=1:length(S.x(:,1))
    
    for j=1:length((S.x(1,:)))
        out_flag=judge_flag(S.x(i,j),S.y(i,j));
        if(out_flag(1)==0)
            S_t.x(i,j)=nan;
            S_t.y(i,j)=nan;
            S_t.v_d(i,j)=nan;
        else
            S_t.x(i,j)=S.x(i,j);
            S_t.y(i,j)=S.y(i,j);
            S_t.v_d(i,j)=S.v_d(i,j);
        end
        
    end
end
S_t.v_d(3,3)=4;

for i=1:dt
    S_t=forsee_SB(S_t,3,i);
end
S_t.v_d(2,5)=5;
for i=1:dt
    S_t=forsee_SB(S_t,5,i);
end
S_t.v_d(1,7)=3;
for i=1:dt
    S_t=forsee_SB(S_t,7,i);
end
save('S_t','S_t');



% %%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%2.��ȡԤ����Ϣ������SԤ��ṹ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�����µ��������������л�ȡ��Ԥ��
[S,flag]=refresh_S(t,S);
for i=1:dt
    S=forsee_SB(S,t,i);
end
write_S(S);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%3.�õ���ʼ��֮��ĳ���Ȩ����Ϣ�����ʼ����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��ȡt=1ʱ�̵ĳ�ʼ��Ϣ�����ʼȨ�ؾ���
[weight,L_t]=myweight(U,S,B,t);



%%��ó�ʼ����滮��
[L_best,R_best]=myaco_init(weight);
%%������ÿ����ʱ��Ӧ��ʱ��
[R_rt]=reach_t(R_best,L_t);
value=max(max(R_rt));
for i=1:value-t
          S=forsee_SB(S,t,i);
end
[x,y]=DrawSimpleRoute(R_best,S,U,R_rt);
% %test set
% L_best=80;
% R_best(:,:,1)=[3 2 0;3 1 0];
% %%
track(S,U,R_rt,R_best)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%4.��ʱ���ƽ��Ĺ����У���S���и��£����ж��Ƿ�����ع滮ֱ���������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����ÿ����Ĳ������ݣ��Եõ������������������
endflag=0;
while(endflag~=1)
  t=t+1;
  %%���ֶ�δ��20sʱ�����Ԥ��
  S=forsee_SB(S,t,dt);
  write_S(S);
  [S,flag]=refresh_S(t,S);
    %%��ǰʱ�����ĳ��Ŀ���Ѿ�������ɣ�����º������Ϊnan��������flag��¼�Ѿ�������ɵ�Ŀ��
  %[S,S_visited_flag]=get_visited_flag(S,t);
  [S,S_visited_flag]=get_visited_flag(t,S,R_rt,R_best);
  %%��ȡ֮ǰ�õ�������·���е��Ѿ�������ɵĲ���
  S_visited=get_visited(S_visited_flag,R_best(:,:,1));
  %%flag��ʾ���쳣Ӧ�ò������Ѿ����ʹ���Ŀ��
%   if(t~=2)
%   flag=flag-S_visited_flag;
%   end
%%test set
%   flag=1;
%   S_visited=[1 2 0;1 3 0];
%   S_visited_flag=[1 1 1];
  %%%
  flag2=find(R_rt(:)==t);
  %%���flag��ȫΪ0ʱ������Ҫ�ع滮����Ҫ���1.��δ��20������Ԥ�⣬2.�õ��µ�Ȩ�أ�3.�ع滮
  if (~all(flag(:)==0)||~isempty(flag2))
      for i=1:20
          S=forsee_SB(S,t,i);
      end
      write_S(S);
  [weight,L_t]=myweight(U,S,B,t);%�õ�Ԥ��ʱ���Ȩ��
  [L_best,R_best]=myaco(weight,S_visited,S_visited_flag)%flag��־Ϊ1ʱ�����������·��䡣
  
  [R_rt]=reach_t(R_best,L_t);
value=max(max(R_rt));
for i=1:value-t
          S=forsee_SB(S,t,i);
end
[x,y]=DrawSimpleRoute(R_best,S,U,R_rt);
  end
  endflag=all(S_visited_flag(:)==1);
  
end

