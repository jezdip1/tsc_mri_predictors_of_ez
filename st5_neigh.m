clear
load('income_tbls_1_2019.mat');
% T=AllregionsincltubersSFv1712rev12019Marteen;
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
T.No_of_abnormalities_mixed_threshold=sum(T{:,7+[1 6 7]},2,'omitnan')>=2;
undepend_variables.names(end+1)={'No_of_abnormalities_mixed_threshold'};
undepend_variables.test(end)=1;
% T(isnan(T.Calcification),:)=[];

%%
X=table;
i=1;
  for qi=find(undepend_variables.test_table==1)'
        
      X(:,i)=table(categorical(T{:,qi},[0,1],{'no','yes'})); 
      Varn{i}=T.Properties.VariableNames{qi};
    i=i+1;
  end
X.Properties.VariableNames=Varn;
Y=table(categorical(T.Resectedarea,[0,1],{'no','yes'}));
YP = predict(Mdl_nox,X);
YPN=double(YP=='yes');
%%
XX=table;
i=1;
  for qi=find(undepend_variables.test_table==1)'
        
      XX(:,i)=table(T{:,qi}+1); 
      Varn{i}=T.Properties.VariableNames{qi};
    i=i+1;
  end
 XX.Properties.VariableNames=Varn; 
for ii=1:size(MdlDefault.Trained,1)
    
YPT(:,ii) = predict(MdlDefault.Trained{ii},XX);

end
YPTN=array2table(double(YPT=='yes'));

%%
ids=unique(T.PtNo);

for qqi=1:size(ids,1)
    PP=ids(qqi);
    maxnumber_of_features_in_region(qqi)=max(sum(T{(T.PtNo==PP),find(undepend_variables.test_table)'},2,'omitnan'));
    T.No_of_abnormalities_incl_LFCDAA_normalised(T.PtNo==PP)=T.No_of_abnormalities_incl_LFCDAA(T.PtNo==PP)/maxnumber_of_features_in_region(qqi);
end
undepend_variables.names(end+1)={'No_of_abnormalities_incl_LFCDAA_normalised'};
undepend_variables.test(end)=1;
undepend_variables.names(end+1)={'YP'};
undepend_variables.test(end)=1;
undepend_variables.test_table(end)=1;
T.YP=YPN;
T=[T YPTN];
undepend_variables.test(end+1:end+15)=1;
undepend_variables.test_table(end-15:end)=1;
%%

ids=unique(T.PtNo);
ResSize=[];
for qqi=1:size(ids,1)
    PP=ids(qqi);
    i=1;
    for qi=find(undepend_variables.test==1)'


        [RHOkend(qqi,i)] = corr([T.Resectedarea(T.PtNo==PP)],T{(T.PtNo==PP),qi},'type','Kendall','rows','pairwise');
        if ~isnan (RHOkend(qqi,i))
            [RHOkend(qqi,i),PVALkend(qqi,i)] = corr([T.Resectedarea(T.PtNo==PP)],T{(T.PtNo==PP),qi},'type','Kendall','rows','pairwise');
        else
            PVALkend(qqi,i)=nan;
        end
        [RHOspear(qqi,i)] = corr([T.Resectedarea(T.PtNo==PP)],T{(T.PtNo==PP),qi},'type','Kendall','rows','pairwise');
        if ~isnan (RHOspear(qqi,i))
            [RHOkend(qqi,i),PVALspear(qqi,i)] = corr([T.Resectedarea(T.PtNo==PP)],T{(T.PtNo==PP),qi},'type','Kendall','rows','pairwise');
        else
            PVALspear(qqi,i)=nan;
        end


        % fprintf(1,'%s kendals tau=%0.2f p=%0.4f\n',T.Properties.VariableNames{qi},RHOkend(i),PVALkend(i))
        % fprintf(1,'%s spearmans rho=%0.2f p=%0.4f\n',T.Properties.VariableNames{qi},RHOspear(i),PVALspear(i))

        i=i+1;
    end

    i=1;
    for qi=find(undepend_variables.test_table==1)'


        [tbl,tchi2(qqi,i),tp(qqi,i),labels]=crosstab([T.Resectedarea(T.PtNo==PP)],T{(T.PtNo==PP),qi});
        if isempty(tbl)
            tbl=zeros(2);
        end
        if size(tbl,2)==1
            tbl(:,2)=0;
        end
        if size(tbl,1)==1
            tbl(2,:)=0;
        end
        [h,fp(qqi,i),stats]=fishertest(tbl);
        ACC(qqi,i)=(tbl(1,1)+tbl(2,2))/sum(sum(tbl));
        PPV(qqi,i)=(tbl(1,1))/(tbl(1,1)+tbl(1,2));
        FDR(qqi,i)=(tbl(1,2))/(tbl(1,1)+tbl(1,2));

    % fprintf(1,'%s chi2test p=%0.4f\n',T.Properties.VariableNames{qi},tp(i))
    % fprintf(1,'%s fishertest p=%0.4f\n',T.Properties.VariableNames{qi},fp(i))
    % fprintf(1,'%s Accuracy=%0.4f\n',T.Properties.VariableNames{qi},ACC(i))

    i=i+1;
    end

    
    
    [COMBRHOkend(qqi),COMBPVALkend(qqi)] = corr([T.Resectedarea(T.PtNo==PP)],T.No_of_abnormalities_incl_LFCDAA(T.PtNo==PP)/maxnumber_of_features_in_region(qqi),'type','Kendall','rows','pairwise');
end
    figure(3)
    imagesc(PVALkend<0.05)
    figure(4)
    imagesc(RHOkend)
    figure(5)
    imagesc(fp<0.05)    
    figure(6)
    imagesc(tp<0.05)        