%SIMULACION DE DATOS ENTRENADOS
at1=sim(net,xtrn);
at1=(at1*ns);
%TS=(TS*ns)

load sistst.dat
load realsistar.dat

sistst1=sistst;
x1=sistst1/ns;

rtarg=realsistar';
num=length(rtarg);
%SIMULANDO DATOS PRONOSTICADOS
sim1=sim(net,x1);
%sim2=sim1*ns;


% %SIMULANDO DATOS PRONOSTICADOS
% simT1=sim(net,PT2);

%IMPRIMIR SOLO EL PRONOSITICO
pronostico1=rtarg;

 for j=1:num
     pronostico1(1,j)=sim1(1,j);
 end
%  P2=(P2*100);
%  PT3=(PT3*100);
%  TS2=(TS2*X);
%  TN=(TN*X);
 pronostico1=(pronostico1*ns);
 sim1=(sim1*ns);
 
 
 %GRAFICANDO PRONOSTICO
%  fig2=figure;
%  leyenda=strcat('Pronostico Modulo 1');
%  set(fig2,'name',leyenda);
%  plot(PT3,TS2,'*m',PT3,pronostico1,'g-');
%  xlabel('Time (Sec)');
%  ylabel('x(t)');
%  title('Mackey-Glass Chaotic Time Series');
 
 %LEYENDA FINAL
%  hold on;
%  leyenda1=strcat('Datos Reales');
%  leyenda2=strcat('Datos Pronosticados');
%  legend(leyenda1,leyenda2);

%%%%%%%%%%%%%%%%%%%%
%INTEGRACION POR PROMEDIO

   prom=pronostico1;
   for iii=1:36
   erroresga(iii)=abs(rtarg(iii)-pronostico1(iii));  
end

errorestga=0;
for ii=1:36
   errorestga=errorestga+erroresga(ii);
end

errorestga=errorestga/36;


%  fig7=figure;
%  leyenda=strcat('Integracion Por Promedio');
%  set(fig7,'name',leyenda);
%   plot(PT3,TS2,'*m',PT3,prom,'g-');
%  xlabel('Time (Sec)');
%  ylabel('x(t)');
%  title('Mackey-Glass Chaotic Time Series');
%  %LEYENDA FINAL
%  hold on;
%  leyenda1=strcat('Datos Reales');
%  leyenda2=strcat('Datos Pronosticados');
%  legend(leyenda1,leyenda2);


% errors=0;
% errors = ((errors)+(rtarg-sim2));
% 
%            evalua1 = length(errors); %evalua1 toma el valor del ultimo numero en errors
%            evalua2 = sum(errors);  %Suma todos los valores del error
%            evalua3 = abs(sqrt((evalua2*((errors).^2))/evalua1));  %Promedia los valores totales del error sacando el ECM
%            %evalua3 = sqrt(mse(evalua2));  %Promedia los valores totales del error sacando el ECM
%            evalua4(i)=evalua3;
% 
% 
% %errorestga=errorestga/297;
% 
% 
%     fig7=figure;
%  leyenda=strcat('Integracion Por Promedio');
%  set(fig7,'name',leyenda);
%   plot(PT3,TS2,'*m',PT3,prom,'g-');
%  xlabel('Time (Sec)');
%  ylabel('x(t)');
%  title('Mackey-Glass Chaotic Time Series');
%  %LEYENDA FINAL
%  hold on;
%  leyenda1=strcat('Datos Reales');
%  leyenda2=strcat('Datos Pronosticados');
%  legend(leyenda1,leyenda2);
% 

%%%%%%%%%%%%%%%%%%%%