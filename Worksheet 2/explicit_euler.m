function [ t,y,computation_time ] = explicit_euler(f,y0,tau,T_end)
% numerical solution of ODE using explicit euler scheme

tic;

t = 0:tau:T_end;
y = zeros(size(t));
y(1) = y0;

for n = 1:(numel(y)-1)    
    y(n+1) = y(n)+tau*f(y(n));    
end

computation_time = toc;

end