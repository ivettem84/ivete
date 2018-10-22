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

function [ bestX, fMin ] = BSA( FitFunc, M, pop, dim, FQ, c1, c2, a1, a2 )
% Display help
help BSA.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set the default parameters
if nargin < 1
    %FitFunc = @Sphere;
    M = 5;   
    pop = 30;  
    dim = 4;   
    FQ = 10;   
    c1 = 1.5;
    c2 = 1.5;
    a1 = 1;
    a2 = 1;
end
comienza=now;

% set the parameters
lb= [1 1 1 1];   % Lower bounds
ub= [2 30 30 700];    % Upper bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s1=pwd; %Identify current folder
%s2=['\erroresFPA0910-' num2str(k1) '.txt'];
s2='\erroresBSA2210.txt';
dir = strcat(s1,s2);
%--crear arhivo para guardar errores
error1= fopen(dir, 'wt');


%Initialization

for i = 1 : pop
    x( i, : ) = round(lb + (ub - lb) .* rand( 1, dim )); 
    fit( i ) = FitFunc1( x( i, : ) ); 
  fprintf(error1,['Error:' num2str(fit(i)) ' Iteracion:' int2str(i) ' Individuos:' int2str(pop) ' Capas: ' int2str(x(i,1)) ' Neuronas capa 1: ' int2str(x(i,2))  ' Neuronas Capa 2: ' int2str(x(i,3)) ' Epocas: ' int2str(x(i,4)) '\n']); 
end
pFit = fit; % The individual's best fitness value
pX = x;     % The individual's best position corresponding to the pFit

[ fMin, bestIndex ] = min( fit );  % fMin denotes the global optimum
% bestX denotes the position corresponding to fMin
bestX = x( bestIndex, : );   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start the iteration.
fprintf(error1,['\n----------------------------------------\n\n']);

 for iteration = 1 : M
     
    prob = rand( pop, 1 ) .* 0.2 + 0.8;%The probability of foraging for food
    
    if( mod( iteration, FQ ) ~= 0 )         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Birds forage for food or keep vigilance
        sumPfit = sum( pFit );
        meanP = mean( pX );
        for i = 1 : pop
            if rand < prob(i)
                x( i, : ) =round( x( i, : ) + c1 * rand.*(bestX - x( i, : ))+ ...
                    c2 * rand.*( pX(i,:) - x( i, : ) ));
            else
                person = randiTabu( 1, pop, i, 1 );
                
                x( i, : ) = round(x( i, : ) + rand.*(meanP - x( i, : )) * a1 * ...
                    exp( -pFit(i)/( sumPfit + realmin) * pop ) + a2 * ...
                    ( rand*2 - 1) .* ( pX(person,:) - x( i, : ) ) * exp( ...
                    -(pFit(person) - pFit(i))/(abs( pFit(person)-pFit(i) )...
                    + realmin) * pFit(person)/(sumPfit + realmin) * pop )); 
            end
            
            x( i, : ) = Bounds( x( i, : ), lb, ub );  
            fit( i ) = FitFunc1( x( i, : ) );
              
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf(error1,['Error:' num2str(fit(iteration)) ' Iteracion:' int2str(iteration) ' Individuos:' int2str(iteration) ' Capas: ' int2str(x(iteration,1)) ' Neuronas capa 1: ' int2str(x(iteration,2))  ' Neuronas Capa 2: ' int2str(x(iteration,3)) ' Epocas: ' int2str(x(iteration,4)) '\n']);
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
                fit( i ) = FitFunc1( x( i, : ) );
            end
            if choose == 1 
                x( minIndex,: ) = x( minIndex,: ) * ( 1 + randn );
                x( minIndex, : ) = Bounds( x( minIndex, : ), lb, ub );
                fit( minIndex ) = FitFunc1( x( minIndex, : ) );
            end
            for i = 1 : 0.5*pop
                if choose == 2 || minIndex ~= i
                    person = randi( [(0.5*pop+1), pop ], 1 );
                    x( i, : ) = x( i, : ) + (pX(person, :) - x( i, : )) * FL( i );
                    x( i, : ) = Bounds( x( i, : ), lb, ub );
                    fit( i ) = FitFunc1( x( i, : ) );
                end
            end
        else
            for i = 1 : 0.5*pop
                x( i, : ) = x( i, : ) * ( 1 + randn );
                x( i, : ) = Bounds( x( i, : ), lb, ub );
                fit( i ) = FitFunc1( x( i, : ) );
            end
            if choose == 4 
                x( minIndex,: ) = x( minIndex,: ) * ( 1 + randn );
                x( minIndex, : ) = Bounds( x( minIndex, : ), lb, ub );
                fit( minIndex ) = FitFunc1( x( minIndex, : ) );
            end
            for i = (0.5*pop+1) : pop
                if choose == 3 || minIndex ~= i
                    person = randi( [1, 0.5*pop], 1 );
                    x( i, : ) = x( i, : ) + (pX(person, :) - x( i, : )) * FL( i );
                    x( i, : ) = Bounds( x( i, : ), lb, ub );
                    fit( i ) = FitFunc1( x( i, : ) );
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
termina=now;%%%%%%%%% TIEMPO FINAL
fprintf(error1,['\n----------------------------------------\n\n']);
fprintf(error1,['Best Solution:' num2str(bestX) ' fmin=',num2str(fMin) '   BSA time:', datestr(termina-comienza,'HH:MM:SS') '\n']);
disp(['Total number of evaluations: ',num2str(M*pop)]);
disp(['Best solution=',num2str(bestX),'   fmin=',num2str(fMin) '   BSA time:', datestr(termina-comienza,'HH:MM:SS')]);

% End of the main program

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following functions are associated with the main program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is the objective function
% function y = Sphere( x )
% y = sum( x .^ 2 );

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