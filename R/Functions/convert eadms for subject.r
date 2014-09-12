convert_eadms_for_subject <- function(subject) {
  df <- load_eadms_data(subject)
  d <- gather(df, test, score, -c(student.id, student.name))
  d <- subset(d, !is.na(score))
  d$score <- d$score / 100
  save_df_as_csv(d, paste0('clean scores ', subject)) 
}