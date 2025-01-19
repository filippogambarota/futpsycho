library(magick)
library(ggplot2)
library(dplyr)

formazione <- readxl::read_xlsx("formazione.xlsx")
formazione$id <- paste0(formazione$team, formazione$player)
pitch <- image_read("pitch.jpg")
pitch <- image_modulate(pitch, brightness = 60, saturation = 40)
gg_pitch <- magick::image_ggplot(pitch)

info <- image_info(pitch)
width <- info$width
height <- info$height
center <- c(width/2, height/2)

pos1 <- data.frame(
  player = 1:5,
  team = 1,
  x = c(width/2, width/2, width/4, width/4 * 3, width/2),
  y = c(height/10, height/5, height/3, height/3, height/2 - height * 0.05)
)

pos2 <- data.frame(
  player = 1:5,
  team = 2,
  x = c(width/2, width/2, width/4, width/4 * 3, width/2),
  y = c(height * 0.9, height * 0.8, height * 0.7, height * 0.7, height/2 + height * 0.05)
)

pos <- rbind(pos1, pos2)
pos$id <- paste0(pos$team, pos$player)
pos <- dplyr::left_join(pos, select(formazione, id, name), by = "id")

gg_pitch <- gg_pitch +
  geom_text(data = pos, 
            aes(x = x, y = y, label = name, color = factor(team)), 
            fontface = "bold",
          show.legend = FALSE) +
  scale_color_manual(values = c("white", "cyan"))

ggsave("formazione.png", gg_pitch)

