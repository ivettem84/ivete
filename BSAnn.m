% ------------------------------------------------------------------------
% Bird Swarm Algorithm (BSA) (demo)
% Programmed by Xian-Bing Meng
% Updated at Jun 19, 2015.    
% Email: x.b.meng12@gmail.com
%
% This is a simple demo version only implemented the basic idea of BSA for        
% solving the unconstrained problem, namely Sphere function.  
%
% The details about BSA are illustratred in the following paper.    
% Xian-Bing Meng, et al (2015): A new bio-inspXred optimisation algorithm: 
% Bird Swarm Algorithm, Journal of Experimental & Theoretical
% Artificial Intelligence, DOI: 10.1080/0952813X.2015.1042530
%
% The parameters in BSA are presented as follows.
% FitFunc    % The objective function
% M          % Maxmimal generations (iterations)
% pop        % Population size
% dim        % Dimension
% FQ         % The frequency of birds' flight behaviours 
% c1         % Cognitive accelerated coefficient
% c2         % Social accelerated coefficient
% a1, a2     % Two paramters which are related to the indirect and direct 
%              effect on the birds' vigilance bahaviors.
%
% Using the default value, BSA can be executed using the following code.
% [ bestX, fMin ] = BSA
% ------------------------------------------------------------------------
 
% Main programs

function [ bestX, fMin ] = BSA( FitFunc, M, pop, dim, FQ, c1, c2, a1, a2, x, i )
for k=1:1
% Display help
%help BSA.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set the default parameters
if nargin < 1
    FitFunc = @Sphere;
    M =[1000 870 714 625 571 574 454 416 400 357 338 322 307 285 278 256 ...
        250 235 227 208 202 166 133 111 100 95 90 87 83 80];
    pop = [20 24 28 32 36 38 44 48 50 56 60 62 66 70 72 78 80 86 88 96 100 120 150 ...
           180 200 210 220 230 240 250]; 
    dim = 3;   
    FQ = randi([1,30],1,1);  
    c1 = [0.5 0.8 1.2 1.5 1.8 2 2.33 2.48 2.76 3 3.18 3.22 3.45 3.56 4 0.4 0.7 ...
           1.15 1.34 1.45 1.67 1.78 1.92 2.18 2.39 2.56 2.83 3.4 3.7 4];
    c2 = [0.5 0.8 1.2 1.5 1.8 2 2.33 2.48 2.76 3 3.18 3.22 3.45 3.56 4 0.4 0.7 ...
           1.15 1.34 1.45 1.67 1.78 1.92 2.18 2.39 2.56 2.83 3.4 3.7 4];
    a1 = [2 1.5 0.4 0.1 0.8 1 1.3 0.6 0.9 1.1 1.9 0.5 1.5 0.7 1.3 1.8 0.3 0.9 1 2 ... 
          0.6 0.3 1.5 1.2 1.8 0.7 0.9 1.5 1.7 2];
    a2 = [2 1.5 0.4 0.1 0.8 1 1.3 0.6 0.9 1.1 1.9 0.5 1.5 0.7 1.3 1.8 0.3 0.9 1 2 ... 
          0.6 0.3 1.5 1.2 1.8 0.7 0.9 1.5 1.7 2];
end

M=M(k);
pop=pop(k);
c1=c1(k);
c2=c2(k);
a1=a1(k);
a2=a2(k);

errors = 0;

comienza=now;

load sisto1.dat
load tarsis.dat

% x = sisto1;
% ta = tarsis;

trnsis=sisto1;
%Buscar numero maximo en los vectores para normalizar
maxs=max(trnsis);
ns=max(maxs);
%Normalizando datos
xtrn=trnsis/ns;
ta=tarsis/ns;


lb=[1 ...
    1 ...
    1];
ub=[2 ... 
    30 ...
    30];

resulta= fopen('D:\Doctorado\code\Genetic-Toolbox\errores.txt', 'wt');
fprintf(resulta,['Resultados obtenidos \n\nErrore-Generacion-Individuo\n\n']);

for i = 1 : pop
    x( i, : ) = round(lb + (ub - lb) .* rand( 1, dim )); 

          disp('Iniciando Entrenamiento...');
          
          %%%%%%%%%%%%%%%%%%%%%%%%%%%% PRIMER MODULO %%%%%%%%%%%%%%%%%%%%%%%%%%
        
          disp('Inicia Modulo 1...');
%           
%           if(Chrom(i,1)==1)%Monolitica
%              display('Red monolitica en construccion')
%           elseif (Chrom(i,1)==2) % Modular
              if(x(i,1)==1)% 1 modulo y  1 capa
                  net=newff(minmax(xtrn),[x(i,2),1],{'tansig','purelin','logsig'},'trainlm');
              end
              
              if(x(i,2)==1)% 1 modulo y  2 capa
                  net=newff(minmax(xtrn),[x(i,2),x(i,3),1],{'tansig','tansig','purelin','purelin','logsig'},'trainlm');
              end
              
%               if(Chrom(i,1)==3)% 1 modulo y  3 capa
%                   net=newff(minmax(x),[Chrom(i,2),Chrom(i,3),Chrom(i,4),1],{'tansig','purelin','purelin','purelin','tansig','tansig','logsig'},'trainlm');
%               end

              net.LW{2,1} = net.LW{2,1}*0.05;
              net.b{2}=net.b{2}*0.01;
              net.trainParam.show=NaN;
              net.trainParam.goal=0.001;
              net.trainParam.lr=0.01;
              net.trainParam.epochs = 100;
              [net,tr1]=train(net,xtrn,ta);
           %A1=sim(net,x);
          
          disp('Fin del entrenamiento Modulo 1');
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCION OBJETIVO PARA CUANDO ES DE UN MODULO

% if(Chrom(i,1)==1)   
 fnob2();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  fit(i)=erroresga; %fit( i ) = FitFunc; 
    
end
pFit = fit; % The individual's best fitness value
pX = x;     % The individual's best position corresponding to the pFit

[ fMin, bestIndex ] = min( fit );  % fMin denotes the global optimum
% bestX denotes the position corresponding to fMin
bestX = x( bestIndex, : );   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start the iteration.

 for iteration = 1 : M
     
    prob = rand( pop, 1 ) .* 0.2 + 0.8;%The probability of foraging for food
    
    if( mod( iteration, FQ ) ~= 0 )         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Birds forage for food or keep vigilance
        sumPfit = sum( pFit );
        meanP = mean( pX );
        for i = 1 : pop
            if rand < prob(i)
                x( i, : ) = x( i, : ) + c1 * rand.*(bestX - x( i, : ))+ ...
                    c2 * rand.*( pX(i,:) - x( i, : ) );
            else
                person = randiTabu( 1, pop, i, 1 );
                
                x( i, : ) = x( i, : ) + rand.*(meanP - x( i, : )) * a1 * ...
                    exp( -pFit(i)/( sumPfit + realmin) * pop ) + a2 * ...
                    ( rand*2 - 1) .* ( pX(person,:) - x( i, : ) ) * exp( ...
                    -(pFit(person) - pFit(i))/(abs( pFit(person)-pFit(i) )...
                    + realmin) * pFit(person)/(sumPfit + realmin) * pop ); 
            end
            
            x( i, : ) = Bounds( x( i, : ), lb, ub );  
            fit( i ) = fit(i);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    else
        FL = rand( pop, 1 ) .* 0.4 + 0.5;    %The followed coefficient
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Divide the bird swarm into two parts: producers and scroungers.
        [ans, minIndex ] = min( pFit );
        [ans, maxIndex ] = max( pFit );
        choose = 0;
        if ( minIndex < 0.5*pop && maxIndex < 0.5*pop )
            choose = 1;
        end
        if ( minIndex > 0.5*pop && maxIndex < 0.5*pop )
            choose = 2;
        end
        if ( minIndex < 0.5*pop && maxIndex > 0.5*pop )
            choose = 3;
        end
        if ( minIndex > 0.5*pop && maxIndex > 0.5*pop )
            choose = 4;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if choose < 3
            for i = (pop/2+1) : pop
                x( i, : ) = x( i, : ) * ( 1 + randn );
                x( i, : ) = Bounds( x( i, : ), lb, ub );
                fit( i ) = fit(i) ;
            end
            if choose == 1 
                x( minIndex,: ) = x( minIndex,: ) * ( 1 + randn );
                x( minIndex, : ) = Bounds( x( minIndex, : ), lb, ub );
                fit( minIndex ) = fit( x( minIndex, : ) );
            end
            for i = 1 : 0.5*pop
                if choose == 2 || minIndex ~= i
                    person = randi( [(0.5*pop+1), pop ], 1 );
                    x( i, : ) = x( i, : ) + (pX(person, :) - x( i, : )) * FL( i );
                    x( i, : ) = Bounds( x( i, : ), lb, ub );
                    fit( i ) = fit(i);
                end
            end
        else
            for i = 1 : 0.5*pop
                x( i, : ) = x( i, : ) * ( 1 + randn );
                x( i, : ) = Bounds( x( i, : ), lb, ub );
                fit( i ) = fit( i );
            end
            if choose == 4 
                x( minIndex,: ) = x( minIndex,: ) * ( 1 + randn );
                x( minIndex, : ) = Bounds( x( minIndex, : ), lb, ub );
                fit( minIndex ) = fit( x( minIndex, : ) );
            end
            for i = (0.5*pop+1) : pop
                if choose == 3 || minIndex ~= i
                    person = randi( [1, 0.5*pop], 1 );
                    x( i, : ) = x( i, : ) + (pX(person, :) - x( i, : )) * FL( i );
                    x( i, : ) = Bounds( x( i, : ), lb, ub );
                    fit( i ) = fit( i );
                end
            end   
        end
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update the individual's best fitness vlaue and the global best one
   
    for i = 1 : pop 
        if ( fit( i ) < pFit( i ) )
            pFit( i ) = fit( i );
            pX( i, : ) = x( i, : );
        end
        
        if( pFit( i ) < fMin )
            fMin = pFit( i );
            bestX = pX( i, : );
        end
    end
    
 end
filename = [ 'fisBSA1102-' num2str(k) ];
save(filename)
end

% End of the main program

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following functions are associated with the main program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is the objective function


% Application of simple limits/bounds
function s = Bounds( s, Lb, Ub)
  % Apply the lower bound vector
  temp = s;
  I = temp < Lb;
  temp(I) = Lb(I);
  
  % Apply the upper bound vector 
  J = temp > Ub;
  temp(J) = Ub(J);
  % Update this new move 
  s = temp;

%--------------------------------------------------------------------------
% This function generate "dim" values, all of which are different from
%  the value of "tabu"
function value = randiTabu( min, max, tabu, dim )
value = ones( dim, 1 ) .* max .* 2;
num = 1;
while ( num <= dim )
    temp = randi( [min, max], 1, 1 );
    if( length( find( value ~= temp ) ) == dim && temp ~= tabu )
        value( num ) = temp;
        num = num + 1;
    end
end