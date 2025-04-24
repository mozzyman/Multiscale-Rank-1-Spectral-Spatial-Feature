function [x] = Skomp(mappedTrains, mappedAy,group, M)
% compute k-sparse approximation to b with matrix A using Matching pursuit
N = size(mappedTrains,1);
x = zeros([N,group]);
support = []; % empty support
% corr = sum(abs(mappedAy),2);
corr = max(abs(mappedAy),[],2);

for i=1:M
    % compute correlation between residual and columns of A
    corr = max(abs(corr),[],2);
    [h, n] = max(corr);
    
    % extend the support
    support(end+1) = n;
    % update the representation
%     x(support) =  pinv( mappedTrains(support,support)) * mappedAy(support);
    x(support,:) = inv(mappedTrains(support,support)+ 10^-5 * eye(size(mappedTrains(support,support)))) * mappedAy(support,:);
    
    % update the residual
    corr = abs(mappedAy  -  mappedTrains(:,support) * x(support,:));
%     corr = sum(corr,2);
    
end

