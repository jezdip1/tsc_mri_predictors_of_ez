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

i=1;
for qi=find(undepend_variables.test==1)'


[RHOkend(i),PVALkend(i)] = corr([T.Resectedarea],T{:,qi},'type','Kendall','rows','pairwise');
[RHOspear(i),PVALspear(i)] = corr([T.Resectedarea],T{:,qi},'type','Kendall','rows','pairwise');


fprintf(1,'%s kendals tau=%0.2f p=%0.4f\n',T.Properties.VariableNames{qi},RHOkend(i),PVALkend(i))
fprintf(1,'%s spearmans rho=%0.2f p=%0.4f\n',T.Properties.VariableNames{qi},RHOspear(i),PVALspear(i))

i=i+1;
end

i=1;
for qi=find(undepend_variables.test_table==1)'


    [tbl,tchi2(i),tp(i),labels]=crosstab([T.Resectedarea],T{:,qi});
    [h,fp(i),stats]=fishertest(tbl);
%     if size(tbl,2)==1
%         tbl(:,2)=0;
%     end
%     if size(tbl,1)==1
%         tbl(2,:)=0;
%     end  
    ACC(i)=(tbl(1,1)+tbl(2,2))/sum(sum(tbl));
    BACC(i)=(tbl(1,1)/(tbl(1,1)+tbl(2,1))+tbl(2,2)/(tbl(2,2)+tbl(1,2)))/2;
        PPV(i)=(tbl(2,2))/(tbl(2,2)+tbl(1,2));
%         FDR(qqi,i)=(tbl(1,2))/(tbl(1,1)+tbl(1,2));
        FDR(i)=1-PPV(i);
% fprintf(1,'%s chi2test p=%0.4f\n',T.Properties.VariableNames{qi},tp(i))
% fprintf(1,'%s fishertest p=%0.4f\n',T.Properties.VariableNames{qi},fp(i))
fprintf(1,'%s\t%0.4f\t%0.4f\t%0.4f\t%0.4f\n',T.Properties.VariableNames{qi},ACC(i),BACC(i),PPV(i),FDR(i))
% fprintf(1,'%s Balanced Accuracy=%0.4f\n',T.Properties.VariableNames{qi},BACC(i))
% fprintf(1,'%s PPV=%0.4f\n',T.Properties.VariableNames{qi},PPV(i))
% fprintf(1,'%s FDR=%0.4f\n',T.Properties.VariableNames{qi},FDR(i))

i=i+1;
end


i=1;
for qi=find(undepend_variables.test_table==1)'


    [tbl,tchi2(i),tp(i),labels]=crosstab([T.Resectedarea],T{:,qi});
%     [h,fp(i),stats]=fishertest(tbl);
% %     if size(tbl,2)==1
% %         tbl(:,2)=0;
% %     end
% %     if size(tbl,1)==1
% %         tbl(2,:)=0;
% %     end  
%     ACC(i)=(tbl(1,1)+tbl(2,2))/sum(sum(tbl));
%     BACC(i)=(tbl(1,1)/(tbl(1,1)+tbl(2,1))+tbl(2,2)/(tbl(2,2)+tbl(1,2)))/2;
%         PPV(i)=(tbl(2,2))/(tbl(2,2)+tbl(1,2));
% %         FDR(qqi,i)=(tbl(1,2))/(tbl(1,1)+tbl(1,2));
%         FDR(i)=1-PPV(i);
% fprintf(1,'%s chi2test p=%0.4f\n',T.Properties.VariableNames{qi},tp(i))
% fprintf(1,'%s fishertest p=%0.4f\n',T.Properties.VariableNames{qi},fp(i))
fprintf(1,'%s\tTP=%d\tFP=%d\n\tFN=%d\tTN=%d\n',T.Properties.VariableNames{qi},tbl(2,2),tbl(1,2),tbl(2,1),tbl(1,1));
% fprintf(1,'%s Balanced Accuracy=%0.4f\n',T.Properties.VariableNames{qi},BACC(i))
% fprintf(1,'%s PPV=%0.4f\n',T.Properties.VariableNames{qi},PPV(i))
% fprintf(1,'%s FDR=%0.4f\n',T.Properties.VariableNames{qi},FDR(i))

i=i+1;
end
