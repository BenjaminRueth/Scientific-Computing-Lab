function [ t,y ] = implicit_euler( sym_f,y0,tau,T_end )
% numerical solution of ODE using implicit euler scheme
t=0:tau:T_end;
y=zeros(size(t));
y(1)=y0;

[G,dG]=derive_G_implicit_euler(sym_f,tau);
%G(y_{n+1},y_{n})=...
%dG/dy_{n+1}(y_{n+1},y_{n})=...
G
dG

for n = 1:(numel(y)-1)  
    current_G=@(x)G(x,y(n));
    current_dG=@(x)dG(x,y(n));
    y(n+1)=newton(current_G,current_dG,y(n),10^-4);    
end
end

