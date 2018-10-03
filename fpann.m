% --------------------------------------------------------------------% 
% Flower pollenation algorithm (FPA), or flower algorithm             %
% Programmed by Xin-She Yang @ May 2012                               % 
% --------------------------------------------------------------------%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes: This demo program contains the very basic components of      %
% the flower pollination algorithm (FPA), or flower algorithm (FA),   % 
% for single objective optimization.    It usually works well for     %
% unconstrained functions only. For functions/problems with           % 
% limits/bounds and constraints, constraint-handling techniques       %
% should be implemented to deal with constrained problems properly.   %
%                                                                     %   
% Citation details:                                                   % 
%1)Xin-She Yang, Flower pollination algorithm for global optimization,%
% Unconventional Computation and Natural Computation,                 %
% Lecture Notes in Computer Science, Vol. 7445, pp. 240-249 (2012).   %
%2)X. S. Yang, M. Karamanoglu, X. S. He, Multi-objective flower       %
% algorithm for optimization, Procedia in Computer Science,           %
% vol. 18, pp. 861-868 (2013).                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [best,fmin,N_iter]=fpann(para)
% Default parameters
if nargin<1
   para=[20 0.8];
end

n=para(1);           % Population size, typically 10 to 25
p=para(2);           % probabibility switch

% Iteration parameters
N_iter=2000;            % Total number of iterations

% Dimension of the search variables
%d=[1 1 1 1;3 30 30 30];

% Lb=0*ones(size(d),'like',d);
% Ub=1*ones(size(d),'like',d);

d=4;

Lb=0*ones(1,d);
Ub=30*ones(1,d);

% Initialize the population/solutions
for i=1:n
  Sol(i,:)=Lb+(Ub-Lb).*rand(1,d);
  Fitness(i)=fnob2(Sol(i,:), i);
end

% Find the current best
[fmin,I]=min(Fitness);
best=Sol(I,:);
S=Sol; 

% Start the iterations -- Flower Algorithm 
for t=1:N_iter
        % Loop over all bats/solutions
        for i=1:n
          % Pollens are carried by insects and thus can move in
          % large scale, large distance.
          % This L should replace by Levy flights  
          % Formula: x_i^{t+1}=x_i^t+ L (x_i^t-gbest)
          if rand>p
          %% L=rand;
          L=Levy(d);
          dS=L.*(Sol(i,:)-best);
          S(i,:)=Sol(i,:)+dS;
          
          % Check if the simple limits/bounds are OK
          S(i,:)=simplebounds(S(i,:),Lb,Ub);
          
          % If not, then local pollenation of neighbor flowers 
          else
              epsilon=rand;
              % Find random flowers in the neighbourhood
              JK=randperm(n);
              % As they are random, the first two entries also random
              % If the flower are the same or similar species, then
              % they can be pollenated, otherwise, no action.
              % Formula: x_i^{t+1}+epsilon*(x_j^t-x_k^t)
              S(i,:)=S(i,:)+epsilon*(Sol(JK(1),:)-Sol(JK(2),:));
              % Check if the simple limits/bounds are OK
              S(i,:)=simplebounds(S(i,:),Lb,Ub);
          end
          
          % Evaluate new solutions
           Fnew=fnob2(S(i,:), i);
          % If fitness improves (better solutions found), update then
            if (Fnew<=Fitness(i))
                Sol(i,:)=S(i,:);
                Fitness(i)=Fnew;
           end
           
          % Update the current global best
          if Fnew<=fmin
                best=S(i,:)   ;
                fmin=Fnew   ;
          end
        end
        % Display results every 100 iterations
        if round(t/100)==t/100
        best
        fmin
        end
        
end
% 
%     figure
%     plot(best)
% Output/display
% figure(1)
% plot(1:N_iter,log10(fmin))
% xlabel('Iterations');
% ylabel('Best');

disp(['Total number of evaluations: ',num2str(N_iter*n)]);
disp(['Best solution=',num2str(best),'   fmin=',num2str(fmin)]);

  

% Application of simple constraints
function s=simplebounds(s,Lb,Ub)
  % Apply the lower bound
  ns_tmp=s;
  I=ns_tmp<Lb;
  ns_tmp(I)=Lb(I);
  
  % Apply the upper bounds 
  J=ns_tmp>Ub;
  ns_tmp(J)=Ub(J);
  % Update this new move 
  s=ns_tmp;


% Draw n Levy flight sample
function L=Levy(d)
% Levy exponent and coefficient
% For details, see Chapter 11 of the following book:
% Xin-She Yang, Nature-Inspired Optimization Algorithms, Elsevier, (2014).
beta=3/2;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
    u=randn(1,d)*sigma;
    v=randn(1,d);
    step=u./abs(v).^(1/beta);
L=0.01*step; 

% Objective function and here we used Rosenbrock's 3D function
% function z=Fun(u)
% z=(1-u(1))^2+100*(u(2)-u(1)^2)^2+100*(u(3)-u(2)^2)^2;


