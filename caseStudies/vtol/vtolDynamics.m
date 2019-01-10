function [sys,x0,str,ts,simStateCompliance] = pendulumDynamics(t,x,u,flag,P)
switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(P);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u,P);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(P)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [P.z0; P.h0; P.theta0; P.zdot0; P.hdot0; P.thetadot0];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'DisallowSimState' < Error out when saving or restoring the model sim state
simStateCompliance = 'UnknownSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u,P)
  z        = x(1);
  h        = x(2);
  theta    = x(3);
  zdot     = x(4);
  hdot     = x(5);
  thetadot = x(6);
  fr       = u(1);
  fl       = u(2);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % The parameters for any physical system are never known exactly.  Feedback
  % systems need to be designed to be robust to this uncertainty.  In the simulation
  % we model uncertainty by changing the physical parameters by a uniform random variable
  % that represents alpha*100 % of the parameter, i.e., alpha = 0.2, means that the parameter
  % may change by up to 20%.  A different parameter value is chosen every time the simulation
  % is run.
  persistent mc
  persistent Jc
  persistent mr
  persistent ml
  persistent d
  persistent mu
  persistent g
  

  
  
  
  if t==0
    mc = P.mc * (1+2*P.noise_param*rand-P.noise_param);     
    Jc = P.Jc * (1+2*P.noise_param*rand-P.noise_param);     
    mr = P.mr * (1+2*P.noise_param*rand-P.noise_param);     
    ml = P.ml * (1+2*P.noise_param*rand-P.noise_param);  
    d  = P.d  * (1+2*P.noise_param*rand-P.noise_param); 
    mu = P.mu * (1+2*P.noise_param*rand-P.noise_param); 
    g = P.g; % the gravity vector is well known and so we don't change it.
  end

  zddot     = (-(fr+fl)*sin(theta)-mu*zdot)/(mc+2*mr);
  hddot     = (-(mc+2*mr)*g + (fr+fl)*cos(theta))/(mc+2*mr);
  thetaddot = d*(fr-fl)/(Jc+2*mr*d^2);
  
sys = [zdot; hdot; thetadot; zddot; hddot; thetaddot];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
    z        = x(1);
    h        = x(2);
    theta    = x(3);
    zdot     = x(4);
    hdot     = x(5);
    thetadot = x(6);
    
sys = [z; h; theta;zdot;hdot;thetadot];

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate