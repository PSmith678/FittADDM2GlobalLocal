function Nmodel = createAllModels()



i = 1;
Nmodel{i}.docu = 'three-parameter DDM using dm-tool';
Nmodel{i}.nid = i;
% needs to match the run_xxxx-mfile
Nmodel{i}.name= 'ADDM';

Nmodel{i}.variable2condition= [0.0070    0.0030  ];
%       (1) boundary separation (a)
%       (2) mean of the rectangular nondecision time distribution (Ter)
%       (3) standard deviation of the gaussian drift rate distribution
%       (eta)
%       (4) mean of the gaussian drift rate distribution (v)
Nmodel{i}.variableName = {'a','Terr', 'v'};
Nmodel{i}.fixedPara = [0.25];

i = 2;
Nmodel{i}.docu = 'three-parameter DDM using simulation';
Nmodel{i}.nid = i;
% needs to match the run_xxxx-mfile
Nmodel{i}.name= 'ADDM';

Nmodel{i}.variable2condition= [0.0070    0.0030  ];
%       (1) boundary separation (a)
%       (2) mean of the rectangular nondecision time distribution (Ter)
%       (3) standard deviation of the gaussian drift rate distribution
%       (eta)
%       (4) mean of the gaussian drift rate distribution (v)
Nmodel{i}.variableName = {'a','Terr', 'v'};
Nmodel{i}.fixedPara = [0.25];

end