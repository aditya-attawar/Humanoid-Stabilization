

figure(10); clf


X = [   90   120    90    60     45     90
         0   -90     0    90     60      0
         0    30     0    90     60      0      ];


X0 = [(90*pi/180); (30*pi/180); (10*pi/180); 0; 0; 0];

[tout,yout] = ode45(@Attawar_Project_Linearization,[0 2.5],X0');

Attawar_Project_Animate2(tout,yout)

pause(1.5);

close;


for n=1:6
    Attawar_Project_Animate1(X(:,n))
    drawnow
    pause(0.8)
end

close;


X1 = [(100*pi/180); (0*pi/180); (0*pi/180); -0.045; 0; 0];

[tout3,yout3] = ode45(@Attawar_Project_StateFeedback,[0 5],X1');

Attawar_Project_Animate2(tout3,yout3)

pause(0.8);

close;


X2 = [(90*pi/180); (30*pi/180); (10*pi/180); 0.1; 0.1; 0];

[tout2,yout2] = ode45(@Attawar_Project_StateFeedback,[0 5],X2');

Attawar_Project_Animate2(tout2,yout2)


close;

subplot(3,1,1)
plot(tout,yout)
title('Non-linear system');
legend('theta1','theta2','theta3','dtheta1','dtheta2','dtheta3');
xlabel('Time (s)');
ylabel('Angle (rad), Angular Velocity(rad/s)');

subplot(3,1,2)
plot(tout3,yout3)
title('Linearized system with state feedback near equilibrium');
legend('theta1','theta2','theta3','dtheta1','dtheta2','dtheta3');
xlabel('Time (s)');
ylabel('Angle (rad), Angular Velocity(rad/s)');

subplot(3,1,3)
plot(tout2,yout2)
title('With state feedback - Initial condition away from equilibrium');
legend('theta1','theta2','theta3','dtheta1','dtheta2','dtheta3');
xlabel('Time (s)');
ylabel('Angle (rad), Angular Velocity(rad/s)');
