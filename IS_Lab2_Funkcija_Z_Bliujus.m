close all;
clear;
clc;
x = 0.1:1/22:1; %Taškų vektorius
func = ((1 + 0.6*sin(2*pi*x/0.7)) + 0.3*sin(2*pi*x))/2; %Aproksimuojama funkcija
figure
plot(x, func); grid on; title('Aproksimuojama funkcija');

%Pradines kintamuju vertes
N = 8; %Neuronu sk.
miu = 0.1; % mokymo zingsnis
%Vektoriu vietos atmintyje alokavimas
v1 = zeros(1, N); %Svorinės sumos neuronų įėjimuose
y1 = zeros(1, N); %Paslėptojo sluoksnio neuronų išėjimų vertės
w1 = zeros(1, N); %Įėjimo sluoksnio svoriai
w2 = zeros(1, N); %Paslėptojo sluoksnio neuronų išėjimų svoriai
b1 = zeros(1, N); %Paslėptojo sluoksnio neuronų bias
delta1 = zeros(1, N);
y2 = zeros(1, length(x)); %Išėjimo neurono verčių vektorius kiekvienai įėjimo vertei
b2 = rand(1); %Išėjimo sluoksnio neurono bias
sum_er1 = 0.11; %Kintamasis klaidos skaičiavimui pirmai mokymo iteracijai
m = 0; %Iteracijų skaičius

%Pradines koeficientu vertes
for i = 1:N
    w1(i) = randn(1);
    w2(i) = randn(1);
    b1(i) = randn(1);
end

%Iteraciju skaicius
 while sum_er1 >= 0.1 %Mokymas vyksta tol, kol bendra klaidos suma tarp atitinkamų funkcijos taškų ir aproksimacijos rezultato tampa lygi ar mažesnė nei 0.1
    m = m + 1;
% for m = 1:100000 %Mokymas vyksta nurodytą iteracijų skaičių
    %Kintamasis klaidos sumavimui
    sum_er1 = 0;
      %Isejimo skaiciavimas
    for j = 1:length(x)
      v2 = 0;
      for i = 1:N
        v1(i) = x(j)*w1(i) + b1(i);
        y1(i) = 1/(1+exp(-v1(i)));
        v2 = v2 + y1(i)*w2(i);
      end
      v2 = v2 + b2;
      y2(j) = v2;

      %Klaida
      er1 = func(j) - y2(j);
      sum_er1 = sum_er1 + abs(er1);
      %Koeficientu atnaujinimas isejimo sluoksniui
      delta2 = 1*er1; %Isejimo neurono aktyvavimo funkcija yra tiesee y = x, jos isvestine yra lygi 1
      for i = 1:N
        w2(i) = w2(i) + miu*delta2*y1(i);
      end
      b2 = b2 + miu*delta2;
      %Koeficientu atnaujinimas pasleptam sluoksniui
      for i = 1:N
        delta1(i) = y1(i)*(1-y1(i))*delta2*w2(i);
        w1(i) = w1(i) + miu*delta1(i)*x(j);
        b1(i) = b1(i) + miu*delta1(i);
      end
        sumj(m) = sum_er1;
    end
  
  end
  n = 1:m;
  figure
  plot(n, sumj); grid on; title('Sumines klaidos kitimas')
  figure
  plot(x, y2, x, func);grid on;  title('Funkcija ir jos aproksimacija'); legend('Aproksimacijos rezultatas', 'Pradine funkcija')


