function plotresults(geom,axialvariations,optim)
%%
x=axialvariations.x*1000;yi=geom.yi*1000;yo=geom.yo*1000;
M=axialvariations.M;T=axialvariations.T;
Taw=axialvariations.Taw;
P=axialvariations.P/101325;
rho=axialvariations.rho;
Twg=axialvariations.Twg;
Two=axialvariations.Two;
q=axialvariations.q/1000;
hg=axialvariations.hg/1000;
%%
figure;
plot(optim.ofr,optim.tf);xlabel('Oxidizer to Fuel ratio');
ylabel('Combustion Temperature, K');grid on;
figure;plot(optim.ofr,optim.isp);xlabel('Oxidizer to Fuel ratio');
ylabel('Specific Impulse, sec');grid on;
%%
figure;
subplot(5,1,1);
plot(geom.x*1000,yi,'k',geom.x*1000,yo,'k');grid on;
title('Nozzle Countour');
subplot(5,1,2);plot(x,M);grid on;ylabel('Mach No');
subplot(5,1,3);plot(x,T,x,Taw);grid on;axis tight;
ylabel('T (K)');legend('Static Temp, T_c_e_n_t_e_r',...
    'Near Wall Temp, T_w_a','location','best');
subplot(5,1,4);plot(x,P);grid on;
ylabel('P (bar)');
subplot(5,1,5);plot(x,rho);grid on;
ylabel('\rho (kg/m^3)');
%%
%%
figure;
subplot(4,1,1);
plot(geom.x*1000,yi,'k',geom.x*1000,yo,'k');grid on;
title('Nozzle Countour');axis tight;
subplot(4,1,2);plot(x,Taw,'r',x,Twg,'g',x,Two,'b');
grid on;axis tight;axis tight;
ylabel('T (K)');legend('Near Wall Gas, T_a_w',...
    'Inner Wall Temp, T_w_g','Outer Wall Temp, T_w_o','location','best');
subplot(4,1,3);plot(x,q);grid on;axis tight;
ylabel('Flux (KW/m^2)');
subplot(4,1,4);plot(x,hg);grid on;axis tight;
ylabel('h_g  (KW/m^2/K)');