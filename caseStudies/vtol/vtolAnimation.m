function vtolAnimation(u)

    % process inputs to function
    z        = u(1);
    h        = u(2);
    theta    = u(3);
    zdot     = u(4);
    hdot     = u(5);
    thetadot = u(6);
    t        = u(7);
    
    % drawing parameters
    box_length = 1.5;
    rod_length = 6;
    circle_d = 4;
    plot_dim = 10;
    
    % define persistent variables 
    persistent left_rotor
    persistent right_rotor
    persistent box
    persistent rod
    
    % first time function is called, initialize plot and persistent vars
    if t==0
        figure(1), clf
        track_width=2;
        hold on
        rod          = drawRod(h,z, theta, rod_length, []);
        left_rotor   = drawLeftRotor(h,z, theta,circle_d,rod_length, []);
        right_rotor  = drawRightRotor(h,z, theta, circle_d,rod_length, []);
        box          = drawBox(h,z, theta, box_length, []);
        
        
        axis([-plot_dim, plot_dim, -plot_dim, plot_dim]);
    
        
    % at every other time step, redraw base and rod
    else 
        drawRod(h,z, theta, rod_length, rod);
        drawLeftRotor(h,z, theta,circle_d,rod_length, left_rotor);
        drawRightRotor(h,z, theta, circle_d,rod_length, right_rotor);
        drawBox(h,z, theta, box_length, box);
        
    end
end

   
%
%=======================================================================
% drawLeftRotor
% draw the left rotor of the vtol
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function new_handle = drawLeftRotor(h,z, theta,circle_d,rod_length, handle)
  
phi = -pi:pi/10:pi;
x = cos(phi) - rod_length;
y = sin(phi)/circle_d;

  pts = [x',y'];
  
  % Rotation matrix
  R = [cos(theta) sin(theta);...
      -sin(theta) cos(theta)];
  
  pts = pts*R;
  pts = pts + [z,h];

  if isempty(handle)
    new_handle = fill(pts(:,1),pts(:,2),'b');
  else
    set(handle,'XData',pts(:,1),'YData',pts(:,2));
    drawnow
  end
end
 
%
%=======================================================================
% drawRightRotor
% draw the right rotor of the vtol
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function new_handle = drawRightRotor(h,z, theta,circle_d,rod_length, handle)
  
phi = -pi:pi/10:pi;
x = cos(phi) + rod_length;
y = sin(phi)/circle_d;

  pts = [x',y'];
  
  % Rotation matrix
  R = [cos(theta) sin(theta);...
      -sin(theta) cos(theta)];
  
  pts = pts*R;
  pts = pts + [z,h];

  if isempty(handle)
    new_handle = fill(pts(:,1),pts(:,2),'b');
  else
    set(handle,'XData',pts(:,1),'YData',pts(:,2));
    drawnow
  end
end

%
%=======================================================================
% drawBox
% draw the center box of the vtol
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%

function new_handle = drawBox(h,z, theta, box_length, handle)
  

x = [box_length/2, -box_length/2, -box_length/2, box_length/2];
y = [box_length/2, box_length/2, -box_length/2, -box_length/2];

  pts = [x',y'];
  
  % Rotation matrix
  R = [cos(theta) sin(theta);...
      -sin(theta) cos(theta)];
  
  pts = pts*R;
  pts = pts + [z,h];

  if isempty(handle)
    new_handle = fill(pts(:,1),pts(:,2),'b');
  else
    set(handle,'XData',pts(:,1),'YData',pts(:,2));
    drawnow
  end
end

%
%=======================================================================
% drawRod
% draw the rod of the vtol
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function new_handle = drawRod(h,z, theta, rod_length, handle)
  

x = [-rod_length, rod_length];
y = [0,0];

  pts = [x',y'];
  
  % Rotation matrix
  R = [cos(theta) sin(theta);...
      -sin(theta) cos(theta)];
  
  pts = pts*R;
  pts = pts + [z,h];

  if isempty(handle)
    new_handle = plot(pts(:,1),pts(:,2),'k');
  else
    set(handle,'XData',pts(:,1),'YData',pts(:,2));
    drawnow
  end
end
