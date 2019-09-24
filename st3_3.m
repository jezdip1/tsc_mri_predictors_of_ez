clear
% load('income_tbls_3_2019.mat');
% % T=AllregionsincltubersSFv1712rev12019Martin;
% % T(isnan(T.Calcification),:)=[];
% T.GWMblurring(T.GWMblurring==2)=nan;
% T.Transmantle(T.Transmantle==2)=nan;
% T.Increasedthickness(T.Increasedthickness==2)=nan;
% T.Cysts(T.Cysts==2)=nan;
% T.Calcification(T.Calcification==2)=nan;
% T.LargestFCDarea(T.LargestFCDarea==2)=nan;
% T.Tuber(T.Tuber==2)=nan;
% T.No_of_abnormalities=sum(T{:,[8:12 14]},2,'omitnan');
% T.No_of_abnormalities_incl_LFCDAA=sum(T{:,8:14},2,'omitnan');
% T.No_of_abnormalities_excl_calc=sum(T{:,[8:11 13:14]},2,'omitnan');
% T(isnan(T.Calcification),:)=[];

clear
load('income_tbls_3_2019.mat');
T=AllregionsincltubersSFv1712rev12019Martin;


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
        TN.neighbor_GWblurring(ii,1)=sum(TT.GWMblurring(N(:,ii)==1))>0;
        TN.neighbor_Transmantle(ii,1)=sum(TT.Transmantle(N(:,ii)==1))>0;
        TN.neighbor_Increasedthickness(ii,1)=sum(TT.Increasedthickness(N(:,ii)==1))>0;
        TN.neighbor_Cysts(ii,1)=sum(TT.Cysts(N(:,ii)==1))>0;
        TN.neighbor_Calcification(ii,1)=sum(TT.Calcification(N(:,ii)==1))>0;
        TN.neighbor_LargestFCDarea(ii,1)=sum(TT.LargestFCDarea(N(:,ii)==1))>0;
        TN.neighbor_Tuber(ii,1)=sum(TT.Tuber(N(:,ii)==1))>0;
    end
    T(T.PtNo==pats(i),e+1:e+7)=TN;
end
T.Properties.VariableNames(e+1:e+7)=TN.Properties.VariableNames;

%%
SHA=[];
for bb=1:5
    fprintf(1,'choose %d\n',bb);
    for cc=1:5
        B=(T{:,[8:14,16:22]});
%         B=(T{:,[8:14,16:17]});
        Y=T{:,5};
        PS=nchoosek([1:14],bb);
        RHOkend=[];
        PVALkend=[];
        HITS=[];
        for qi=1:size (PS,1)
            NN=sum(B(:,PS(qi,:)),2,'omitnan')>=cc;
%             R(qi)=corr(Y,NN,'rows','pairwise');


                ids=unique(T.PtNo);
                ResSize=[];
                for i=1:size(ids,1)    
                  PP=ids(i);
%                     [RHOkend(qi,i),PVALkend(qi,i)] = corr([T.Resectedarea(T.PtNo==PP)],NN(T.PtNo==PP),'type','Kendall','rows','pairwise');
                    HITS(qi,i)=sum(double(NN(T.PtNo==PP)).*T.Resectedarea(T.PtNo==PP))>0;
                    [tbl,tchi2,tp,labels]=crosstab([T.Resectedarea(T.PtNo==PP)],double(NN(T.PtNo==PP)));   
                    
                   if size(tbl,2)==1
                        tbl(:,2)=0;
                    end
                    if size(tbl,1)==1
                        tbl(2,:)=0;
                    end      
                    if isempty(tbl)
                        ACC(bb,cc,qi,i)=nan;
                        PPV(bb,cc,qi,i)=nan;
                        FDR(bb,cc,qi,i)=nan;

                    else
                        ACC(bb,cc,qi,i)=(tbl(1,1)+tbl(2,2))/sum(sum(tbl));
                        PPV(bb,cc,qi,i)=(tbl(2,2))/(tbl(2,2)+tbl(1,2));
                        FDR(bb,cc,qi,i)=1-(tbl(2,2))/(tbl(2,2)+tbl(1,2));

                    end                    
                    SHITS2(bb,cc,qi)=sum(HITS(qi,:));
                end    
%             SN(qi)=sum(NN);
        end
%         figure (1)
%         boxplot(RHOkend')
%         figure (2)
%         boxplot(PVALkend')
        SHITS=(sum(HITS,2));
%         disp(max(SHITS))
        [SHA(bb,cc), SHchoose(bb,cc)]=max(SHITS);
%         SHchoose2{bb,cc}=find(SHITS==SHA(bb,cc));
        

%         for dd=1:size(SHchoose2{bb,cc},1)
%         ids=unique(T.PtNo);
%                 ResSize=[];
%                 for i=1:size(ids,1)    
%                   PP=ids(i);
% % %                     [RHOkend(qi,i),PVALkend(qi,i)] = corr([T.Resectedarea(T.PtNo==PP)],NN(T.PtNo==PP),'type','Kendall','rows','pairwise');
% %                     HITS(qi,i)=sum(double(NN(T.PtNo==PP)).*T.Resectedarea(T.PtNo==PP))>0;
%                     [tbl,tchi2,tp,labels]=crosstab([T.Resectedarea(T.PtNo==PP)],double(NN(T.PtNo==PP)));   
%                     
%                    if size(tbl,2)==1
%                         tbl(:,2)=0;
%                     end
%                     if size(tbl,1)==1
%                         tbl(2,:)=0;
%                     end      
%                     if isempty(tbl)
%                         ACC(bb,cc)=nan;
%                         PPV(bb,cc)=nan;
%                         FDR(bb,cc)=nan;
% 
%                     else
%                         ACC(bb,cc)=(tbl(1,1)+tbl(2,2))/sum(sum(tbl));
%                         PPV(bb,cc)=(tbl(2,2))/(tbl(2,2)+tbl(1,2));
%                         FDR(bb,cc)=1-(tbl(2,2))/(tbl(2,2)+tbl(1,2));
% 
%                     end                    
%                 end    
%         end
        
        
        
    end
end

PPV2=median(PPV,4,'omitnan')==1;
tmp=(SHITS2.*PPV2);
M=max(max(max(tmp)));
Mi=find(tmp==M);
[I1,I2,I3] = ind2sub(size(tmp),Mi);
clc
for i=1:size(I3,1)
    PS=nchoosek([1:14],I1(i));
    fprintf(1,'%d need to be present out of %d\n',I2(i),I1(i));
    Tnames=T.Properties.VariableNames;
    Tnames(15)=[];
    Tnames(PS(I3(i),:)+7)
end

return
figure(2)
subplot(2,2,1)
imagesc(SHA)
title('number of patients with identified EZ regions')
xlabel('minimal number of present features in patient')
ylabel('number of choosen features')
subplot(2,2,2)
imagesc(ACC)
title('Accuracy')
xlabel('minimal number of present features in patient')
ylabel('number of choosen features')
subplot(2,2,3)
imagesc(PPV)
title('Positive predictive value')
xlabel('minimal number of present features in patient')
ylabel('number of choosen features')
subplot(2,2,4)
imagesc(FDR)
title('False discovery rate')
xlabel('minimal number of present features in patient')
ylabel('number of choosen features')