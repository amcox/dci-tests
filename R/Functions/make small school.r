make_small_school <- function(r) {
  if(r['school'] == 'SCH'){
    gc <- cut(as.numeric(r['grade']), c(-5, 4, 7, 9),
      labels=c("K-3", "4-6", "7-8"), right=FALSE
    )
  }else{
    gc <- cut(as.numeric(r['grade']), c(-5, 3, 6, 9),
      labels=c("K-2", "3-5", "6-8"), right=FALSE
    )
  }
  return(paste(r['school'], gc, sep=' '))
}