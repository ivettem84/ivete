function n = Fun3 (Sol,i,f)

load pacientestrain.dat
load pacientestarg.dat

p=pacientestrain;
t=pacientestarg;

 %net=newff(minmax(x),[Sol(i,2),1],{'tansig','purelin','logsig'},'trainlm');

              if(round(Sol(1,1))==1 || round(Sol(1,1))<10)% 1 modulo y  1 capa
                  net=newff(minmax(p),[round(Sol(1,2)),1],{'tansig','purelin','logsig'},'trainlm');
              
              elseif(round(Sol(1,1))==2 || round(Sol(1,1))<=20 )% 1 modulo y  2 capa
                  net=newff(minmax(p),[round(Sol(1,2)),round(Sol(1,3)),1],{'tansig','tansig','purelin','purelin','logsig'},'trainlm');
              
              elseif(round(Sol(1,1))==3 || round(Sol(1,1))<=30)% 1 modulo y  3 capa
                  net=newff(minmax(p),[round(Sol(1,2)),round(Sol(1,3)),round(Sol(1,4)),1],{'tansig','purelin','purelin','purelin','tansig','tansig','logsig'},'trainlm');
              end
              
net.LW{1,1}=net.LW{1,1}*0.01;       %Pesos de conexiones
net.b{1}=net.b{1}*0.01;             %Umbrales
net.trainParam.show = 100;           % El resultado se muestra cada 100 épocas
net.trainParam.lr = 0.02;           % Tasa de aprendizaje usado en algún gradiente
net.trainParam.epochs =1000;         % Máximo numero de iteraciones
net.trainParam.goal = 1e-5;          % Tolerancia de Error, criterio de parada
net.trainParam.min_grad=1e-11;         %Minimum performance gradient
%Start training
net.trainParam.showWindow=0;
[net,tr1] = train(net,p, t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simulando datos entrenados
A1=sim(net,p);
Riesgo=round(A1*100);

n=perform(net,t,p);

%save('framin130201.mat')

