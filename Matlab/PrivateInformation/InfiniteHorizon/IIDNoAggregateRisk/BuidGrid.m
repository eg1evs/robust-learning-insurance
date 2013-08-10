function [ Para,Q] = BuidGrid(Para)

%% DEFINE FUNCTIONAL SPACE
beta=Para.beta;
c_offset=Para.c_offset;
pl=Para.pl;
ph=Para.ph;
theta_21=Para.Theta(2,1);
ra=Para.ra;
Delta=Para.Delta;
y=Para.y;
ComputeValueForSimpleContractAgent2=@(c) (1/(1-beta)) *(-theta_21.*log(pl(2).*exp(-u(y-c,ra)./theta_21)+ph(2).*exp(-u(y-c-Delta,ra)./theta_21)));
%ComputeValueForSimpleContractAgent2=@(c) (-theta_21.*log(pl(2).*exp(-u(y-c,ra)./theta_21)+ph(2).*exp(-u(y-c-Delta,ra)./theta_21)));
vMin=ComputeValueForSimpleContractAgent2(y-Delta-c_offset);
Para.vSuperMin=ComputeValueForSimpleContractAgent2(y-Delta);
Para.vSuperMax=ComputeValueForSimpleContractAgent2(0);
vMax=ComputeValueForSimpleContractAgent2(c_offset);
Para.vGrid=linspace(vMin,vMax,Para.vGridSize);
%cGrid=linspace(y-Delta-c_offset,c_offset,Para.vGridSize);
%Para.vGrid=ComputeValueForSimpleContractAgent2(cGrid);
Para.vGridSize=length(Para.vGrid);
Q = fundefn(Para.ApproxMethod,[Para.OrderOfAppx] , min(Para.vGrid),max(Para.vGrid));

end

