clear;
close all;
clc;
%Įėjimo taškų vektoriai
n1 = 0:1/40:2;
n2 = 0:1/40:2;
[x1, x2] = meshgrid(n1, n2);
%Aproksimuojamas paviršius
pavirsius = x1.^2 - x2.^2;
figure
surf(x1, x2, pavirsius); title('Aproksimuojamas pavirsius - hiperbolinis paraboloidas');

%Pradines kintamuju vertes
N = 8; %Neuronu sk.
miu = 0.1; % mokymo zingsnis
%Vektoriu vietos atmintyje alokavimas
v11 = zeros(1, N); %Pirmo įėjimo paslėpto sluoksnio svorinės sumos neuronų įėjimuose 
v12 = zeros(1, N); %Antro įėjimo paslėpto sluoksnio svorinės sumos neuronų įėjimuose 
y1 = zeros(1, N); %Paslėpto sluoksnio neuronų išėjimų vektorius
w11 = zeros(1, N); %Pirmo įėjimo svoriai
w12 = zeros(1, N); %Antro įėjimo svoriai
w21 = zeros(1, N); %Paslėpto sluoksnio išėjimo svoriai
b1 = zeros(1, N); %Paslėpto sluoksnio leuronų bias
%sum_er1 = rand(1);
delta11 = zeros(1, N); %Back propagation gradientų vektorius
y2 = zeros(length(pavirsius), length(pavirsius)); %Išėjimo neurono verčių matrica
klaida = zeros(length(pavirsius), length(pavirsius), 10); %Klaidos matrica kiekvienam paviršiaus taškui
sum_klaida=zeros(1, 500); %Vienos iteracijos visų taškų suminės klaidos vektorius
b2 = rand(1); %Išėjimo neurono bias

%Pradines koeficientu vertes
for i = 1:N
    w11(i) = randn(1);
    w12(i) = randn(1);
    w21(i) = randn(1);
    b1(i) = randn(1);
end
 
%Daugiasluoksnio perceptrono mokymas
for m = 1:500  %Iteraciju skaicius
 %Kintamasis klaidos sumavimui
 sum_klaida(m) = 0;
 %Isejimo skaiciavimas
 for j = 1:length(x1)
     for k = 1:length(x2)
       v2 = 0;
       for i = 1:N
         v11(i) = x1(j, k)*w11(i) + x2(j, k)*w12(i) + b1(i);
         y1(i) = 1/(1+exp(-v11(i)));
         v2 = v2 + y1(i)*w21(i);
       end
       v2 = v2 + b2;
       y2(j,k) = v2;

       %Klaida
       err = pavirsius(j, k) - y2(j, k);
       sum_klaida(m) = sum_klaida(m) + abs(err);      
       %Koeficientų atnaujinimas išėjimo sluoksniui
       delta2 = 1*err; %Išėjime naudojama tiesinė funkcija 
       for i = 1:N
         w21(i) = w21(i) + miu*delta2*y1(i);
       end
       b2 = b2 + miu*delta2;
       %Koeficientu atnaujinimas paslėptam sluoksniui
       for i = 1:N
         delta11(i) = y1(i)*(1-y1(i))*delta2*w21(i);
         w11(i) = w11(i) + miu*delta11(i)*x1(j, k);
         w12(i) = w12(i) + miu*delta11(i)*x2(j, k);            
         b1(i) = b1(i) + miu*delta11(i);
       end            
     end
 end    
end

%Rezultatų atvaizdavimas
figure
surf(x1, x2, y2); title('Aproksimacijos rezultatas'); 
figure
surf(x1, x2, y2, 'FaceColor','b');
hold on
surf(x1, x2, pavirsius, 'FaceColor','g'); title('Pavirsiu palyginimas'); legend('Aproksimacijos rezultatas', 'Aproksimuojamas pavirsius')
hold off
figure
n = 1:m;
plot(n, sum_klaida); title('Klaidos kitimas'); grid;
  
