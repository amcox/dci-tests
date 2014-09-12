save_star_dci_test_plot_ela_only <- function(ss, data, star.cuts, test.name) {
  ds <- subset(data, small.school == ss)
  p <- generate_star_dci_test_plot_ela_only(ds, star.cuts, test.name, ss)
  save_plot_as_pdf(p, paste0('Student Performance on ELA STAR and ', test.name, ', ', ss))
}

generate_star_dci_test_plot_ela_only <- function(d, star.cuts, test.name, small.school.name) {
  sc <- select(subset(star.cuts, subject == 'ela'), -subject)
  p <- ggplot(d, aes(x=score, y=GE))+
    geom_point(shape=1)+
    geom_hline(data=subset(sc, grade %in% unique(d$grade)), aes(yintercept=c(1.25*(cut-.7), .5*(cut-.7))))+
    geom_vline(xintercept=c(0.5, 0.75))+
    scale_x_continuous(limits=c(0, 1), breaks=seq(0, 1, .1), labels=percent)+
    scale_y_continuous(breaks=seq(0, 20, 1))+
    labs(x='Percent Correct on DCI Assessment',
      y='Grade Equivalent on STAR',
      title=paste0('Student Performance on ELA STAR and ', test.name, '\nby Grade and Subject for ', small.school.name)
    )+
    theme_bw()+
    theme(axis.text.x=element_text(size=7),
      axis.text.y=element_text(size=7)
    )+
    facet_grid(subject ~ grade)
  return(p)
}