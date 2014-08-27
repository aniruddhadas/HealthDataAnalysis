library(httr)

token_url = "http://api.fitbit.com/oauth/request_token"
access_url = "http://api.fitbit.com/oauth/access_token"
auth_url = "http://www.fitbit.com/oauth/authorize"
key = "<fill your key>"
secret = "<fill your key>"

fbr = oauth_app('StepTrack',key,secret)
fitbit = oauth_endpoint(token_url,auth_url,access_url)
token = oauth1.0_token(fitbit,fbr)
sig = sign_oauth1.0(fbr, token=token$credentials$oauth_token, token_secret=token$credentials$oauth_token_secret)

# get all step data from my first day of use to the current date:
steps = GET("http://api.fitbit.com/1/user/-/activities/steps/date/2013-08-24/today.json",sig)

library(RColorBrewer)
library(rjson)

# convert JSON to a dataframe:
data = NULL
for (i in 1:length(content(steps)$'activities-steps')) {
  x = c(content(steps)$'activities-steps'[i][[1]]$dateTime,content(steps)$'activities-steps'[i][[1]]$value)
  data = cbind(data,x)
}
data = t(data)

colnames(data) = c("date","steps")
data = as.data.frame(data,row.names=1)

# extract step counts and convert to numeric:
data$steps = as.numeric(as.character(data$steps))

# set up and plot the graph:
# brew = brewer.pal(3,"Set1") # red, blue, green
# cols = rep(brew[1],length(steps))
# cols[steps > 10000] = brew[3]
# barplot(steps,ylim=c(0,max(steps)*1.2),col=cols,ylab="Steps",names=gsub("2014-","",data$date),las=2,border=0,cex.axis=0.8)
# abline(h=10000,lty=2)

dataedited <- data[data$steps > 10,]
dataedited$wday <- as.POSIXlt(dataedited$steps)$wday
par(mfrow = c(1, 2))
plot1 <- qplot(dataedited$date, dataedited$steps, xlab = "Date", ylab = "Steps") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
plot2 <- qplot(dataedited$wday, dataedited$steps, xlab = "Weekday", ylab = "Steps") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
library('gridExtra')
grid.arrange(plot1, plot2, ncol=2)
