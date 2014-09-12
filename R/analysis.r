library(tidyr)
library(dplyr)

update_functions <- function() {
	old.wd <- getwd()
	setwd("functions")
	sapply(list.files(), source)
	setwd(old.wd)
}
update_functions()

convert_eadms_for_subject <- function(sub) {
  df <- load_eadms_data(sub)
  d <- gather(df, test, score, -c(student.id, student.name))
  d <- subset(d, !is.na(score))
  d$score <- d$score / 100
  d$subject <- rep(sub, nrow(d))
  d
}

d.scores <- convert_eadms_for_subject('ela')
d.scores <- rbind(d.scores, convert_eadms_for_subject('math'))
d.scores <- rbind(d.scores, convert_eadms_for_subject('sci'))
d.scores <- rbind(d.scores, convert_eadms_for_subject('soc'))

