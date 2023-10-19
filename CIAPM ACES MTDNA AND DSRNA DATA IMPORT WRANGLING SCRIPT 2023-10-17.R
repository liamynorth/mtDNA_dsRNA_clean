#Title:CIAPM ACES MTDNA AND DSRNA DATA IMPORT WRANGLING SCRIPT
#File Name: CIAPM ACES MTDNA AND DSRNA DATA IMPORT WRANGLING SCRIPT 2023-10-17
#Authors: Liam North

#LOAD NECESSARY PACKAGES########################################################
pacman::p_load(pacman, tidyverse, readxl, car, stringr)

#DATA IMPORT####################################################################
#Import raw mtDNA cn csv named "0_2023-08-08 - LEVITT CIAPM ACES mtDNAcn"
df1 <- data.frame(read.csv(file.choose()))
head(df1)
tail(df1)
df1

#Import raw dsRNA csv named "0_2023-08-08 - LEVITT CIAPM ACES dsRNA"
df2 <- data.frame(read.csv(file.choose()))
head(df2)
tail(df2)
df2

#WRANGLE mtDNA CSV##############################################################
#Get rid of extraneous columns with CPM IDs + remove participant_id due to redundancy, family_id sufficient
df1 <- df1[,-(1:3)]
df1

#Get rid of blank column
df1 <- df1[,-7]
df1

#relocate family_id to first column
df1 <- df1 %>% relocate(family_id)
df1

#Omit string from timepoint field for correct format for REDCap import
df1$time_point <- gsub("[A-Z]", "", df1$time_point)
df1$time_point <- str_trim(df1$time_point, "right")
df1$time_point
df1$time_point <- as.integer(df1$time_point)
class(df1$time_point)

#Omit string from Batch number and fix spacing
df1$X <- gsub("[A-Z]", "", df1$X)
df1$X <- gsub("[a-z]", "", df1$X)
df1$X <- str_trim(df1$X, "left")
df1$X <- str_trim(df1$X, "right")
df1$X
df1$X <- as.integer(df1$X)
class(df1$X)


#rename columns
df1 <- df1 %>%
  rename(
    record_id_cpm = family_id,
    timepoint = time_point,
    sample_source_cpm = mother_baby,
    mtdna_cn_qpcr = mtDNA.Copy.number.QPCR,
    date_process_qpcr = DateProcessed,
    qpcr_batch = X,
    buccal_bsi_id_cpm = BSI_ID
  )

#Take out 9mo samples
df1 <-subset(df1, timepoint != 9)
df1$timepoint

#Fix joint jpb2/aces participants to correct format for REDCap import
df1$record_id_cpm[df1$record_id_cpm == "AJ001"] <- "A004 / AJ001 / J104"
df1$record_id_cpm[df1$record_id_cpm == "A004"] <- "A004 / AJ001 / J104"

df1$record_id_cpm[df1$record_id_cpm == "AJ002"] <- "A005 / AJ002 / J107"
df1$record_id_cpm[df1$record_id_cpm == "A005"] <- "A005 / AJ002 / J107"

df1$record_id_cpm[df1$record_id_cpm == "AJ003"] <- "A011 / AJ003 / J108"
df1$record_id_cpm[df1$record_id_cpm == "A011"] <- "A011 / AJ003 / J108"

df1$record_id_cpm[df1$record_id_cpm == "AJ004"] <- "A017 / AJ004 / J109"
df1$record_id_cpm[df1$record_id_cpm == "A017"] <- "A017 / AJ004 / J109"

df1$record_id_cpm[df1$record_id_cpm == "A028"] <- "A028 / AJ005 / J110"
df1$record_id_cpm[df1$record_id_cpm == "A033"] <- "A033 / AJ006 / J111"

df1

#final check
df1

#EXPORT mtDNA CSV###############################################################
write.csv(df1, "\\Users\\LevittLab\\Downloads\\CIAPMACES_mtDNA_Import_FINAL_20231017.csv", na = "", row.names=FALSE)

#WRANGLE dsRNA CSV##############################################################
#Get rid of redundant column ParticipantID
df2 <- df2[,-3]
df2

#Alter M_B string column to correct format for REDCap import
df2$M_B <- gsub("[a-z]", "", df2$M_B)
df2$M_B <- str_trim(df2$M_B, "right")
df2$M_B

#Omit string from timepoint field for correct format for REDCap import
df2$TimePoint <- gsub("[A-Z]", "", df2$TimePoint)
df2$TimePoint <- gsub("[a-z]", "", df2$TimePoint)
df2$TimePoint <- str_trim(df2$TimePoint, "right")
df2$TimePoint
df2$TimePoint <- as.integer(df2$TimePoint)
class(df2$TimePoint)

#rename columns
df2 <- df2 %>%
  rename(
    record_id_cpm = family_id,
    timepoint = TimePoint,
    sample_source_cpm = M_B,
    dsRNA = dsRNAng,
    buccal_bsi_id_cpm = BSI_ID
  )


#Fix joint jpb2/aces participants to correct format for REDCap import
df2$record_id_cpm[df2$record_id_cpm == "AJ001"] <- "A004 / AJ001 / J104"
df2$record_id_cpm[df2$record_id_cpm == "A004"] <- "A004 / AJ001 / J104"

df2$record_id_cpm[df2$record_id_cpm == "AJ002"] <- "A005 / AJ002 / J107"
df2$record_id_cpm[df2$record_id_cpm == "A005"] <- "A005 / AJ002 / J107"

df2$record_id_cpm[df2$record_id_cpm == "AJ003"] <- "A011 / AJ003 / J108"
df2$record_id_cpm[df2$record_id_cpm == "A011"] <- "A011 / AJ003 / J108"

df2$record_id_cpm[df2$record_id_cpm == "AJ004"] <- "A017 / AJ004 / J109"
df2$record_id_cpm[df2$record_id_cpm == "A017"] <- "A017 / AJ004 / J109"

df2$record_id_cpm[df2$record_id_cpm == "A028"] <- "A028 / AJ005 / J110"
df2$record_id_cpm[df2$record_id_cpm == "A033"] <- "A033 / AJ006 / J111"

df2

#final check
df2

#EXPORT dsRNA CSV###############################################################
write.csv(df2, "\\Users\\LevittLab\\Downloads\\CIAPMACES_dsRNA_Import_FINAL_20231017.csv", na = "", row.names=FALSE)


