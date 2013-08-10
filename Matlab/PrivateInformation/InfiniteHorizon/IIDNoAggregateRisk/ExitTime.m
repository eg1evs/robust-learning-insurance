if matlabpool('size')>0
matlabpool close force local
end
matlabpool open local

load (['Data/' Para.StoreFileName])
v0=linspace(domain(1)*1.001,domain(end)*.99,NumStarts);

ET=ones(NumStarts,2);

for n=1:NumPaths
tic
    parfor ctr=1:length(v0)
    rHist=rand(NumSim+1,1);
    
    SimData(ctr)=RunSimulationsUsingLinearInterpolation(v0(ctr),rHist,NumSim,domain,[ PolicyRulesStore LambdaStore' MuStore DistortedBeliefsAgent1Store DistortedBeliefsAgent2Store],Para);
    Tinf=find(SimData(ctr).vHist<Para.vSuperMin*1.001, 1 );
    if isempty(Tinf)
        Tinf=NumSim;
    end
    Tsup=find(SimData(ctr).vHist>Para.vSuperMax*.99, 1 );
    if isempty(Tsup)
        Tsup=NumSim;
    end
 T(ctr,:)=[Tinf Tsup ]
   
    end
toc
TSim(n).T=T;
ET=(ET*(n-1)+T)/n;
end
ET=ET/NumSim;

TT=[TSim.T];
ExitProbabilities=[sum((TT(:,1:2:end)<NumSim),2)./NumPaths sum((TT(:,2:2:end)<NumSim),2)./NumPaths];