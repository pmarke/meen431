%% Add Parent Directory to Search Path
curr_dir = pwd;
par_dir = curr_dir(1:(strfind(curr_dir,'vtol')+4));
addpath(par_dir);


%% Vtol Parameters
P.mc = 1;          % Mass of box, kg
P.Jc = 0.0042;     % Moment of inertial for box, kg m^2
P.mr = 0.25;       % Mass of right rotor, kg
P.ml = 0.25;       % Mass of left rotor, kg
P.d = 0.3;         % Length of rod between box and rotor, m
P.mu = 0.1;        % Damping coefficient, kg/s
P.g = 9.81;        % Gravity term, m/s^2

%% Initial Condition
P.h0        = 0;
P.z0        = 0;
P.theta0    = 0;
P.hdot0     = 0;
P.zdot0     = 0;
P.thetadot0 = 0;

%% Parameter ans Sensor Noise coefficients
% The parameters for any physical system are never known exactly.  Feedback
% systems need to be designed to be robust to this uncertainty.  In the simulation
% we model uncertainty by changing the physical parameters by a uniform random variable
% that represents alpha*100 % of the parameter, i.e., alpha = 0.2, means that the parameter
% may change by up to 20%.  A different parameter value is chosen every time the simulation
% is run.
P.noise_param = 0;            % Indicates how much the parameters can change.
                              % eg. noise_alpha = 0.2 means the parameters
                              % can change up to 20 percent.
%                            
% Sensors are subject to noise, so the observed outputs are never percise. We can add
% random noise to this output. The noise added is x + noise_sensor*randn. 
P.noise_sensor = 0;