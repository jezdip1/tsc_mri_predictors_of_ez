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
T.No_of_abnormalities=sum(T{:,[8:12 14]},2);
T.No_of_abnormalities_incl_LFCDAA=sum(T{:,8:14},2);
T.No_of_abnormalities_excl_calc=sum(T{:,[8:11 13:14]},2);


XTENT=table;

T.mixture=(T.Calcification+T.LargestFCDarea+T.Tuber)>=2;
undepend_variables.names{16}='mixture';
undepend_variables.test(16)=1;
undepend_variables.test_table(16)=1;

% T(isnan(T.Calcification),:)=[];
%%
ids=unique(T.PtNo);
ResSize=[];
for ii=1:size(ids,1)
 i=1;
for qqi=find(undepend_variables.test_table==1)'
    PP=ids(ii);
    [RHOkend(i,ii),PVALkend(i,ii)] = corr([T.Resectedarea(T.PtNo==PP)],T{T.PtNo==PP,qqi},'type','Kendall');
    XTENT.resection(ii)=sum(T.Resectedarea(T.PtNo==PP));
    XTENT{ii,i+1}=sum(T{T.PtNo==PP,qqi});
    XTENT.Properties.VariableNames{i+1}=T.Properties.VariableNames{qqi};
    [tbl,tchi2,tp,labels]=crosstab([T.Resectedarea(T.PtNo==PP)],T{T.PtNo==PP,qqi});  
%     [tbl,chi2(i),p(i),labels]=crosstab([T.Resectedarea(T.PtNo==PP)],[T.GWMblurring(T.PtNo==PP)]);
    if size(tbl,2)==1
        tbl(:,2)=0;
    end
    if size(tbl,1)==1
        tbl(2,:)=0;
    end      
    if isempty(tbl)
        ACC(i,ii)=nan;
        PPV(i,ii)=nan;
        FDR(i,ii)=nan;
         
    else
        ACC(i,ii)=(tbl(1,1)+tbl(2,2))/sum(sum(tbl));
        PPV(i,ii)=(tbl(2,2))/(tbl(2,2)+tbl(1,2));
        FDR(i,ii)=1-(tbl(2,2))/(tbl(2,2)+tbl(1,2));
        
    end
     i=i+1;
end
end
% figure(1)
% boxplot([CARHOkend;THRHOkend;TRHOkend;GRHOkend;LRHOkend;CYRHOkend;TURHOkend;RHOkend;eRHOkend;KOMRHOkend]')
% ylim([-0.3 1.1])
% boxplot([CARHOkend;THRHOkend;TRHOkend;GRHOkend;LRHOkend;CYRHOkend;TURHOkend;RHOkend;KOMRHOkend]')

% figure(2)
% boxplot([CAPVALkend;THPVALkend;TPVALkend;GPVALkend;LPVALkend;CYPVALkend;TUPVALkend;PVALkend;ePVALkend;KOMPVALkend]')
% 
% figure(3)
% boxplot([GWchi2;TRchi2;THchi2;CYchi2;CAchi2;LAchi2;TUchi2]')
% figure(4)
% boxplot([GWp;TRp;THp;CYp;CAp;LAp;TUp]')
% figure(5)
% boxplot([GWACC;TRACC;THACC;CYACC;CAACC;LAACC;TUACC]')
% figure(6)
% boxplot([GWMCC;TRMCC;THMCC;CYMCC;CAMCC;LAMCC;TUMCC]')
% figure(7)
% boxplot([GWF1;TRF1;THF1;CYF1;CAF1;LAF1;TUF1]')

figure(1)
boxplot(PPV'*100)
xticklabels(T.Properties.VariableNames(find(undepend_variables.test_table)))
set(gca,'XTickLabelRotation',45)
ylim([0 110])
title({'Positive predictive value of single features for the resection';'across subjects, reviewer 1'})
grid on

figure(2)
boxplot(FDR'*100)
xticklabels(T.Properties.VariableNames(find(undepend_variables.test_table)))
set(gca,'XTickLabelRotation',45)
ylim([0 110])
title({'False discovery rates of single features for the resection';'across subjects, reviewer 1'})
grid on

figure(3)
boxplot(ACC'*100)
xticklabels(T.Properties.VariableNames(find(undepend_variables.test_table)))
set(gca,'XTickLabelRotation',45)
ylim([0 110])
title({'Accuracy of prediction the resection by single features';'across subjects, reviewer 1'})
grid on


figure(4)
boxplot(PVALkend')
xticklabels(T.Properties.VariableNames(find(undepend_variables.test_table)))
set(gca,'XTickLabelRotation',45)
ylim([0 1])
title({'Correlation';'across subjects, reviewer 1'})
grid on

