function Attawar_Project_EOMs()

clear all;
format compact

% Define symbolic variables in matlab:
syms theta1 theta2 theta3 L1 L2 m1 m2 m3 J1 J2 J3 rb g tau  % xb2 yb2 yb1 db1 beta1 k

xB = L1*cos(theta1) + L2*cos(theta1+theta2);
yB = L1*sin(theta1) + L2*sin(theta1+theta2);
xA = L1*cos(theta1);
yA = L1*sin(theta1);

% 1a. GC's (generalized coordinates), and their derivatives:
GC = [{theta1},{theta2},{theta3}];
dtheta1 = Attawar_fulldiff(theta1,GC);
dtheta2 = Attawar_fulldiff(theta2,GC);
dtheta3 = Attawar_fulldiff(theta3,GC);

% 1c. Define any required velocity terms (for masses):
dxB = Attawar_fulldiff(xB,GC);
dyB = Attawar_fulldiff(yB,GC);
dxA = Attawar_fulldiff(xA,GC);
dyA = Attawar_fulldiff(yA,GC);

% 2. Kinetic Energy:
T = (1/2)*( m1*(rb*dtheta3)^2 + J1*(dtheta3)^2 + m2*(dxB^2+dyB^2) + J2*(dtheta2)^2 + m2*(dxA^2+dyA^2) + J3*(dtheta1)^2 )

% 3. Potential Energy:
V = m1*g*((L1*sin(theta1)) + ((L2+rb)*(sin(theta1+theta2))) - (rb*theta3*sin(theta1+theta2-(pi/2))) ) + m2*g*(yB) + m3*g*(yA)

% 4. Lagrangian:
L = T-V

% 5. EOMs:
eq1 = fulldiff(diff(L,dtheta1),GC) - diff(L,theta1);
eq2 = fulldiff(diff(L,dtheta2),GC) - diff(L,theta2);
eq3 = fulldiff(diff(L,dtheta3),GC) - diff(L,theta3);
eq1 = simplify(eq1)
eq2 = simplify(eq2)
eq3 = simplify(eq3)

% 6. Xi: non-conservative terms
Xi1 = tau
Xi2 = 0
X13 = 0
