load_eadms_data <- function(subject) {
  library(XLConnect)
  d <- readWorksheetFromFile(paste0("./../Data/", subject, ".xlsx"),
             sheet = "Sheet1", startRow = 0
  )
  names(d) <- tolower(names(d))
  return(d)
}

load_all_clean_eadms_data <- function() {
  ela <- read.csv(file="./../Data/clean scores ela.csv", head=TRUE, na.string=c("", " ", "  "))
  ela$subject <- rep('ela', nrow(ela))
  math <- read.csv(file="./../Data/clean scores math.csv", head=TRUE, na.string=c("", " ", "  "))
  math$subject <- rep('math', nrow(math))
  sci <- read.csv(file="./../Data/clean scores sci.csv", head=TRUE, na.string=c("", " ", "  "))
  sci$subject <- rep('sci', nrow(sci))
  soc <- read.csv(file="./../Data/clean scores soc.csv", head=TRUE, na.string=c("", " ", "  "))
  soc$subject <- rep('soc', nrow(soc))
  rbind(ela, math, sci, soc)
}

load_star_data <- function() {
	read.csv(file="./../Data/star data, tests as rows.csv", head=TRUE, na.string=c("", " ", "  "),
    stringsAsFactors=F
  )
}

load_student_data <- function() {
	d <- read.csv(file="./../Data/students.csv", head=TRUE, na.string=c("", " ", "  "),
    stringsAsFactors=F
  )
  names(d) <- c('student.id', 'last.name', 'first.name', 'grade', 'school',
    'home.room', 'sped', 'speech.only', 'laa1', 'ell.newcomer', 'ela.grade',
    'math.grade', 'sci.grade', 'soc.grade', 'entry.date'
  )
  return(d)
}

load_star_cut_data <- function() {
	read.csv(file="./../Data/star cut scores.csv", head=TRUE, na.string=c("", " ", "  "),
    stringsAsFactors=F
  )
}