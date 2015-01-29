function [Q, R]=QRD(A,q,q2)
%
%   usage :  [Q, R]=QRD(A,q)
%
%   input       A       - Matrix to descomp.
%               q       - Quantizer object ( m bits )
%               q2      - Quantizer object ( 2m bits)
%
%   output      Q       - Q matrix
%               R       - R matrix
%
%

arc1=fopen('qrd.txt','wt');

fprintf(arc1,'QRD DEBUG QUANTIZER\n\n');

[m n] = size(A);

R=zeros(n,n);
Q=zeros(m,n);

R_q=zeros(n,n);
Q_q=zeros(m,n);

t=A;
t_q=A;

for i=1:n
    
    A(:,i)
    
    fprintf(arc1,'Column i = %f ============================ \n\n',i);
     
	t2 = t(:,i)'*t(:,i);
	fprintf(arc1,'t2 = %f\n',t2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUANTIZER %%%%%%%%%%%%%%%%%%%%%%%%%%%% q2
    
    t2_q = quantnum(t_q(:,i)'*t_q(:,i),q2); 
    
    [t2 t_q(:,i)'*t_q(:,i) t2_q]
    disp(strcat('columna ',num2str(i)))
    pause
    
    fprintf(arc1,'t2_q = %f\n\n',t2_q);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    R(i,i) = sqrt(t2);
    fprintf(arc1,'Rii = %f\n',R(i,i));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUANTIZER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    R_q(i,i) = quantnum(sqrt(t2_q),q);
    fprintf(arc1,'Rii_q = %f\n\n',R_q(i,i));
    
    [t(:,i) t_q(:,i)]
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Vector columna Qi
	Q(:,i)= t(:,i) / R(i,i);
    %fprintf(arc1,'Q(:,i) = %f ',R(i,i));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUANTIZER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Q_q(:,i) = quantnum(t_q(:,i)/R_q(i,i),q);
    
    disp(strcat('columna ',num2str(i)))
    
   % [Q(:,i) Q_q(:,i) 100*abs(Q(:,i)-Q_q(:,i))./abs(Q(:,i)) t(:,i)...
  %      t_q(:,i) ones(m,1)*R(i,i) ones(m,1)*R_q(i,i)]
    
    
    %pause
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for j=i+1:n
        
        fprintf(arc1,'i = %f , j = %f\n\n',i,j);
        
        
       
        R(i,j) = Q(:,i)'*t(:,j);
        fprintf(arc1,'R(i,j) = %f\n',R(i,j));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUANTIZER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        R_q(i,j) = quantnum(Q_q(:,i)'*t_q(:,j),q);
        fprintf(arc1,'R(i,j)_q = %f\n\n',R_q(i,j));
	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        temp = R(i,j)*Q(:,i);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUANTIZER %%%%%%%%%%%%%%%%%%%%%% q2 
        temp_q = quantnum(2^8*R(i,j)*Q(:,i),q);

	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        t(:,j) = t(:,j)-temp;
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUANTIZER %%%%%%%%%%%%%%%%%%%%%%% q2
        [t_q(:,j)-temp_q]
        
        t_q(:,j) = (quantnum(2^8*t_q(:,j)-temp_q,q))/2^8;

	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %disp(strcat('columna  j ',num2str(j)))
        % disp(sprintf('columna i = %f   updata col j = %f',i,j)) 
        %[t(:,j) t_q(:,j) temp temp_q ]
        % disp(sprintf('columna i = %f   updata col j = %f',i,j)) 
        % pause
         
    end
	
end

% %Q
% pause
% Q_q
% pause
% Q-Q_q
% pause
% R
% pause
% R_q
% pause
% R-R_q
% pause

Q=Q_q;
R=R_q;
fclose(arc1)

        
        
        
        
    
    
    