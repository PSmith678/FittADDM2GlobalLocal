function calcMAP(uid)
    
    
    out = calcMAPInd(uid,[],[2500 1]);
docu1 = load_docufile(uid);

for c = 1:length(docu1.post.res)
    docu1.post.res(c).map = out(c,:);
    save_docufile(docu1);
end


    
    function [param, max_val]=calcMAPInd(uid, folder, post_sampling)

% Load in docufile
if isnumeric(uid)
    if ~isempty(folder)
        h(length(uid)) = struct('docudir', [], 'uid', []);
        
        h.docudir = folder;
        h.uid = uid;
        
        uid = h;
    end
    docu = load_docufile(uid);
else
    docu = uid;    
end


% Return error if there are no posterior results.
if isempty(docu.post.res)
    error('no posterior results in docu-file');
end


if docu.data.selector.multiFits == 1    
    nMulti = length(docu.post.res);
    [~,~,nParam] = size(docu.post.res(1).posterior);
    param = nan(nMulti,nParam);
    max_val = nan(1,nMulti);
else
    [~,~,nParam] = size(docu.post.res(1).posterior);
    param = nan(1,nParam);
    max_val = nan(1,1);
end

    




SAMPLE_SIZE = 10000;
if docu.data.selector.multiFits == 1

    % for iMulti = 1:conditions...
    for iMulti=1:nMulti
        
        % Get posterior
        [~,post] = subsamplePosterior(docu.post.res(iMulti).posterior,post_sampling);
        
        % taken from quickStart_oKDE
        if 2*nParam > 20
            initSampleSize = 2*nParam;
        else
            initSampleSize = 20;
        end
        
        nSamples = length(post);
       % stepSize = floor(nSamples/initSampleSize);
        kdePdf = [];
        
        idx = randperm(nSamples,initSampleSize);
        kdePdf = executeOperatorIKDE( kdePdf, 'input_data', post(:,idx),'add_input' );
        post(:,idx) = [];
        
        
        while ~isempty(post)
            nSamples = length(post);
            %            kdePdf1 = executeOperatorIKDE( kdePdf, 'compressionClusterThresh', 0.02 ) ;
            %            [param1, max_val] = findGlobalMaximum( kdePdf1.pdf )
            
            if  nSamples > SAMPLE_SIZE
                idx = randperm(nSamples,SAMPLE_SIZE);
            else
                idx = randperm(nSamples);
            end
            
            kdePdf = executeOperatorIKDE( kdePdf, 'input_data', post(:,idx),'add_input' );
            post(:,idx) = [];
            
        end
        kdePdf = executeOperatorIKDE( kdePdf, 'compressionClusterThresh', 0.02 ) ;
        
        %        kdePdf = quickStart_oKDE(post, 0.2, []);
        [param(iMulti,:), max_val(iMulti)] = findGlobalMaximum( kdePdf.pdf );
    end
else
    [~,post] = subsamplePosterior(docu.res.posterior,post_sampling);
    % taken from quickStart_oKDE
    if 2*nParam > 20
        initSampleSize = 2*nParam;
    else
        initSampleSize = 20;
    end
    
    nSamples = length(post);
    stepSize = floor(nSamples/initSampleSize);
    kdePdf = [];
    
    idx = randperm(nSamples,initSampleSize);
    kdePdf = executeOperatorIKDE( kdePdf, 'input_data', post(:,idx),'add_input' );
    post(:,idx) = [];
    
    
    while ~isempty(post)
        nSamples = length(post);
        %            kdePdf1 = executeOperatorIKDE( kdePdf, 'compressionClusterThresh', 0.02 ) ;
        %            [param1, max_val] = findGlobalMaximum( kdePdf1.pdf )
        
        if  nSamples > SAMPLE_SIZE
            idx = randperm(nSamples,SAMPLE_SIZE);
        else
            idx = randperm(nSamples);
        end
        
        kdePdf = executeOperatorIKDE( kdePdf, 'input_data', post(:,idx),'add_input' );
        post(:,idx) = [];
        
    end
    
    kdePdf = executeOperatorIKDE( kdePdf, 'compressionClusterThresh', 0.02 ) ;
    [param, max_val] = findGlobalMaximum( kdePdf );
end











function [subpost,post] = subsamplePosterior(posterior,post_sampling, seed)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if length(post_sampling) == 1
    sampling_cutoff = post_sampling;
    step_size = 1;
else
    sampling_cutoff = post_sampling(1);
    step_size = post_sampling(2);
end


if exist('seed')
    rng(seed);
end

[~, ~, nParameter] = size(posterior);


for j=1:nParameter
    post1 = squeeze(posterior(:,:,j));
    post11 = post1(end-sampling_cutoff:step_size:end,:);
    post12 = post11(:);
    post(j,:) = post12;
end
for iParameter=1:nParameter
    choice = randperm(length(squeeze(post(iParameter,:))),floor(length(squeeze(post(iParameter,:)))/100));
    subpost(iParameter,:) = post(iParameter,choice);
end

end
end

end

