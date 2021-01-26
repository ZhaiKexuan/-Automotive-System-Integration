function [Jforce,Mforce,Jdispl,Mdispl] = solveTruss(joint,member,forceJ)

%   solveTruss solves planar truss problems. 
%   solveTruss calculates:
%
%       joint forces            member forces
%       joint displacements     member dispalcements
%
%[Jforce,Mforce,Jdispl,Mdispl] = solveTruss(joint,assembly,forceJ)
%
% INPUTS to solveTruss function
%           joint       = n x 2 matrix of joint coordinates
%
%           member      = m x 2 matrix of A-joints and B-joints. The 1st 
%                       and second columns of the j-th row are the A- and
%                       B-joints of the j-th member.
%
%           forceJ      = n x 3 matrix of joint loads at internal joints 
%                       and reactions at external joints. i-th row 
%                       corresponds to i-th joint. First column of ith row 
%                       indicates joint type.
%                       1) Let forceJ(i,1) = -1 when joint is internal. 
%                          Then let forceJ(i,2) = FX and forceJ(i,3) = FY
%                          where FX and FY are force loads in X and Y
%                          directions.
%                       2) Let forceJ(i,1) = 0 when joint is external with
%                          0 reactions. Then let forceJ(i,2) = 0 and 
%                          forceJ(i,3) = 0.
%                       3) Let forceJ(i,1) = 1 when joint is external with
%                          1 reaction. Then let forceJ(i,2) = NX and 
%                          forceJ(i,3) where NX and NY are the X and Y
%                          components of the unit vector in the direction
%                          of the reaction.
%                       4) Let forceJ(i,1) = 2 when joint is external with 
%                          2 reactions. Then set forceJ(i,2) and 
%                          forceJ(i,3) to 1.
%
% OUTPUTS
%           Jforce      = n x 2 matrix of joint forces. The ith row
%                       corresponds to ith joint. The 1st and 2nd columns
%                       are for X and Y force components.  
%
%           Mforce      = m x 1 vector of member forces.  
%                                                                     
%           Jdispl      = n x 2 matrix of joint displacements. The ith row
%                       corresponds to ith joint. The 2nd and 3rd columns
%                       are for X and Y displacement components.  
%
%           Mdispl      = m x 1 vector of member stretches.   
% 
% Note: This function has been adapted from Larry's Toolbox:
% https://www.mathworks.com/matlabcentral/fileexchange/12512-larry-s-toolbox

% Error Messages

% make sure the matrices have the right size
[n,nc] = size(joint);
[m,mc] = size(member);
[f,fc] = size(forceJ);
if (nc ~= 2)
    error('The joint input must have 2 columns');
end
if (mc ~= 2)
    error('The member input must have 2 columns');
end
if (fc ~= 3)
    error('The forceJ input must have 3 columns');
end
if (f ~= n)
    error('The joint and forceJ inputs must have the same number for rows');
end

% Initialize quantities
p0 = sum(forceJ(forceJ(:,1)>0,1));
N1 = 2*n; M1 = m+p0; N2 = p0+2*m; M2 = m+2*n;
b = zeros(1,N1); a = zeros(N1,M1);
d = zeros(N2,M2); e = zeros(N2,M1);
zero1 = zeros(N1,M2); zero2 = zeros(1,N2); 

% Calculate the member unit vectors.
distX = joint(member(:,2),1)-joint(member(:,1),1);
distY = joint(member(:,2),2)-joint(member(:,1),2);
L =  (distX.^2 + distY.^2).^0.5;
u = [distX, distY]./L;

% Calculate stretch stiffnesses
stretch= ones(m,1)*1e7;

% Calculate the m member displacement equations in [d]{u}+[e]{f}={0}.
d(1:m,1:m) = diag(ones(m,1));
e(1:m,1:m) = diag(-L./stretch);

% Calculate the 2n force equations in [a]{f}={b} and
% calculate the p joint displacement equations
% in [d]{u} + [e]{f} = {0}.  
for i = 1:n
    for j = 1:m
        i1 = 2*(i-1);
        for k = 1:2
            if member(j,k) == i
                for k1 = 1:2
                    a(i1+k1,j) = u(j,k1)*(3-2*k);
                end
            end
        end
    end
end
p = 0;
for i = 1:n
    i1 = 2*(i-1); j1 = m; i2 = m; j2 = m+2*(i-1);
    n1 = [forceJ(i,2),forceJ(i,3)];
    if forceJ(i,1) == 1
        p = p + 1;
        for k1 = 1:2
            a(i1+k1,j1+p) = n1(k1); d(i2+p,j2+k1) = n1(k1);
        end
    end
    if forceJ(i,1) == 2
        p = p + 1;
        a(i1+1,j1+p) = 1; d(i2+p,j2+1) = 1; p = p + 1;
        a(i1+2,j1+p) = 1; d(i2+p,j2+2) = 1;
    end
    if forceJ(i,1) == -1
        for k1 = 1:2
            b(i1+k1) = -1*forceJ(i,k1+1);
        end
    end
end
% Calculate the m member-joint displacement equations
% in [d]{u} + [e]{f} = {0}.
for j = 1:m
    iA = member(j,1); iB = member(j,2);
    i2 = m+p+j;
    j2A = m+2*(iA-1); j2B = m+2*(iB-1);
    d(i2,j) = 1;
    for k1 = 1:2
        d(i2,j2A+k1) = u(j,k1); d(i2,j2B+k1) = -u(j,k1);
    end
end

% Solve the force-displacement equations.
AA = [a,zero1;e,d]; 
BB = [b,zero2]';
if abs(det(AA)) < 1e-16
    warning('System may be only partially constrained.')
end
sol = AA\BB;

% Prepare the output quantities.
pp = 0;
for i = 1:n
    isol = 2*m+p+2*(i-1); 
    Jdispl(i,1) = sol(isol+1); 
    Jdispl(i,2) = sol(isol+2);
end
for i = 1:n
    switch forceJ(i,1)
        case 0
            Jforce(i,1) = 0;
            Jforce(i,2) = 0;
        case 1
            pp = pp + 1;
            Jforce(i,1) = sol(m+pp)*forceJ(i,2); 
            Jforce(i,2) = sol(m+pp)*forceJ(i,3);
        case 2
            pp = pp + 1; Jforce(i,1) = sol(m+pp);
            pp = pp + 1; Jforce(i,2) = sol(m+pp);
        case -1
            Jforce(i,1) = forceJ(i,1); 
            Jforce(i,2) = forceJ(i,3);
        otherwise
            error('The first column of forceJ must be -1, 0, 1, or 2');
    end
end
Mforce = sol(1:m);
Mdispl = sol((m+p+1):(m+p+m));
