clear all;
close all;

length_x = 1;
length_y = 1;



%continuous load
f=@(x,y)-2*pi^2*sin(pi*x).*sin(pi*y);
%discrete load
with_boundaries=0;

T_analytic=@(x,y)sin(pi*x).*sin(pi*y);


solutions = struct();
%the indeces are defining the solution methods:
index_full_matrix   = 1;
index_sparse_matrix	= 2;
index_gauss_seidl	= 3;

method_name={'FullMatrix','SparseMatrix','GaussSeidl'};

%Removed last grid size for testing purposes, as Gauss-Seidel takes forever
N_x = [7 15 31 63, 127];
N_y = [7 15 31 63, 127];
number_of_grid_sizes = numel(N_x);
fig_id =1;
storage = 0;

for method_id = [index_full_matrix, index_sparse_matrix]
    for current_grid_size = 1:number_of_grid_sizes
        current_N_x = N_x(current_grid_size);
        current_N_y = N_y(current_grid_size);
        b=build_solution_vector(current_N_x,current_N_y,f,with_boundaries);
        h_x = length_x/(current_N_x+1);
        h_y = length_y/(current_N_y+1);
        switch method_id
            case index_full_matrix
                tic;
                weights_matrix = build_weights_matrix(current_N_x,current_N_y);
                disp(['calculating T for N= ' mat2str(current_N_x) ', method: ' method_name{method_id}]);
                T = weights_matrix \ b;
                runtime = toc
                storage = numel(weights_matrix) + numel(T) + numel(b);
                disp('done!');
            case index_sparse_matrix
                tic;
                sparse_weights_matrix = build_sparse_weights_matrix(current_N_x,current_N_y);
                disp(['calculating T for N= ' mat2str(current_N_x) ', method: ' method_name{method_id}]);
                T = sparse_weights_matrix \ b;
                runtime = toc
                storage = 0;%nzn(sparse_weights_matrix) + numel(T) + numel(b);
                disp('done!');
            case index_gauss_seidl
                tic;
                disp(['calculating T for N= ' mat2str(current_N_x) ', method: ' method_name{method_id}]);
                T = solve_gauss_seidl(current_N_x,current_N_y, b);
                runtime = toc;
                storage = numel(b) + numel(T); %+5 for crosshairs_stencil
                disp('done!');
            otherwise 
                disp('No solution method specified for this method_id');
                break
        end   
        

        
        %visualize results

        %open figure
        figure(fig_id);
        hold on
        str_title = [method_name{method_id} '-Surface Plot: Temperatures for N_x = ' mat2str(current_N_x) ', N_y = ' mat2str(current_N_y)];
        title(str_title);


        %corresponding grid
        [x,y]=meshgrid([h_x:h_x:length_x-h_x],[h_y:h_y:length_y-h_y]);

        %convert solution from vector to matrix
        Z=zeros(current_N_y,current_N_x);
        for i = 1:numel(x)
            T_index=get_discrete_index(x(i),y(i),h_x,h_y,current_N_x,current_N_y,with_boundaries);
            Z(i)=T(T_index);
        end

        %calculate Error
        E=error_norm(Z,T_analytic(x,y));
        numel(Z)
        numel(T_analytic(x,y))
        
%         solutions.(method_name{method_id}).(['N_x' num2str(current_Nx)])=current_N_x;
%         solutions.(method_name{method_id}).(['N_y' num2str(current_Ny)])=current_N_y;
        solutions.(method_name{method_id}).(['N_x' num2str(current_N_x)]).runtime = runtime;
        solutions.(method_name{method_id}).(['N_x' num2str(current_N_x)]).storage = storage;
        solutions.(method_name{method_id}).(['N_x' num2str(current_N_x)]).error = E;
        
        %Add homogeneous boundary values
        Z=[zeros(1,current_N_x+2);zeros(current_N_y,1),Z,zeros(current_N_y,1);zeros(1,current_N_x+2)];
        %Create grid for plotting
        [X,Y]=meshgrid([0:h_x:length_x],[0:h_y:length_y]);
        [XX,YY]=meshgrid([0:.1:length_x],[0:.1:length_y]);

        surf(X,Y,Z,'FaceColor','interp')
        mesh(XX,YY,T_analytic(XX,YY),'FaceColor','none')
        xlabel('x')
        ylabel('y')
        hold off

        fig_id = fig_id + 1;

        figure(fig_id)
        hold on
        str_title = [method_name{method_id} '-Contour Plot: Temperatures for N_x = ' mat2str(current_N_x) ', N_y = ' mat2str(current_N_y)];
        title(str_title);
        contour(X,Y,Z)
        xlabel('x')
        ylabel('y')
        hold off

        fig_id = fig_id + 1;
            
        

    
                 

        
    end
    
    
    %To do:
%     -Calculate the error norm for all methods
%     -Printing of results into tabulars
%     -Maybe find a way to allocate/build sparse matrix
%     -Get storage requirement for sparse matrix
%     -Structure code into subsections a)...f)
%     -rearrange figures into subplots


end
