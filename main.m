clc;
clear all;
close all;
warning off;
ff=1;
popsize=8;
maxgen=5;
fobj = @(x)costF(x);
lb = 1;
ub = 40;
dim = length(lb);
Vmax=ones(1,dim).*(ub-lb).*0.15;
noP=popsize;
w=0.8;
c1=1.5;
c2=1.5;
www=[];
vel=zeros(noP,dim);
pBestScore=zeros(noP);
pBest=zeros(noP,dim);
Best_pos=zeros(1,dim);
curve=zeros(1,maxgen);
pos = repmat(lb,popsize,1)+rand(popsize,dim).* repmat((ub-lb),popsize,1);
for i=1:noP
    pBestScore(i)=inf;
end
Best_score=-inf;
for l=1:maxgen

    for i=1:size(pos,1)
        Flag4ub=pos(i,:)>ub;
        Flag4lb=pos(i,:)<lb;
        pos(i,:)=(pos(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
    end

    for i=1:size(pos,1)
        fitness= fobj(pos(i,:));
        if (fitness > pBestScore(i))
            pBestScore(i) = fitness;
            pBest(i,:) = pos(i,:);
        end
        if(Best_score<fitness)
            Best_score=fitness;
            Best_pos=pos(i,:);
        end

    end
    for i=1:size(pos,1)
        for j=1:size(pos,2)
            vel(i,j)=w*vel(i,j)+c1*rand()*(pBest(i,j)-pos(i,j))+c2*rand()*(Best_pos(j)-pos(i,j));

            if(vel(i,j)>Vmax(j))
                vel(i,j)=Vmax(j);
            end
            if(vel(i,j)<-Vmax(j))
                vel(i,j)=-Vmax(j);
            end
            pos(i,j)=pos(i,j)+vel(i,j);
        end
    end
    curve(l)=Best_score;
    disp(['迭代次数', num2str(l), ' ,最优目标函数值', num2str(Best_score)])
    disp(['迭代次数',num2str(l),'最优值',num2str(Best_pos(1))])

end
figure
plot(curve,'r-','linewidth',2)
xlabel('进化代数')
ylabel('目标函数值')


set_param('test', 'StopTime', num2str(ff));

set_param('test/R', 'Resistance',num2str(Best_pos(1)));
ww=sim('test');
tt=ww.ScopeData1.time  ;
P=ww.ScopeData1.signals.values  ;
V=ww.ScopeData2.signals.values  ;
I=ww.ScopeData3.signals.values  ;
figure;
plot(tt,P,'Color','r','LineWidth',2)
xlabel('时间/s');
ylabel('功率/W')
figure;
plot(tt,V,'Color','g','LineWidth',2)
xlabel('时间/s');
ylabel('电压/V')
figure;
plot(tt,I,'Color','b','LineWidth',2)
xlabel('时间/s');
ylabel('电流/A')
% === Combine four plots into one figure (English labels) ===
figure('Name','PSO–Simulink Results','Color','w');
tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

% 1) Convergence curve
nexttile;
plot(1:maxgen, curve,'r-','LineWidth',2);
grid on;
xlabel('Iteration');
ylabel('Objective value');
title('Convergence curve');

% 2) Power
nexttile;
plot(tt, P,'LineWidth',2);
grid on;
xlabel('Time (s)');
ylabel('Power (W)');
title('Power vs Time');

% 3) Voltage
nexttile;
plot(tt, V,'LineWidth',2);
grid on;
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Voltage vs Time');

% 4) Current
nexttile;
plot(tt, I,'LineWidth',2);
grid on;
xlabel('Time (s)');
ylabel('Current (A)');
title('Current vs Time');

% Optional overall title
sgtitle('PSO Optimization and System Response');