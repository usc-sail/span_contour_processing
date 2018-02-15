function nClusters = clusterSummary(datPath)
% clusterSummary - summarizes the clusters of the forward maps

load([datPath 'clusters.mat'])

subj = fields(clusters);
nDir = length(subj);

nClusters = zeros(1,nDir);
for h=1:nDir
    nClusters(h) = size(clusters.(subj{h}).centers,1);
end

end