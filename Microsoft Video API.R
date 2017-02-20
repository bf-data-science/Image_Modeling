lsf.str("package:Roxford")

library(Roxford)
library(plyr)
library(dplyr)

videokey<-"29e12bfe82a7423fa2b454eb9071fcca"
video<-"IMG_1045.MOV"

con <- getVideoResultResponse(video, videokey)        
#getVideoResponse(video.path, key)  first call maybe?       
#getVideoResultResponse() the Video API needs two calls, one to upload the video, a second to get the results after processing, this is the second call.
list.files()
plswork<-getVideoResponse("IMG_1045.MOV", videokey)
plswork2<-getVideoResultResponse("IMG_1045.MOV", videokey)
plswork3<-getVideoMotion("IMG_1045.MOV", videokey)



#analyse each frame with the emotion API
emotionkey<-"1dda23e5ae0e495c9f85c261f13c920c"
i=1
jpegfiles<-list.files(pattern="*.jpg")
Combined.Data<-data.frame(1)
for(i in 160:length(jpegfiles)){
print(i)        
Sys.sleep(3)        
dataguy<-getEmotionResponse(jpegfiles[i],key = emotionkey)
if(ncol(dataguy)==0){dataguy<-data.frame(NA)}
dataguy$Frame.Number<-i
Combined.Data<-rbind.fill(dataguy,Combined.Data)
}

fps<-30

Combined.Data$Second<-round(Combined.Data$Frame.Number/30)


Combined.Data2<-Combined.Data[!is.na(Combined.Data$faceRectangle.height),]
Combined.Data2$NA.<-NULL
Combined.Data2$X1<-NULL

mutatedguy<-Combined.Data2 %>% group_by(Second) %>% summarise_all(.funs=mean)

varianceguy<-Combined.Data2 %>% group_by(Second) %>% summarise_all(.funs=var)

sum(Combined.Data2[,grepl("scores",colnames(Combined.Data2))])/nrow(Combined.Data2) #Should be 1, since the scores of each row should add to 1.

ggplot(Combined.Data2, aes(x=Date)) + geom_line(aes(y=Actual, colour='Actual'))


write.csv(Combined.Data2,"ByFrameResults.csv",row.names=F)

write.csv(mutatedguy,"BySecondResults-Mean.csv",row.names = F)
write.csv(varianceguy,"BySecondResults-variance.csv",row.names = F)
