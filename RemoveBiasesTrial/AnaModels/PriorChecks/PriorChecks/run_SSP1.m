function simDat = run_SSP1(params,nTrials,maxRT)
maxRT = maxRT*1.2;

simDat(1:2,:) = struct('rt_res1',[],'rt_res0',[],'response',[]);
for iCong = 1:2
    trialData = spotlight(params,nTrials,iCong,maxRT);

    
    simDat(iCong,:).rt_res1 = trialData(trialData(:,2) == 1,1)*1000;
    simDat(iCong,:).rt_res0 = trialData(trialData(:,2) == 0,1)*1000;
    simDat(iCong,:).response = [ones(length(simDat(iCong,:).rt_res1),1); zeros(length(simDat(iCong,:).rt_res0),1) ];
end


    

    function trialData = spotlight(parms,nTrials,trialType,maxRT)
%%trialType: 1 = congruent, 2 = incongruent

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%set fixed parameters

  dt = .01;
  var = .1;

  sdRand = sqrt(dt * var); %%get standard deviation from variance

  %%get the free parameters from the numeric vector parms
    A = parms(1);
    B = -parms(1);
    tEr = parms(2);
    p_target = parms(3);
    rd = parms(4);
    sda = 2.5;

  %%set empty matrix to store trial data
  trialData = zeros(nTrials,2);
  
  maxSteps = maxRT /dt;


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    t = 1:maxSteps;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%start trial loop here

  for iTrial = 1:nTrials
%currEvidenceResp = zeros(1,length(t));

        %%calculate current sd of spotlight
        sd_t = sda - (rd * t);
        sd_t(sd_t <= 0.001) = .001; %%clip min sd to 0.001
         


      %%find area of spotlight over target and flanker
      %%:Rf_pnorm5(value, mean of dist., sd of dist., 1 = p<x, 0=log?)
      a_target = phi(.5./sd_t) - phi(-.5./sd_t);
      a_flanker = 1-a_target;
  %%      a_flanker = 2 * a_flanker;



        %%flip the sign if current trial is incongruent
        if trialType==2 
          p_flanker = -p_target;
        else
            p_flanker = p_target;
        end



      %%current drift rate
      drift = ((p_flanker .* a_flanker) .* dt) + ((p_target .* a_target) .* dt);
        %%drift = drift * dt;

        %%get random noise
       % RNGScope scope;
        noise = (randn(1,length(t)).*sdRand) + drift;

      %%update the response selection random walk
      currEvidenceResp = cumsum(noise);





    idx = find(currEvidenceResp >= A | currEvidenceResp <= B,1,'first');

    if ~isempty(idx)
    trialData(iTrial,1) = (idx * dt) + tEr;

    if currEvidenceResp(idx) >= A
        trialData(iTrial,2) = 1;
    elseif currEvidenceResp(idx) <= B
        trialData(iTrial,2) = 0;
    end
    

    else
        trialData(iTrial,1) = (maxSteps * dt) + tEr;

        trialData(iTrial,2) = 0;
    end



  end


  end
end
    