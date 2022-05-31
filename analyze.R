library(tidyverse)      # includes ggplot and dplyr
# library(plotrix)        # for summarizing with standard error

# Read in df
df_meta <- read.csv('./VS/metathesis/output-20_long_pF1.csv')

# Remove problem ones
df <- df_meta[df_meta$issue %in% c('V1 absent', 'V1 absent?', ''), ]

df$V1toV2 <- df$V1_dur/df$V2_dur
df$V1toseq <- df$V1_dur/(df$V1_dur + df$C_dur + df$V2_dur)

# Get the phone before ALL V1 and after ALL V2
for (i in unique(df$seq_id)) {
  before <- unique(df[df$seq_id == i & df$part == 'V1', ]$before)
  after <- unique(df[df$seq_id == i & df$part == 'V2', ]$after)
  
  # Then replace
  df[df$seq_id == i, ]$before <- before
  df[df$seq_id == i, ]$after <- after
}

# Summarize V2 data
df_V2 <- df[df$part == 'V2', ]

sum_df <- df_V2 %>% 
  select(c(V2_qual, timepoint, pF2_means)) %>% #, C)) %>% 
  group_by(V2_qual, timepoint) %>% #, C) %>%
  summarize(
    mean = mean(pF2_means),
    n = n(),
    sd = sd(pF2_means),
    se = sd(pF2_means/sqrt(n()))
  )

###
ggplot(sum_df, aes(x = timepoint, y = mean, color = V2_qual)) + #, shape = C)) + 
  geom_point(cex = 5) +
  geom_path() +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V2_qual), alpha=0.2, color = NA) +
  ggtitle('Average F1 trajectories of V2 in target segments') +
  xlim(0,20) +
  labs(x = 'Timepoint',
       y = 'F1 Value',
       color = 'V2 Quality',
       shape = 'Preceding Consonant') +
  guides(fill = "none") +
  theme_bw() +
  theme(title = element_text(size = 20),
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 15),
        axis.text = element_text(size = 15),
        legend.position = 'bottom')

###

segs <- 20

# Vowels that are double (like iki)
df_vowel_double <- read.csv(paste0('./VS/vowels_double_u-i/output-', as.character(segs), '_long_pF3.csv'))

# Remove problem ones
#df_vowel_double <- df_vowel_double[df_vowel_double$issue %in% c('V1 absent', 'V1 absent?', ''), ]

df_vowel_double$V1toV2 <- df_vowel_double$V1_dur/df_vowel_double$V2_dur
df_vowel_double$V1toseq <- df_vowel_double$V1_dur/(df_vowel_double$V1_dur + df_vowel_double$C_dur + df_vowel_double$V2_dur)

# Get the phone before ALL V1 and after ALL V2
for (i in unique(df_vowel_double$seq_id)) {
  before <- unique(df_vowel_double[df_vowel_double$seq_id == i & df_vowel_double$part == 'V1', ]$before)
  after <- unique(df_vowel_double[df_vowel_double$seq_id == i & df_vowel_double$part == 'V2', ]$after)
  
  # Then replace
  df_vowel_double[df_vowel_double$seq_id == i, ]$before <- before
  df_vowel_double[df_vowel_double$seq_id == i, ]$after <- after
}

# Summarize V2 data
df_V2_doubV <- df_vowel_double[df_vowel_double$part == 'V2', ]

sum_df_doubV <- df_V2_doubV %>% 
  select(c(V2_qual, timepoint, pF2_means)) %>% 
  group_by(V2_qual, timepoint) %>%
  summarize(
    mean = mean(pF2_means),
    n = n(),
    sd = sd(pF2_means),
    se = sd(pF2_means/sqrt(n()))
  )

###
# Graph 
###
ggplot(sum_df_doubV, aes(x = timepoint, y = mean, color = V2_qual)) + 
  geom_point(cex = 5) +
  geom_path() +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V2_qual), alpha=0.2, color = NA) +
  ggtitle('Average F2 trajectories of V2 in VCV sequences (both V same)') +
  xlim(1,segs) +
  labs(x = 'Timepoint',
       y = 'F2 Value',
       color = 'V2 Quality',
       shape = 'Preceding Consonant') +
  guides(fill = "none") +
  theme_bw() +
  theme(title = element_text(size = 20),
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 15),
        axis.text = element_text(size = 15),
        legend.position = 'bottom')

####
####
####

segs <- 20

# Vowels that are double (like iki)
df_vowel <- read.csv(paste0('./VS/vowels/output-', as.character(segs), '_long_pF1.csv'))

# Remove problem ones
#df_vowel_double <- df_vowel_double[df_vowel_double$issue %in% c('V1 absent', 'V1 absent?', ''), ]

df_vowel$Vtoseq <- df_vowel$V_dur/(df_vowel$V_dur + df_vowel$C_dur)

# Get the phone before ALL V1 and after ALL V2
for (i in unique(df_vowel$seq_id)) {
  before <- unique(df_vowel[df_vowel$seq_id == i & df_vowel$part == 'C', ]$before)
  after <- unique(df_vowel[df_vowel$seq_id == i & df_vowel$part == 'V', ]$after)
  
  # Then replace
  df_vowel[df_vowel$seq_id == i, ]$before <- before
  df_vowel[df_vowel$seq_id == i, ]$after <- after
}

# Summarize V2 data
df_V_vowel <- df_vowel[df_vowel$part == 'V', ]

sum_df_vowel <- df_V_vowel %>% 
  select(c(V_qual, timepoint, pF2_means)) %>% 
  group_by(V_qual, timepoint) %>%
  summarize(
    mean = mean(pF2_means),
    n = n(),
    sd = sd(pF2_means),
    se = sd(pF2_means/sqrt(n()))
  )

###
# Graph 
###
ggplot(sum_df_vowel, aes(x = timepoint, y = mean, color = V_qual)) + 
  geom_point(cex = 5) +
  geom_path() +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V_qual), alpha=0.2, color = NA) +
  ggtitle('Average F1 trajectories of V with no preceding vowel') +
  xlim(1,segs) +
  labs(x = 'Timepoint',
       y = 'F1 Value',
       color = 'V2 Quality',
       shape = 'Preceding Consonant') +
  guides(fill = "none") +
  theme_bw() +
  theme(title = element_text(size = 20),
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 15),
        axis.text = element_text(size = 15),
        legend.position = 'bottom')

####
####
####

# Combine dataframes
# First exchange i and u for readability in the df_V2 dataset
df_V2$V2_qual_meta <- ifelse(df_V2$V2_qual == 'a', 'a', ifelse(df_V2$V2_qual == 'i', 'u', ifelse(df_V2$V2_qual == 'u', 'i', 'other')))
# include a
df_V2$V2_qual_meta <- ifelse(df_V2$V2_qual == 'a', 'i', ifelse(df_V2$V2_qual == 'i', 'u', ifelse(df_V2$V2_qual == 'u', 'i', 'other')))


df_V2$V2_qual_meta <- factor(df_V2$V2_qual_meta)



df_F1_combined <- data.frame(timepoint = c(df_V2$timepoint, df_V_vowel$timepoint),# df_V2_doubV$timepoint),
                             V_qual = unlist(list(df_V2$V2_qual_meta, df_V_vowel$V_qual)),# df_V2_doubV$V2_qual)),
                             V_orig = unlist(list(df_V2$V2_qual, df_V_vowel$V_qual)),
                             pF1_means = c(df_V2$pF1_means, df_V_vowel$pF1_means),# df_V2_doubV$pF1_means),
                             C = unlist(list(df_V2$C, df_V_vowel$C)),
                             type = c(rep('meta', nrow(df_V2)), rep('no meta', nrow(df_V_vowel)))) #, rep('no meta', nrow(df_V2_doubV))))

#df_F1_combined <- df_F1_combined[df_F1_combined$V_qual != 'a', ]

sum_df_F1_combined <- df_F1_combined %>% 
  select(c(V_qual, timepoint, type, V_orig, pF1_means)) %>% 
  group_by(V_qual, timepoint, type, V_orig) %>%
  summarize(
    mean = mean(pF1_means),
    n = n(),
    sd = sd(pF1_means),
    se = sd(pF1_means/sqrt(n()))
  )

ggplot(sum_df_F1_combined, aes(x = timepoint, y = mean, color = V_qual, linetype = type, shape = V_orig)) + 
  geom_point(cex = 5) +
  geom_path(size = 2) +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V_qual), alpha=0.2, color = NA) +
#  facet_wrap(~ C) +
  ggtitle('Average F1 trajectories of vowel') +
  xlim(1,segs) +
  labs(x = 'Timepoint',
       y = 'F1 Value',
       color = 'Onglide',
       shape = 'Orig Vowel Quality') +
  guides(fill = "none") +
  theme_bw() +
  theme(title = element_text(size = 20),
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 15),
        axis.text = element_text(size = 15),
        legend.position = 'bottom',
        legend.key.width = unit(1,"cm"))

#####
#####

# For F3

# Combine dataframes
# First exchange i and u for readability in the df_V2 dataset
df_V2$V2_qual_meta <- ifelse(df_V2$V2_qual == 'a', 'a', ifelse(df_V2$V2_qual == 'i', 'u', ifelse(df_V2$V2_qual == 'u', 'i', 'other')))
# include a
df_V2$V2_qual_meta <- ifelse(df_V2$V2_qual == 'a', 'i', ifelse(df_V2$V2_qual == 'i', 'u', ifelse(df_V2$V2_qual == 'u', 'i', 'other')))

df_V2$V2_qual_meta <- factor(df_V2$V2_qual_meta)

df_F3_combined <- data.frame(timepoint = c(df_V2$timepoint, df_V_vowel$timepoint),# df_V2_doubV$timepoint),
                             V_qual = unlist(list(df_V2$V2_qual_meta, df_V_vowel$V_qual)),# df_V2_doubV$V2_qual)),
                             V_orig = unlist(list(df_V2$V2_qual, df_V_vowel$V_qual)),
                             pF3_means = c(df_V2$pF3_means, df_V_vowel$pF3_means),# df_V2_doubV$pF1_means
                             C = unlist(list(df_V2$C, df_V_vowel$C)),
                             type = c(rep('meta', nrow(df_V2)), rep('no meta', nrow(df_V_vowel)))) #, rep('no meta', nrow(df_V2_doubV))))

#df_F3_combined <- df_F3_combined[df_F3_combined$V_qual != 'a', ]

sum_df_F3_combined <- df_F3_combined %>% 
  select(c(V_qual, timepoint, type, V_orig, pF3_means)) %>% 
  group_by(V_qual, timepoint, type, V_orig) %>%
  summarize(
    mean = mean(pF3_means),
    n = n(),
    sd = sd(pF3_means),
    se = sd(pF3_means/sqrt(n()))
  )

ggplot(sum_df_F3_combined, aes(x = timepoint, y = mean, color = V_qual, linetype = type, shape = V_orig)) + 
  geom_point(cex = 5) +
  geom_path(size = 2) +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V_qual), alpha=0.2, color = NA) +
#  facet_wrap(~ C) +
  ggtitle('Average F3 trajectories of vowel') +
  xlim(1,segs) +
  labs(x = 'Timepoint',
       y = 'F3 Value',
       color = 'Onglide',
       shape = 'Orig Vowel Quality') +
  guides(fill = "none") +
  theme_bw() +
  theme(title = element_text(size = 20),
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 15),
        axis.text = element_text(size = 15),
        legend.position = 'bottom',
        legend.key.width = unit(1,"cm"))

#####
#####

# For F2

# Combine dataframes
# First exchange i and u for readability in the df_V2 dataset
df_V2$V2_qual_meta <- ifelse(df_V2$V2_qual == 'a', 'a', ifelse(df_V2$V2_qual == 'i', 'u', ifelse(df_V2$V2_qual == 'u', 'i', 'other')))
# include a
df_V2$V2_qual_meta <- ifelse(df_V2$V2_qual == 'a', 'i', ifelse(df_V2$V2_qual == 'i', 'u', ifelse(df_V2$V2_qual == 'u', 'i', 'other')))

df_V2$V2_qual_meta <- factor(df_V2$V2_qual_meta)

df_F2_combined <- data.frame(timepoint = c(df_V2$timepoint, df_V_vowel$timepoint),# df_V2_doubV$timepoint),
                             V_qual = unlist(list(df_V2$V2_qual_meta, df_V_vowel$V_qual)),# df_V2_doubV$V2_qual)),
                             V_orig = unlist(list(df_V2$V2_qual, df_V_vowel$V_qual)),
                             pF2_means = c(df_V2$pF2_means, df_V_vowel$pF2_means),# df_V2_doubV$pF1_means),
                             C = unlist(list(df_V2$C, df_V_vowel$C)),
                             type = c(rep('meta', nrow(df_V2)), rep('no meta', nrow(df_V_vowel)))) #, rep('no meta', nrow(df_V2_doubV))))

#df_F2_combined <- df_F2_combined[df_F2_combined$V_qual != 'a', ]

sum_df_F2_combined <- df_F2_combined %>% 
  select(c(V_qual, timepoint, type, V_orig, pF2_means)) %>% 
  group_by(V_qual, timepoint, type, V_orig) %>%
  summarize(
    mean = mean(pF2_means),
    n = n(),
    sd = sd(pF2_means),
    se = sd(pF2_means/sqrt(n()))
  )

ggplot(sum_df_F2_combined, aes(x = timepoint, y = mean, color = V_qual, linetype = type, shape = V_orig)) + 
  geom_point(cex = 5) +
  geom_path(size = 2) +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V_qual), alpha=0.2, color = NA) +
#  facet_wrap(~ C) +
  ggtitle('Average F2 trajectories of vowel') +
  xlim(1,segs) +
  labs(x = 'Timepoint',
       y = 'F2 Value',
       color = 'Onglide',
       shape = 'Orig Vowel Quality') +
  guides(fill = "none") +
  theme_bw() +
  theme(title = element_text(size = 20),
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 15),
        axis.text = element_text(size = 15),
        legend.position = 'bottom',
        legend.key.width = unit(1,"cm"))

####
####

# Get max and min
ggplot(df, aes(x = V1toseq, y = V2_F2diff, color = V2_qual)) +
  geom_point() +
  geom_smooth(method = lm)

###
# Get duration of glide
###
sd_F2change <- df_V2 %>% 
  select(seq, seq_id, V2, pF2_means) %>%
  group_by(seq_id) %>%
  summarize(
    sd = sd(pF2_means)
  )

# Get cumulative duration
# And the F2 difference with each step
df_V2 <- as.data.frame(df_V2 %>%
  group_by(seq_id) %>%
  arrange(seq_id) %>%
  mutate(cumdur = cumsum(dur_mod/20),
         F2diff = pF2_means - lag(pF2_means, default = first(pF2_means)),
         F2_fade_idx = which((abs(F2diff) < 5) == TRUE)[2]) %>%
  ungroup())

# Get the index at which the fade lessens
df_V2$F2_fade_idx <- sapply(df_V2$F2_fade_idx, function (x) ifelse(is.na(x), 20, x))

# Now get the cumulative duration to that point
df_V2 <- as.data.frame(df_V2 %>%
  group_by(seq_id) %>%
  mutate(fade_len = cumdur[F2_fade_idx]) %>%
  ungroup())

df_V2$glidetoseq <- df_V2$fade_len/(df_V2$V1_dur + df_V2$C_dur + df_V2$V2_dur)

# Remove duplicates
df_V2 <- df_V2[!duplicated(df_V2$seq_id), ]

# Look at phones before and after
sort(unique(c(as.vector(df_V2$before), as.vector(df_V2$after))))

# Before and after categories
df_V2$before_cat <- ifelse(df_V2$before %in% c('sil', 'sp'), 'silence',
                      ifelse(df_V2$before %in% c('CH', 'F', 'HH', 'SH', 'TH'), 'fric',
                        ifelse(df_V2$before %in% c('K', 'P', 'T'), 'stop',
                          ifelse(df_V2$before %in% c('L', 'M', 'N', 'R', 'V', 'Y'), 'son',
                           ifelse(df_V2$before %in% c('AH0', 'IH0'), 'vowel', 'error'
                           )
                          )
                        )
                      )
                    )

# Before and after categories
df_V2$before_lab <- ifelse(df_V2$before %in% c('P', 'F', 'V'), 'labial', 'not labial')

# Get max and min
ggplot(df_V2, aes(x = V1toseq, y = glidetoseq, shape = V1_qual, color = before_lab)) +
  geom_point(cex = 3) +
  geom_smooth(aes(group = NA), color = 'black', method = lm) +
#  stat_ellipse(aes(group=before_cat, color = before_cat)) +
  scale_x_reverse() +
  ggtitle('Correlation of Relative V1 to Glide Length') +
  labs(x = 'V1 Proportion of Sequence Duration',
       y = 'Glide Proportion of Sequence Duration',
       color = 'C before V1') +
  theme_bw() +
  theme(title = element_text(size = 20),
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 15),
        axis.text = element_text(size = 15),
        legend.position = 'right')

cor.test(df_V2$V1toseq, df_V2$glidetoseq)

shorter_V1 <- df_V2[df_V2$V1toseq < 0.2 & df_V2$V1toseq > 0.1, ]

View(shorter_V1[order(shorter_V1$glidetoseq), ])

View(df_V2[df_V2$V1toseq == 0.0, ])

#

longer_V1 <- df_V2[df_V2$V1toseq > 0.4, ]

View(longer_V1[order(longer_V1$before_cat), ])

df_V2[df_V2$V1toseq < 0.2 & df_V2$V1toseq > 0.1 & df_V2$glidetoseq > 0.25, ]$Filename

df_V2[df_V2$V1toseq < 0.2 &  df_V2$V1toseq > 0.1 & df_V2$glidetoseq < 0.25, ]$Filename
