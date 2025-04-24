function [corr] = fxkernel(gamma, D1,D2)

if nargin > 2
    
    n1sq = sum(D1.^2,1);
    n1 = size(D1,2);
    n2sq = sum(D2.^2,1);
    n2 = size(D2,2);
%     n1sq = D1'*D1;
%     n2sq = D2'* D2;
    c = (ones(n2,1)*n1sq)' + ones(n1,1)*n2sq -2*(D1'*D2);
%     c = n1sq + n2sq - 2*(D1'*D2);
   
    
   
else
    c = sum((D1-D1).^2,1);
end
    corr = exp(-gamma*c);

end

