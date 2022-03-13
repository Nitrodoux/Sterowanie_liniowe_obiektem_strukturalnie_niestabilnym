
clc;
M=1.57;    % masa w�zka
m=0.554;    % masa wahad�a
b=0.1673;   % wsp�czynnik tarcia w�zka
I=0.0129;   % moment bezw�adno�ci wahad�a
l=0.6470;   % po�o�enie �rodka ci�ko�ci wahad�a
g=9.81;     % przy�pieszenie ziemskie

q=(M+m)*(I+m*l^2)-(m*l)^2;
s=tf('s');

P_wozek=(((I+m*l^2)/q)*s^2-(m*g*l/q))/...
        (s^4 + (b*(I+m*l^2))*s^3/q-...
        ((M+m)*m*g*l)*s^2/q-b*m*g*l*s/q);
    
    
P_wahadlo=(m*l*s/q)/(s^3+...
          (b*(I+m*l^2))*s^2/q...
          -((M+m)*m*g*l)*s/q-b*m*g*l/q);

p=I*(M+m)+M*m*l^2; %mianownik w macierzach A i B
%% Macierz stanu
A = [0      1       0       0;
     0  -(I+l*m^2)*b/p  m^2*g*l^2/p     0;
     0      0       0       1;
     0  -(m*l*b)/p      m*g*l*(M+m)/p   0];
 %% Macierz wej��
 B = [0;
     (I+m*l^2)/p;
     0;
     m*l/p];
 %% Macierz wyj��/pomiaru
 C = [1 0 0 0;
      0 0 1 0];
 %% Macierz transmisyjna
  D = [0;
       0];
  %%
  zm_stanu={'x' 'x_dot' 'phi' 'phi_dot'};
  wejscia={'F'};
  wyjscia={'x'; 'phi'};
  
  sys_ss= ss(A,B,C,D,'statename', zm_stanu,...
      'inputname', wejscia, 'outputname', wyjscia)
  %%
  t=0:0.1:1;
  
figure(1)
step(P_wozek,t)
grid on
legend('W�zek')
title('Charakterystyka skokowa dla w�zka');
xlabel('Czas');
ylabel('Amplituda x [m]');

figure(2)
step(P_wahadlo,t)
grid on
legend('Wahad�o')
title('Charakterystyka skokowa dla wahad�a');
xlabel('Czas');
ylabel('Amplituda \phi [rad]');


figure(3)
impulse(P_wozek,t)
legend('W�zek')
title('Charakterystyka impulsowa dla w�zka');
xlabel('Czas');
ylabel('Amplituda x [m]');

figure(4)
impulse(P_wahadlo,t)
legend('Wahad�o')
title('Charakterystyka impulsowa dla wahad�a');
xlabel('Czas');
ylabel('Amplituda \phi [rad]');

opt=bodeoptions;
opt.Title.String='Charakterystka bodego w�zek';
opt.Title.FontSize=14;
opt.XLabel.String='Czestotliwo��';
opt.YLabel.String={'Modu�' 'Faza'}
figure(5)
bode(P_wozek,opt)
legend('W�zek')

opt2=bodeoptions;
opt2.Title.String='Charakterystka bodego wahad�o';
opt2.Title.FontSize=14;
opt2.XLabel.String='Czestotliwo��';
opt2.YLabel.String={'Modu�' 'Faza'}
figure(6)
bode(P_wahadlo,opt2)
legend('Wahad�o')

figure(7)
nyquist(P_wozek)
title('Charakterystyka Nyquista dla w�zka');
xlabel('O� rzeczywista');
ylabel('O� urojona');


figure(8)
nyquist(P_wahadlo)
title('Charakterystyka Nyquista dla wahad�a');
xlabel('O� rzeczywista');
ylabel('O� urojona');

figure(9)
pzmap(P_wozek)
title('Mapa biegun�w i zer dla w�zka');
xlabel('O� rzeczywista');
ylabel('O� urojona');

figure(10)
pzmap(P_wahadlo)
title('Mapa biegun�w i zer dla wahad�a');
xlabel('O� rzeczywista');
ylabel('O� urojona');

kp=80;
ki=60;
kd=17;
reg=pid(kp,ki,kd)
G_z=feedback(P_wahadlo,reg) %uk�ad zamkni�ty
figure(11)
impulse(G_z,5) %czas 5s
title('Charakterystyka impulsowa  wahad�a');
xlabel('Czas');
ylabel('Wychylenie \phi [rad]');

G_w=series(feedback(1,reg*P_wahadlo),P_wozek);
figure(12)
impulse(G_w,5)
title('Charakterystyka impulsowa w�zka');
xlabel('Czas');
ylabel('Przemieszczenie x w [m]');

%%
% modelowanie

[licz,mian]=tfdata(P_wahadlo,'v')
[licz2,mian2]=tfdata(P_wozek,'v')

 for kd = 15 : 5 : 20
         for ki = 60 : 20 : 80
                 for kp = 80 : 10 : 90
                         sim('projekt3sim')
                         figure(13)
                         hold on;
                         plot(x1);
       title('Wykresy przemieszcze� w�zka');
       xlabel('Czas [s]');
       ylabel('Przemieszczenie x [m]');
                         figure(14)
                         hold on;
                         plot(phi1);
       title('Wykresy wychyle� wahad�a');
       xlabel('Czas [s]');
       ylabel('Wychylenie \phi [rad]');
                       
                 end;
                 end;
         end;
         
%% Kompensator lead-lag

%Okreslenie warto�ci zer i biegun�w kompensatora
z1 = -3; %zero dla k.lag
p1 = -4; %biegun dla k.lag // bli�ej zera p
z2 = -5; %zero dla k.lead //bli�ej zera z
p2 = -80 ; %biegun dla k.lead

komp=zpk([z1 z2], [p1 p2], 1)

figure(15) %linie pierwiastkowe dla uk�adu z kompensatorem
rlocus(komp*P_wahadlo)
title('Linie pierwiastkowe dla uk�adu z kompensatorem')
xlabel('O� rzeczywista');
ylabel('O� urojona');

%[k, poles]=rlocfind(komp*P_wahadlo) %wybor wartosci
k=1400;
sys_cl1=feedback(P_wahadlo,k*komp);%uk�ad zamkni�ty


figure(16)
impulse(sys_cl1);
title('Charakterystyka impulsowa wahad�a')
xlabel('Czas [s]');
ylabel('\phi [rad]');
grid on
figure(17)
pzmap(sys_cl1)
title('Mapa biegun�w i zer wahad�a');
xlabel('Rzeczywista');
ylabel('Urojona');
figure(18)
nyquist(sys_cl1)
title('Charakterystyka Nyquist-a wahad�a');
xlabel('Rzeczywista');
ylabel('Urojona');
axis([-0.01 0.03 -0.015 0.015])
opt3=bodeoptions;
opt3.Title.String='Charakterystka bodego wahad�a';
opt3.Title.FontSize=14;
opt3.XLabel.String='Czestotliwo��';
opt3.YLabel.String={'Modu�' 'Faza'};
figure(19)
bode(sys_cl1,opt3)

%sprawdzenie sterowalno�ci uk�adu
S = ctrb(sys_ss);%wyznaczenie macierzy sterowalno�ci
p =rank(S);
%regulator RQL
% Q = C'*C;
Q = [1500 0 0 0;0 0 0 0;0 0 1 0;0 0 0 0]

R = 1; %jedno wej�cie, jedna kolumna w macierzy B dlatego jedna liczba
F = -40 ; %kompensator
K = lqr(A,B,Q,R) %regulator
Ac = [(A-B*K)]; %zapisujemy uk�ad zamkni�ty
Bc = [B*F];
Cc = [C];
Dc = [D];

%stan = ('x' 'x_dot' 'phi' 'phi_dot)};
%we = ('r');
wy = {'x'; '\phi'};

%sys_cl = ss(Ac, Bc, Cc, Dc, 'statename', stan, 'inputname')
sys_cl = ss(Ac, Bc, Cc, Dc,'outputname', wy)

opt = stepDataOptions;
opt.StepAmplitude=0.2;

figure(20)
step(sys_cl,opt,7);
grid on;
title('Odpowied� skokowa dla uk�adu z regulatorem LQR');
xlabel('Czas')
ylabel('Amplituda')
grid on

