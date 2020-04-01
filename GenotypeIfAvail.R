# Sunday 2/23/2020


# This is to re-examine the UL and non-UL samples from GEO for genotypes in the ULs
# compared to those samples without tumor tissue in them.

library(dplyr)
library(tidyr)


UL1 <- read.csv('UL_GSE95101_GPL13376_table.csv', sep=',', 
                header=T, na.strings=c('',' '))

#split up to smaller subsets
UL1a <- UL1[1:12000,]
UL1b <- UL1[12001:24000,]
UL1c <- UL1[24001:36000,]
UL1d <- UL1[36001:48701,]

write.csv(UL1a,'UL1a.csv', row.names=FALSE)
write.csv(UL1b,'UL1b.csv', row.names=FALSE)
write.csv(UL1c,'UL1c.csv', row.names=FALSE)
write.csv(UL1d,'UL1d.csv', row.names=FALSE)


UL2 <- read.csv('UL_GSE120854_GPL23767_table.csv', sep=',', 
                header=T, na.strings=c('',' '))

nonUL1 <- read.csv('nonUL_GSE95101_GPL13376_table.csv', sep=',', 
                   header=T, na.strings=c('',' '))
#split up to smaller subsets
nUL1a <- nonUL1[1:12000,]
nUL1b <- nonUL1[12001:24000,]
nUL1c <- nonUL1[24001:36000,]
nUL1d <- nonUL1[36001:48701,]

write.csv(nUL1a,'nonUL1a.csv', row.names=FALSE)
write.csv(nUL1b,'nonUL1b.csv', row.names=FALSE)
write.csv(nUL1c,'nonUL1c.csv', row.names=FALSE)
write.csv(nUL1d,'nonUL1d.csv', row.names=FALSE)


nonUL2 <- read.csv('nonUL_GSE120854_GPL23767_table.csv', sep=',', 
                   header=T, na.strings=c('',' '))

#the platform with more information

platform_UL2_nonUL2 <- read.delim('GPL21145-48548.txt', sep='\t', header=T,
                                  comment.char='#', na.strings=c('',' '))

# Keep the Symbol, cytoband, probe chromosome orientation, and sequence of uL1 and nonUL1
UL1_a <- UL1[,-c(1:13,15:19,21,29:31)]
nonUL1_a <- nonUL1[,-c(1:13,15:19,21,29:31)]

# remove unwanted columns from the 2nd set of UL and nonUL samples
platform_UL2_nonUL2_a <- platform_UL2_nonUL2[,-c(2:9,11,13)]
UL2_a <- UL2[,-c(1,3)]
nonUL2_a <- nonUL2[,-c(1,3)]


# combine the gene information from the correct platform to the 2nd set of genes
UL2_b <- merge(platform_UL2_nonUL2_a,UL2_a, by.x='ID', by.y='ID')
nonUL2_b <- merge(platform_UL2_nonUL2_a,nonUL2_a, by.x='ID', by.y='ID')

# the gene symbol isn't provided on the 2nd set of UL/nonUL samples
# see if merging by sequence for the two sets will combine the gene information

geneQuest1 <- merge(UL1_a, UL2_b, by.x='SEQUENCE', by.y='SourceSeq')
geneQuest2 <- merge(UL1_a, UL2_b, by.x='SEQUENCE', by.y='Forward_Sequence')


# The data sets we have needed information are from the first set of UL/nonuL samples.
# The second set is missing the gene symbol information.

UL <- UL1_a
nonUL <- nonUL1_a

UL_2 <- UL2_b
nonUL_2 <- nonUL2_b

# save the above to the Genotypes Tables folder
write.csv(UL,'UL.csv', row.names=FALSE)
write.csv(nonUL, 'nonUL.csv', row.names=FALSE)
write.csv(UL_2, 'UL_2.csv', row.names=FALSE)
write.csv(nonUL_2, 'nonUL_2.csv', row.names=FALSE)

# group by genotype or sequence in the 2nd set of non-identified gene symbols of ULs
genotypes2nd <- UL_2 %>% group_by(SourceSeq) %>% count(n=n())

#######################################################################################

# The 2nd set can't really be used for gene or genotype extraction because there are only 2 
# sets of any one genotype at the most.

setwd("./Genotypes Tables")

# The data is prepared already, use UL and nonUL from the Genotypes Tables folder
fibroid <- read.csv('UL.csv', sep=',', header=T, na.strings=c('',' '))
nonFibroid <- read.csv('nonUL.csv', sep=',', header=T, na.strings=c('',' '))

# Go  back to main directory
setwd("../")

fibroid_gene_n <- fibroid %>% group_by(Symbol) %>% count(n())
narm <- grep('^NA$',fibroid_gene_n$Symbol)

fibroid1 <- fibroid_gene_n[-narm,-2]
colnames(fibroid1)[2] <- 'gene_count'

NONfibroid_gene_n <- nonFibroid %>% group_by(Symbol) %>% count(n())
narm1 <- grep('^NA$',NONfibroid_gene_n$Symbol)

nonFibroid1 <- NONfibroid_gene_n[-narm1,-2]
colnames(nonFibroid1)[2] <- 'gene_count'

#combine the gene counts with the tables of samples for each type of UL or nonUL
Fibroid_count <- merge(fibroid1, fibroid, by.x='Symbol', by.y='Symbol')
nonFibroid_count <- merge(nonFibroid1, nonFibroid, by.x='Symbol', by.y='Symbol')

# add a mean, median, min, and max column to the Fibroid_count table
Fibroid_count$Fibroid_Mean <- rowMeans(Fibroid_count[11:30])
nonFibroid_count$nonFibroid_Mean <- rowMeans(nonFibroid_count[11:28])

# tidyr package to group by sample ID by gathering those columns into one
UL_3 <- gather(Fibroid_count, 'UL_Sample_ID','Value',11:30)
nonUL_3 <- gather(nonFibroid_count, 'nonUL_Sample_ID', 'Value',11:28)

UL_median <- UL_3 %>% group_by(SEQUENCE) %>% summarise_at(vars(Value), median)
colnames(UL_median)[2] <- 'Fibroid_Median'

nonUL_median <- nonUL_3 %>% group_by(SEQUENCE) %>% summarise_at(vars(Value), median)
colnames(nonUL_median)[2] <- 'nonFibroid_Median'

UL_max <- UL_3 %>% group_by(SEQUENCE) %>% summarise_at(vars(Value), max)
colnames(UL_max)[2] <- 'Fibroid_max'

nonUL_max <- nonUL_3 %>% group_by(SEQUENCE) %>% summarise_at(vars(Value), max)
colnames(nonUL_max)[2] <- 'nonFibroid_max'

UL_min <- UL_3 %>% group_by(SEQUENCE) %>% summarise_at(vars(Value), min)
colnames(UL_min)[2] <- 'Fibroid_min'

nonUL_min <- nonUL_3 %>% group_by(SEQUENCE) %>% summarise_at(vars(Value), min)
colnames(nonUL_min)[2] <- 'nonFibroid_min'

UL_sd <- UL_3 %>% group_by(SEQUENCE) %>% summarise_at(vars(Value), sd)
colnames(UL_sd)[2] <- 'Fibroid_stdError'

nonUL_sd <- nonUL_3 %>% group_by(SEQUENCE) %>% summarise_at(vars(Value), sd)
colnames(nonUL_sd)[2] <- 'nonFibroid_stdError'

# Combine these four tables together
Fibroid_stats <- merge(UL_median, UL_max, by.x='SEQUENCE', by.y='SEQUENCE')
Fibroid_stats1 <- merge(Fibroid_stats, UL_min, by.x='SEQUENCE', by.y='SEQUENCE')
Fibroid_stats2 <- merge(Fibroid_count, Fibroid_stats1, by.x='SEQUENCE', by.y='SEQUENCE')
Fibroid_stats3 <- merge(Fibroid_stats2, UL_sd, by.x='SEQUENCE', by.y='SEQUENCE')
colnames(Fibroid_stats3)[11:30] <- paste('UL_', colnames(Fibroid_stats3)[11:30], sep='')

nonFibroid_stats <- merge(nonUL_median, nonUL_max, by.x='SEQUENCE', by.y='SEQUENCE')
nonFibroid_stats1 <- merge(nonFibroid_stats, nonUL_min, by.x='SEQUENCE', by.y='SEQUENCE')
nonFibroid_stats2 <- merge(nonFibroid_count, nonFibroid_stats1, by.x='SEQUENCE', by.y='SEQUENCE')
nonFibroid_stats3 <- merge(nonFibroid_stats2, nonUL_sd, by.x='SEQUENCE', by.y='SEQUENCE')
colnames(nonFibroid_stats3)[11:28] <- paste('nonUL_', colnames(nonFibroid_stats3)[11:28], sep='')


nonfibroid <- nonFibroid_stats3[,c(1,11:33)]
all <- merge(Fibroid_stats3, nonfibroid, by.x='SEQUENCE', by.y='SEQUENCE')

# lets change the 'fibroid' in the column names to 'UL' for uterine leiomyoma
colnames(all) <- gsub('Fibroid', 'UL', colnames(all))

# reorder the table so that the stats are at the end of the columns
All <- all[,c(1:10,11:30, 36:53,31:35,54:58)]
All_stats_only <- All[,c(1,2,3,49:58)]
stats_all <- All_stats_only[!duplicated(All_stats_only),]

stats_all$foldChange_UL_to_nonUL <- stats_all$UL_Mean/stats_all$nonUL_Mean

write.csv(stats_all, 'UL_nonUL_beadchip_stats.csv', row.names=FALSE)
