function Attawar_Project_Animate1(X1)

theta1 = X1(1)*pi/180;
theta2 = X1(2)*pi/180;
theta3 = X1(3)*pi/180;

L1 = 2;
L2 = 2;
rb = 0.35;
d = 0.2;

db1 = rb * (theta1+theta2+theta3-(pi/2));
La = (L2 - d) / cos(15*pi/180);
Lb = (L2 - d) / cos(40*pi/180);
Lc = sqrt( (L2^2) + (( Lb*sin(40*pi/180) )^2) );
phi = atan( Lb * sin(40*pi/180) / L2 );

O = [ 0 0 ];
A = [ L1*cos(theta1) L1*sin(theta1) ];
B = [ L1*cos(theta1)+L2*(cos(theta1+theta2)) L1*sin(theta1)+L2*(sin(theta1+theta2)) ];
P = [ L1*cos(theta1)+La*cos(theta1+theta2-(15*pi/180)) L1*sin(theta1)+La*sin(theta1+theta2-(15*pi/180)) ];
Q = [ L1*cos(theta1)+Lb*cos(theta1+theta2-(40*pi/180)) L1*sin(theta1)+Lb*sin(theta1+theta2-(40*pi/180)) ];
R = [ L1*cos(theta1)+Lc*cos(theta1+theta2-phi) L1*sin(theta1)+Lc*sin(theta1+theta2-phi) ];
S = [ L1*cos(theta1)+Lc*cos(theta1+theta2+phi) L1*sin(theta1)+Lc*sin(theta1+theta2+phi) ];
T = [ L1*cos(theta1)+Lb*cos(theta1+theta2+(40*pi/180)) L1*sin(theta1)+Lb*sin(theta1+theta2+(40*pi/180)) ];
U = [ L1*cos(theta1)+La*cos(theta1+theta2+(15*pi/180)) L1*sin(theta1)+La*sin(theta1+theta2+(15*pi/180)) ];
W = [ -0.1 0 ];
X = [ 0.1 0 ];
Y = [ (L1*cos(theta1))+0.1 L1*sin(theta1) ];
Z = [ (L1*cos(theta1))-0.1 L1*sin(theta1) ];

B0 = [ L1*cos(theta1)+(L2+rb)*cos(theta1+theta2) L1*sin(theta1)+(L2+rb)*sin(theta1+theta2) ];

beta = (theta1+theta2)-(90*pi/180);

h = B0(1);
k = B0(2);

xb1 = -db1*cos(beta) + h;
yb1 = -db1*sin(beta) + k;

B1 = [ xb1 yb1 ];

xb2 = rb*(cos(theta3+(theta1+theta2)))*cos(beta) - rb*(sin(theta3+(theta1+theta2)))*sin(beta) + xb1;
yb2 = rb*(cos(theta3+(theta1+theta2)))*sin(beta) + rb*(sin(theta3+(theta1+theta2)))*cos(beta) + yb1;

B2 = [ xb2 yb2 ];

thetab = 0 : 0.01 : (2*pi);
xb = rb*(cos(thetab+(theta1+theta2)))*cos(beta) - rb*(sin(thetab+(theta1+theta2)))*sin(beta) + xb1;
yb = rb*(cos(thetab+(theta1+theta2)))*sin(beta) + rb*(sin(thetab+(theta1+theta2)))*cos(beta) + yb1;

X_link = [ O(1) A(1) A(1) B(1) ];
Y_link = [ O(2) A(2) A(2) B(2) ];

X_body1 = [ A(1) P(1) P(1) Q(1) Q(1) R(1) R(1) S(1) S(1) T(1) T(1) U(1) U(1) A(1) ];
Y_body1 = [ A(2) P(2) P(2) Q(2) Q(2) R(2) R(2) S(2) S(2) T(2) T(2) U(2) U(2) A(2) ];

X_body2 = [ W(1) X(1) X(1) Y(1) Y(1) Z(1) Z(1) W(1) ];
Y_body2 = [ W(2) X(2) X(2) Y(2) Y(2) Z(2) Z(2) W(2) ];

X_pointer = [ B1(1) B2(1) ];
Y_pointer = [ B1(2) B2(2) ];


figure(10); clf
plot([-5 5],[0 0],'k'); hold on;

plot( X_link,Y_link,'r','LineWidth',2 ); hold on;

plot( X_body1,Y_body1,'k','LineWidth',2 ); hold on;

plot( X_body2,Y_body2,'k','LineWidth',2 ); hold on;

plot( xb,yb,'b','LineWidth',2 ); hold on;

plot( X_pointer,Y_pointer,'k','LineWidth',2 ); hold on;

axis image;
