%% Configure System Models

%% Configurações do Filtro de Kalman:

 
%% Sintonização dos Ganhos:

% Ganho da Matriz de Covariância R (Incerteza das medições do Kinect):
gr = 1e-9;

% Ganhos da Matriz de Covariância Inicial P:
gp1 = 0.01; % Posição
gp2 = 0.1;  % Velocidade

% Ganhos da Matriz de Covariância Inicial Q (Incerteza da Dinâmica):
gq1 = 1e-9; % Posição
gq2 = 1e-7;   % Velocidade

%========================================================================
%% Dinâmica Contínua:

% Matriz Contínua da Dinâmica do Sistema:  
A = [zeros(3,3) eye(3);zeros(3,3) zeros(3,3)];

% Matriz Contínua de Controle do Sistema:  
B = [zeros(3,3);eye(3)];

% Matriz Contínua de Medidas
C = [eye(3) zeros(3,3)];

% Sistema Contínuo em espaço de estados:
sys = ss(A,B,C,0);

%% Dinâmica Discreta:

% Sistema Discreto em Espaço de Estados:
Dis = c2d(sys,Amost);

%Matriz A discreta:
Ad =Dis.A;

%Matriz A discreta:
Bd =Dis.B;

%Matriz A discreta:
Cd =Dis.C;

% Entrada u
u = [0;0;0];  

%% Matrizes de Covariância:

% Matriz de Covariância do erro de Estado
G = eye(6);  
  
% Matriz de Covariância do erro de Medida(erro do Kinect)
R = gr*eye(3);
  
% Matriz de Covariância (Inicial)
P0 = [gp1*eye(3) zeros(3,3);zeros(3,3) gp2*eye(3)];
  
% Matriz Q (Sintonizada)
Q = [gq1*eye(3) zeros(3,3);zeros(3,3) gq2*eye(3)];

%% Vetor de Estados (Estados Iniciais do Sistema)

x0 = zeros(6,1); %[X0 Y0 Z0 Vx0 Vy0 Vz0]'

xk = x0;
Pk = P0;