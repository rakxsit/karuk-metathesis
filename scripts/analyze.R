library(tidyverse)      # includes ggplot and dplyr

# Choose which formant we want to look at
f <- '1'

df_meta <- read.csv(paste0('../VS/metathesis/output-20_long_pF', f, '.csv'))

# Remove problem ones
df <- df_meta[df_meta$issue %in% c('V1 absent', 'V1 absent?', ''), ]

df$V1toV2 <- df$V1_dur/df$V2_dur
df$V1toseq <- df$V1_dur/(df$V1_dur + df$C_dur + df$V2_dur)

# Get the phone before ALL V1 (first vowel) and after ALL V2 (second vowel)
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
  select(c(V2_qual, timepoint, !!sym(paste0('pF', f, '_means')))) %>%
  group_by(V2_qual, timepoint) %>%
  summarize(
    mean = mean(!!sym(paste0('pF', f, '_means'))),
    n = n(),
    sd = sd(!!sym(paste0('pF', f, '_means'))),
    se = sd(!!sym(paste0('pF', f, '_means'))/sqrt(n()))
  )

###
# Plot the average formant trajectory of V2
ggplot(sum_df, aes(x = timepoint, y = mean, color = V2_qual)) + #, shape = C)) + 
  geom_point(cex = 5) +
  geom_path() +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V2_qual), alpha=0.2, color = NA) +
  ggtitle(paste0('Average F', f, ' trajectories of V2 in target segments')) +
  xlim(0,20) +
  labs(x = 'Timepoint',
       y = paste0('F', f, 'Value'),
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
df_vowel_double <- read.csv(paste0('../VS/vowels_double_u-i/output-', as.character(segs), '_long_pF', f, '.csv'))

# Remove problem ones
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
  select(c(V2_qual, timepoint, !!sym(paste0('pF', f, '_means')))) %>% 
  group_by(V2_qual, timepoint) %>%
  summarize(
    mean = mean(!!sym(paste0('pF', f, '_means'))),
    n = n(),
    sd = sd(!!sym(paste0('pF', f, '_means'))),
    se = sd(!!sym(paste0('pF', f, '_means'))/sqrt(n()))
  )

###
# Graph average trajectories for V2 when it is the same as V1
###
ggplot(sum_df_doubV, aes(x = timepoint, y = mean, color = V2_qual)) + 
  geom_point(cex = 5) +
  geom_path() +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V2_qual), alpha=0.2, color = NA) +
  ggtitle(paste0('Average F', f,' trajectories of V2 in VCV sequences (both V same)')) +
  xlim(1,segs) +
  labs(x = 'Timepoint',
       y = paste0('F', f, ' Value'),
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
df_vowel <- read.csv(paste0('../VS/vowels/output-', as.character(segs), '_long_pF', f, '.csv'))

# Remove problem ones
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
  select(c(V_qual, timepoint, !!sym(paste0('pF', f, '_means')))) %>% 
  group_by(V_qual, timepoint) %>%
  summarize(
    mean = mean(!!sym(paste0('pF', f, '_means'))),
    n = n(),
    sd = sd(!!sym(paste0('pF', f, '_means'))),
    se = sd(!!sym(paste0('pF', f, '_means'))/sqrt(n()))
  )

###
# Graph formant trajectories when there is *no* preceding vowel
###
ggplot(sum_df_vowel, aes(x = timepoint, y = mean, color = V_qual)) + 
  geom_point(cex = 5) +
  geom_path() +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V_qual), alpha=0.2, color = NA) +
  ggtitle(paste0('Average F', f, ' trajectories of V with no preceding vowel')) +
  xlim(1,segs) +
  labs(x = 'Timepoint',
       y = paste0('F', f, ' Value'),
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



df_combined <- data.frame(timepoint = c(df_V2$timepoint, df_V_vowel$timepoint),
                             V_qual = unlist(list(df_V2$V2_qual_meta, df_V_vowel$V_qual)),
                             V_orig = unlist(list(df_V2$V2_qual, df_V_vowel$V_qual)),
                             pF1_means = c(df_V2$pF1_means, df_V_vowel[[paste0('pF', f, '_means')]]),
                             C = unlist(list(df_V2$C, df_V_vowel$C)),
                             type = c(rep('meta', nrow(df_V2)), rep('no meta', nrow(df_V_vowel))))

sum_df_combined <- df_combined %>% 
  select(c(V_qual, timepoint, type, V_orig, !!sym(paste0('pF', f, '_means')))) %>% 
  group_by(V_qual, timepoint, type, V_orig) %>%
  summarize(
    mean = mean(!!sym(paste0('pF', f, '_means'))),
    n = n(),
    sd = sd(!!sym(paste0('pF', f, '_means'))),
    se = sd(!!sym(paste0('pF', f, '_means'))/sqrt(n()))
  )


# Trajectories of formant *both* by what the original vowel quality is *and* by what the onglide is
ggplot(sum_df_combined, aes(x = timepoint, y = mean, color = V_qual, linetype = type, shape = V_orig)) + 
  geom_point(cex = 5) +
  geom_path(size = 2) +
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se, fill = V_qual), alpha=0.2, color = NA) +
#  facet_wrap(~ C) +
  ggtitle(paste0('Average F', f, ' trajectories of vowel')) +
  xlim(1,segs) +
  labs(x = 'Timepoint',
       y = paste0('F', f, ' Value'),
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

# Plot the ratio of the duration of V1 to the VCV sequence *as compared to* the formant difference between the max and min formant values
ggplot(df, aes(x = V1toseq, y = !!sym(paste0('V2_pF', f, 'diff')), color = V2_qual)) +
  geom_point() +
  geom_smooth(method = lm)

###
# Get duration of glide
###
sd_Fchange <- df_V2 %>% 
  select(seq, seq_id, V2, !!sym(paste0('pF', f, '_means'))) %>%
  group_by(seq_id) %>%
  summarize(
    sd = sd(!!sym(paste0('pF', f, '_means')))
  )

# Get cumulative duration
# And the formant difference with each step so that we can figure out the steepness of the change
df_V2 <- as.data.frame(df_V2 %>%
  group_by(seq_id) %>%
  arrange(seq_id) %>%
  mutate(cumdur = cumsum(dur_mod/20),
         Fdiff = !!sym(paste0('pF', f, '_means')) - lag(!!sym(paste0('pF', f, '_means')), default = first(!!sym(paste0('pF', f, '_means')))),
         F_fade_idx = which((abs(Fdiff) < 5) == TRUE)[2]) %>%
  ungroup())

# Get the index at which the fade lessens
df_V2$F_fade_idx <- sapply(df_V2$F_fade_idx, function (x) ifelse(is.na(x), 20, x))

# Now get the cumulative duration to that point
df_V2 <- as.data.frame(df_V2 %>%
  group_by(seq_id) %>%
  mutate(fade_len = cumdur[F_fade_idx]) %>%
  ungroup())

# Proportion of time for which the glide lasts
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

# Before and after labels
df_V2$before_lab <- ifelse(df_V2$before %in% c('P', 'F', 'V'), 'labial', 'not labial')

# Look at the correlation of the *ratio* of V1:VCV sequence *to* glide:VCV sequence
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

# Test significance of correlation
cor.test(df_V2$V1toseq, df_V2$glidetoseq)

####
# EDGE CASES
####

# Look at cases where V1 is short
shorter_V1 <- df_V2[df_V2$V1toseq < 0.2 & df_V2$V1toseq > 0.1, ]

View(shorter_V1[order(shorter_V1$glidetoseq), ])

View(df_V2[df_V2$V1toseq == 0.0, ])

#

# Look at cases where V1 is long
longer_V1 <- df_V2[df_V2$V1toseq > 0.4, ]

View(longer_V1[order(longer_V1$before_cat), ])

df_V2[df_V2$V1toseq < 0.2 & df_V2$V1toseq > 0.1 & df_V2$glidetoseq > 0.25, ]$Filename

df_V2[df_V2$V1toseq < 0.2 &  df_V2$V1toseq > 0.1 & df_V2$glidetoseq < 0.25, ]$Filename
