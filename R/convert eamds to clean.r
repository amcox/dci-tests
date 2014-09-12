library(tidyr)

update_functions <- function() {
	old.wd <- getwd()
	setwd("functions")
	sapply(list.files(), source)
	setwd(old.wd)
}
update_functions()

sapply(c('ela', 'math', 'sci', 'soc'), convert_eadms_for_subject)