clear
load('income_tbls_3_2019.mat');
T=AllregionsincltubersSFv1712rev12019Marteen;


% T(isnan(T.Calcification),:)=[];
T.GWMblurring(T.GWMblurring==2)=nan;
T.Transmantle(T.Transmantle==2)=nan;
T.Increasedthickness(T.Increasedthickness==2)=nan;
T.Cysts(T.Cysts==2)=nan;
T.Calcification(T.Calcification==2)=nan;
T.LargestFCDarea(T.LargestFCDarea==2)=nan;
T.Tuber(T.Tuber==2)=nan;
T.No_of_abnormalities=sum(T{:,[8:12 14]},2,'omitnan');
T.No_of_abnormalities_incl_LFCDAA=sum(T{:,8:14},2,'omitnan');
T.No_of_abnormalities_excl_calc=sum(T{:,[8:11 13:14]},2,'omitnan');
% T(isnan(T.Calcification),:)=[];

TN=table;
pats=unique(T.PtNo);
e=size(T,2);
for i=1:size(pats,1)
    TT=T(T.PtNo==pats(i),:);
    for ii=1:22
        TN.neighbor_GWblurring(ii,1)=sum(TT.GWMblurring(N(:,ii)==1));
        TN.neighbor_Transmantle(ii,1)=sum(TT.Transmantle(N(:,ii)==1));
        TN.neighbor_Increasedthickness(ii,1)=sum(TT.Increasedthickness(N(:,ii)==1));
        TN.neighbor_Cysts(ii,1)=sum(TT.Cysts(N(:,ii)==1));
        TN.neighbor_Calcification(ii,1)=sum(TT.Calcification(N(:,ii)==1));
        TN.neighbor_LargestFCDarea(ii,1)=sum(TT.LargestFCDarea(N(:,ii)==1));
        TN.neighbor_Tuber(ii,1)=sum(TT.Tuber(N(:,ii)==1));
    end
    T(T.PtNo==pats(i),e+1:e+7)=TN;
end
T.Properties.VariableNames(e+1:e+7)=TN.Properties.VariableNames;

undepend_variables.test_table(13)=0;
undepend_variables.test(13)=0;
undepend_variables.test_table(12)=0;
undepend_variables.test(12)=0;


X=table;
i=1;
  for qi=find(undepend_variables.test_table==1)'
        
      X(:,i)=table(categorical(T{:,qi},[0,1],{'no','yes'})); 
      Varn{i}=T.Properties.VariableNames{qi};
    i=i+1;
  end
X.Properties.VariableNames=Varn;
Y=table(categorical(T.Resectedarea,[0,1],{'no','yes'}));

MdlDefault = fitctree(X,Y,'CrossVal','on','Kfold',15,'Surrogate','on');
numBranches = @(x)sum(x.IsBranch);
mdlDefaultNumSplits = cellfun(numBranches, MdlDefault.Trained);
figure(1);
histogram(mdlDefaultNumSplits)
kfoldLoss(MdlDefault)
% Mdl = fitctree(X,Y,'OptimizeHyperparameters','auto')
Mdl_nox = fitctree(X,Y);
save('income_tbls_3_2019.mat','Mdl_nox','-append')
save('income_tbls_3_2019.mat','MdlDefault','-append')