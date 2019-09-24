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

B=(T{:,[8:14]});
Y=T{:,5};
PS=nchoosek([1:7],3);
RHOkend=[];
PVALkend=[];
HITS=[];
R=[];
for qi=1:size (PS,1)
    NN=sum(B(:,PS(qi,:)),2,'omitnan')>=2;
    R(qi)=corr(Y,NN,'type','Kendall','rows','pairwise');


        ids=unique(T.PtNo);
        ResSize=[];
        for i=1:size(ids,1)    
          PP=ids(i);
            MM(i)=max(sum(B(T.PtNo==PP,PS(qi,:)),2,'omitnan'));
            [RHOkend(qi,i),PVALkend(qi,i)] = corr([T.Resectedarea(T.PtNo==PP)],NN(T.PtNo==PP),'type','Kendall','rows','pairwise');
            HITS(qi,i)=sum(double(NN(T.PtNo==PP)).*T.Resectedarea(T.PtNo==PP))>0;
        
        end    
    SN(qi)=sum(NN);
end
figure (1)
boxplot(RHOkend')
figure (2)
boxplot(PVALkend')
SHITS=(sum(HITS,2));
max(R)