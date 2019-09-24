for i=1:15
    fprintf(1,'trained %d sum %d corr %d \n',i,sum(predict(MdlDefault.Trained{i},X)),corr((predict(MdlDefault.Trained{i},X)),T.Resectedarea));
end