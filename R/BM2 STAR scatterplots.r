library(tidyr)
library(dplyr)
library(ggplot2)
library(scales)
library(XLConnect)

update_functions <- function() {
	old.wd <- getwd()
	setwd("functions")
	sapply(list.files(), source)
	setwd(old.wd)
}
update_functions()

# Load EADMS data that was hand copied into the Data folder as one cleaned file per subject. Take just ela and math, then find the average score in case there are multiple tests for a student-subject (like ETs).
d.eadms <- load_all_clean_eadms_data()
d.eadms <- subset(d.eadms, subject %in% c('ela', 'math'))
d.e <- d.eadms %>% group_by(student.id, subject) %>% summarize(
  score=mean(score, na.rm=T)
)

# Load STAR data and take the average of all scores, since we're at the beginning of the year and can't make reliable linear models yet.
d.star <- load_star_data()
d.s <- d.star %>% group_by(StudentId, subject) %>% summarize(
  GE=mean(GE, na.rm=T),
  gap=mean(gap, na.rm=T)
)
d.s$subject[d.s$subject == 'reading'] <- 'ela'

# Cut scores are directly from DCI conversation to set them. Using the real, not +0.5.
star.cuts <- load_star_cut_data()

# Load PS data that has been expoted using the format the same as the DCI test Excel spreadsheet for the students tab.
d.ps <- load_student_data()
d.ps$small.school <- apply(d.ps, 1, make_small_school)

# Merge data together, keeping only complete rows
d <- merge(d.ps, d.e, by.x='student.id', by.y='student.id')
d <- merge(d, d.s, by.x=c('student.id', 'subject'), by.y=c('StudentId', 'subject'))

# Generate plots
sapply(unique(d$small.school), save_star_dci_test_plot, data=d, star.cuts=star.cuts, test.name='Benchmark 1')

# Generate excel reports
cut_star_band <- function(r, star.cuts) {
  cs <- subset(star.cuts, grade == r['grade'] & subject == r['subject'])['cut']
  cut(as.numeric(r['GE']), c(-5, 1.25*(cs-.7) + 0.1, .5*(cs-.7) +0.1, 99),
    labels=c("bottom", "middle", "top"), right=FALSE
  )
}
cut_dci_band <- function(r) {
  cut(as.numeric(r['score']), c(-5, .4999, .74999, 99),
    labels=c("bottom", "middle", "top"), right=FALSE
  )
}
summarize_dci_star_band_percs <- function(d) {
  summarize(
    d,
    dci.bottom=round(mean(dci.band == 'bottom', na.rm=T), 3),
    dci.middle=round(mean(dci.band == 'middle', na.rm=T), 3),
    dci.top=round(mean(dci.band == 'top', na.rm=T), 3),
    star.bottom=round(mean(star.band == 'bottom', na.rm=T), 3),
    star.middle=round(mean(star.band == 'middle', na.rm=T), 3),
    star.top=round(mean(star.band == 'top', na.rm=T), 3)
  )
}

d$star.band <- apply(d, 1, cut_star_band, star.cuts=star.cuts)
d$dci.band <- apply(d, 1, cut_dci_band)

df.by.student <- select(d, student.id, last.name:school, small.school, home.room, subject, score, dci.band, GE:star.band, sped:entry.date)

# By school-grade-subject
d.school.grade.sub <- d %>% group_by(school, grade, subject) %>% do(summarize_dci_star_band_percs(.))
# By school-grade
d.school.grade <- d %>% group_by(school, grade) %>% do(summarize_dci_star_band_percs(.))
d.school.grade$subject <- rep(NA, nrow(d.school.grade))
# By school-subject
d.school.sub <- d %>% group_by(school, subject) %>% do(summarize_dci_star_band_percs(.))
d.school.sub$grade <- rep(NA, nrow(d.school.sub))
# By school
d.school <- d %>% group_by(school) %>% do(summarize_dci_star_band_percs(.))
d.school$subject <- rep(NA, nrow(d.school))
d.school$grade <- rep(NA, nrow(d.school))
# By smallschool-subject
d.smallschool.grade <- d %>% group_by(school, small.school, subject) %>% do(summarize_dci_star_band_percs(.))
names(d.smallschool.grade)[names(d.smallschool.grade) == 'small.school'] <- 'grade'
# By smallschool
d.smallschool <- d %>% group_by(school, small.school) %>% do(summarize_dci_star_band_percs(.))
names(d.smallschool)[names(d.smallschool) == 'small.school'] <- 'grade'
d.smallschool$subject <- rep(NA, nrow(d.smallschool))

d.all <- rbind(d.school.grade.sub, d.school.grade, d.school.sub, d.school, d.smallschool.grade, d.smallschool)

# Save the data tables to a single spreadsheet
writeWorksheetToFile('./../Output/DCI and STAR Band Info.xlsx', df.by.student, 'students', clearSheets=T, styleAction=XLC$"STYLE_ACTION.NONE")
writeWorksheetToFile('./../Output/DCI and STAR Band Info.xlsx', d.all, 'percentages', clearSheets=T, styleAction=XLC$"STYLE_ACTION.NONE")

