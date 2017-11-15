function wrapFwdMap(pathOut,crit,frameRate,verbose)
% WRAPFWDMAP - estimate the forward kinematic map
% 
% input
%  PATHOUT - path to save output
%  CRIT - error tolerance for linear approx.
%  FRAMERATE - frame rate assuming two TR per frame
%  VERBOSE - controls output to MATLAB terminal
% 
% Last Updated: Oct. 13, 2016
% 
% Tanner Sorensen
% Signal Analysis and Interpretation Laboratory
% University of Southern California

% load task variables and weights for subjects SUBJ
load(fullfile(pathOut, '/contourdata.mat'))
load(fullfile(pathOut, '/gfa.mat'))
load(fullfile(pathOut, '/tv.mat'))

subj = fields(contourdata);
nDir = length(subj);

for h=1:nDir
    names = gfa.(subj{h}).names;
    [jawIndx,tngIndx,lipIndx,velIndx] = getIndxs(names);
    nf = sum([jawIndx tngIndx lipIndx velIndx]);
    nz = length(tv.(subj{h}).tv);
    nObs = length(tv.(subj{h}).tv{1}.cd);
    
    z=NaN(nObs,nz);
    for j=1:nz
        z(:,j) = tv.(subj{h}).tv{j}.cd;
    end
    w=gfa.(subj{h}).parameters(:,1:nf);
    [dzdt,dwdt] = getGrad(z,w,frameRate,contourdata.(subj{h}).File);
    
    disp(['Making forward map for subject ' subj{h}])
    
    % initialize
    Nobs = size(z,1);
    lib = {true(Nobs,1)};       % library has one cluster for whole data-set
    centers = zeros(0);         % center container
    fwd = cell(0);              % forward map container
    jac = cell(0);              % jacobian container
    jacDot = cell(0);           % time-derivative of jacobian container
    clusterInd = zeros(Nobs,1); % cluster membership indicator
    linInd = zeros(0);          % cluster linearity indicator

    % clustering parameters
    minSize = size(z,2)+1;      % minimum cluster size (no. elements)
    k = 2;                      % clusters break in two

    while ~isempty(lib)
        % pick out the next cluster
        curCluster = lib{1};

        % remove current cluster from library
        rem = cellfun(@(x) all(x==curCluster), lib);
        lib = lib(~rem);

        % do linearity test
        [linear,dzdw,resid] = linearityTest(z(curCluster,:), w(curCluster,:), crit, names);

        if linear
            % add center and jac to containers
            [centers,fwd,jac,jacDot,clusterInd,linInd] = addCluster(curCluster,dzdt,dwdt,z,w,dzdw,resid,centers,fwd,jac,jacDot,clusterInd,linInd,linear,names,verbose);
        else
            % break cluster into k smaller clusters
            [lib,centers,fwd,jac,jacDot,clusterInd,linInd] = breakCluster(curCluster,lib,dzdt,dwdt,z,w,k,minSize,centers,fwd,jac,jacDot,clusterInd,dzdw,resid,linInd,linear,names,verbose);
        end
    end

    % Diagnostic information
    fprintf(1,['\n*****\nNo. observed data-points: %d\n',...
        'Linearity criterion: %.2f\n',...
        'Minimum cluster size: %d\n',...
        'No. clusters: %d\n',...
        'No. clusters per observed data-point: %.3f\n',...
        'Percent of clusters which are linear: %.0f%%\n*****\n'],...
        Nobs, crit, minSize, size(centers,1), size(centers,1)/Nobs, 100*sum(linInd)/size(centers,1));
    
    clusters.(subj{h}).centers = centers;
    clusters.(subj{h}).fwd = fwd;
    clusters.(subj{h}).jac = jac;
    clusters.(subj{h}).jacDot = jacDot;
    clusters.(subj{h}).Nobs = Nobs;
    clusters.(subj{h}).crit = crit;
    clusters.(subj{h}).minSize = minSize;
    clusters.(subj{h}).nClusters = size(centers,1);
    clusters.(subj{h}).linear = linInd;
    clusters.(subj{h}).nLinClusters = sum(linInd);
end

save(fullfile(pathOut, 'clusters.mat'),'clusters')

end