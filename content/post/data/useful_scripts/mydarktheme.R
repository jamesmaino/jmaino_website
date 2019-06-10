# my darktheme 
library(ggplot2)
mydarktheme = 
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = rgb(.2,.21,.27)),
    plot.background = element_rect(fill = rgb(.2,.21,.27)),
    text = element_text(colour = 'grey'), 
    axis.text = element_text(colour = 'grey'), 
    panel.grid = element_line(colour = 'grey')
  )
