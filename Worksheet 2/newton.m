function [ new_x,x_history ] = newton( f,df,x0,tol,calling_function )
%NEWTON newton method for solving root equation numerically

new_x = x0;
%error at the beginning = inf
curr_error = inf;
x_history = new_x;

new_f_x = f(new_x);
new_df_x = df(new_x);

while( curr_error > tol && new_df_x~=0)
    
    old_x = new_x;
    old_f_x = new_f_x;
    old_df_x = new_df_x;
    
    %newton method fixpoint equation
    new_x = old_x - (  old_f_x / old_df_x );                    
    new_f_x = f(new_x);
    new_df_x=df(new_x);
    
    x_history = [x_history new_x];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % The usual convergence test has the following form : 
    %
    % if( abs(new_f_x)>abs(old_f_x) ) STOP
    % 
    % Here the absolute values are removed and the equation is reformulated
    % as a quotient in order to consider a sign change from old_f_x to
    % new_f_x. If a sign change happens, the absolute value of new_f_x
    % may be bigger than the absolute value of old_f_x, but still the
    % newton method converges. Example input:
    %
    % newton(@(x)1-x^2,@(x)-2*x,.1,10^-4,'')
    % 
    % For special examples this may of course lead to worse results.
    % Example input:
    %
    % newton(@(x)atan(x),@(x)1/(x^2+1),.4,10^-4,'') 
    % newton(@(x)atan(x),@(x)1/(x^2+1),1.6,10^-4,'') 
    %
    % Still for our purposes this method is sufficient.
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % check weather newton method does converge. 
    if( new_f_x/old_f_x > 1 )
        %calculate error via difference of approximate solution
        curr_error = abs( new_x - old_x );
        warning(['for ',calling_function,' at x = ',mat2str(new_x),...
            ' newton iteration does not converge! Given Tolerance of ',...
            mat2str(tol),' is not met. Error at this point: ',...
            mat2str(curr_error)]);
        
        %return old_x since it is better than new_x
        new_x=old_x;
        break;
    end
    
    %calculate error via difference of approximate solution
    curr_error = abs( new_x - old_x );
            
end

end

