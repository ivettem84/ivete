function n = FitFunc (x,i)


load sisto1.dat
load tarsis.dat

% x = sisto1;
% ta = tarsis;

trnsis=sisto1;
%Buscar numero maximo en los vectores para normalizar
maxs=max(trnsis);
ns=max(maxs);
%Normalizando datos
entrena=trnsis/ns;
ta=tarsis/ns;


disp('Iniciando Entrenamiento...');
          
          %%%%%%%%%%%%%%%%%%%%%%%%%%%% PRIMER MODULO %%%%%%%%%%%%%%%%%%%%%%%%%%
        
          disp('Inicia Modulo 1...');
%           
%           if(Chrom(i,1)==1)%Monolitica
%              display('Red monolitica en construccion')
%           elseif (Chrom(i,1)==2) % Modular
              if(x(1,1)==1)% 1 modulo y  1 capa
                  net=newff(minmax(entrena),[x(1,2),1],{'tansig','purelin','logsig'},'trainlm');
              end
              
              if(x(1,1)==2)% 1 modulo y  2 capa
                  net=newff(minmax(entrena),[x(1,2),x(1,3),1],{'tansig','tansig','purelin','purelin','logsig'},'trainlm');
              end
              

              net.LW{2,1} = net.LW{2,1}*0.05;
              net.b{2}=net.b{2}*0.01;
              net.trainParam.show=NaN;
              net.trainParam.goal=0.00001;
              net.trainParam.lr=0.01;
              net.trainParam.epochs = x(1,4);
              net.trainParam.showWindow=0;
              [net,tr1]=train(net,entrena,ta);
          
          disp('Fin del entrenamiento Modulo 1');
          
   fnob2bsa();

   
   %filename = [ 'best' num2str(k1) '.mat' ];
% save(filename)
  n=errorestga;
  




