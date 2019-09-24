clear
load('income_tbls_1_2019.mat');
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

undepend_variables.test_table(13)=0;
undepend_variables.test(13)=0;

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
save('income_tbls_1_2019.mat','Mdl_nox','-append')
save('income_tbls_1_2019.mat','MdlDefault','-append')