%SIMULACION DE DATOS ENTRENADOS
at1=sim(net,entrena);
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
sim2=sim1*ns;

%IMPRIMIR SOLO EL PRONOSITICO
pronostico1=rtarg;

 for j=1:num
     pronostico1(1,j)=sim2(1,j);
 end
 
 pronostico1=round(pronostico1);

%%%%%%%%%%%%%%%%%%%%
%INTEGRACION POR PROMEDIO

   prom=pronostico1;
   for iii=1:36
   erroresga(iii)=abs(rtarg(iii)-pronostico1(iii));  
   mse_calc(iii) = sum((rtarg(iii)-pronostico1(iii)).^2)/length(rtarg);
   end

   %mse_calc = sum((y-targets).^2)/length(y);

errorestga=0;
for ii=1:36
   errorestga=errorestga+mse_calc(ii);
end

errorestga=errorestga/36;
