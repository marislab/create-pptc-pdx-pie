
# working directory (created with bash script)
mainDir <- "~/create-pptc-pdx-pie/"
dataDir <- paste0(mainDir,"data/")
# set path to your git cloned repo
script.folder <- "~/Documents/GitHub/create-pptc-pdx-pie/R/" 
##create directory for output files
ifelse(!dir.exists(file.path(paste0(mainDir, "output/"))), dir.create(file.path(paste0(mainDir, "output/"))), 
       "Directory exists!")

##set wd
setwd(mainDir)

##load/install packages
source(paste0(script.folder, "install-packages.R"))

##load clinical, reshape
clin <- read.delim(paste0(dataDir, "pptc-pdx-clinical-web.txt"), header = T, sep = "\t", check.names = F)
length(unique(clin$Histology.oncotree))
clin$Histology.oncotree <- ifelse(clin$Histology.Detailed2 == "Extracranial Rhabdoid", "RHAB", 
                                  ifelse(clin$Histology.Detailed2 == "MB-SHH", "MB-SHH", 
                                         ifelse(clin$Histology.Detailed2 == "MB-WNT", "MB-WNT",
                                                ifelse(clin$Histology.Detailed2 == "MB-Group3", "MB-Group3",
                                                       ifelse(clin$Histology.Detailed2 == "MB-Group4", "MB-Group4", 
                                                              ifelse(clin$Histology.Detailed2 == "CNS Embryonal NOS", "EMB-NOS",
                                                                     ifelse(clin$Histology.Detailed2 == "CNS EFT-CIC", "EMB-CIC",
                                                                            ifelse(clin$Histology.Detailed2 == "Ependymoblastoma", "EPEND",
                                                                                   ifelse(clin$Histology.Detailed2 == "PF-EPN-A", "PFEPNA",
                                                                                          ifelse(clin$Histology.Detailed2 == "PF-EPN-B", "PFEPNB",
                                                                                                 ifelse(clin$Histology.Detailed2 == "ST-EPN-RELA", "EPNRELA",
                                                                                                        ifelse(clin$Histology.Detailed2 == "ST-EPN-YAP1", "EPNYAP",
                                                                                                               paste0(clin$Histology.oncotree)))))))))))))



colores <- read.delim(paste0(dataDir, "pie-colors.txt"), header = T, sep = "\t")
clin <- merge(clin, colores, all.x = T)
names(clin)
###get assays per model
clin$assay <- ifelse(clin$Have.snp.file == "yes" & clin$Have.maf == "yes" & clin$RNA.Part.of.PPTC == "yes", "SNP,WES,RNA",
                     ifelse(clin$Have.snp.file == "yes" & clin$Have.maf == "yes" & clin$RNA.Part.of.PPTC == "no", "SNP,WES",
                            ifelse(clin$Have.snp.file == "yes" & clin$Have.maf == "no" & clin$RNA.Part.of.PPTC == "no", "SNP",
                                   ifelse(clin$Have.snp.file == "yes" & clin$Have.maf == "no" & clin$RNA.Part.of.PPTC == "yes", "SNP, RNA",
                                          ifelse(clin$Have.snp.file == "no" & clin$Have.maf == "yes" & clin$RNA.Part.of.PPTC == "yes", "WES, RNA",
                                                 ifelse(clin$Have.snp.file == "no" & clin$Have.maf == "no" & clin$RNA.Part.of.PPTC == "yes", "RNA",
                                                        ifelse( ifelse(clin$Have.snp.file == "no" & clin$Have.maf == "yes" & clin$RNA.Part.of.PPTC == "no", "WES", 
                                                                       ""))))))))
clin$Have.fpkm.file <- gsub("no", "", clin$Have.fpkm.file)
clin$Have.fpkm.file <- gsub("yes", "RNA", clin$Have.fpkm.file)
clin$Have.snp.file <- gsub("no", "", clin$Have.snp.file)
clin$Have.snp.file <- gsub("yes", "SNP", clin$Have.snp.file)
clin$Have.maf <- gsub("no", "", clin$Have.maf)
clin$Have.maf <- gsub("yes", "WES", clin$Have.maf)


###subset clinical
clin.sub <- clin[,c("Model", "Histology.Onco.New", "Histology.oncotree", "Have.maf", "Have.fpkm.file", "Have.snp.file","Phase2", "Sex")]
clin.sub$nodes <- paste0(clin.sub[[1]], clin.sub[[2]], clin.sub[[3]], clin.sub[[4]], clin.sub[[5]], clin.sub[[6]], clin.sub[[7]], clin.sub[[8]])

###make node patterns
clin.sub[,1]<- NULL
names(clin.sub) <- c("level1", "level2", "level3", "level4", "level5", "level6", "level7", "nodes")
##remove extra spaces
#clin.sub$nodes <- gsub(" ", "", clin.sub$nodes)
##sum each unique parent-node-leaf combination
counts <- clin.sub %>% 
  group_by(nodes) %>%
  dplyr::summarise(size = n())
##remove with no assay
counts <- counts[!grepl("^NA-", counts$nodes),]

final <- merge(clin.sub, counts, all.x = T)
final$nodes <- NULL
###save as csv
write.table(final, paste0(mainDir, "output/counts.csv"), col.names = T, row.names = F, quote = F, sep = ",")

##read in counts
dat <- read.csv(paste0(mainDir, "output/counts.csv"), header=T, stringsAsFactors = FALSE)

###create treemap
sunburst(
  d3_nest(dat, value_cols="size"),
  count = TRUE, percent = F,
  legend = T, withD3 = T)
tm <- treemap(dat,
              index = c("level1", "level2", "level3", "level4", "level5", "level6", "level7"),
              vSize = "size",
              draw = FALSE
)$tm

###subset for colors
level4 <- subset(tm, level == 4)
level5 <- subset(tm, level == 5)
level6 <- subset(tm, level == 6)
level7 <- subset(tm, level == 7)
level3 <- subset(tm, level == 3)
level2 <- subset(tm, level == 2)
level1 <- subset(tm, level == 1)
level2$color <- NULL
clin.col <- unique(clin[,c("Histology.Detailed", "Histology.oncotree", "Color")])
clin.col$Histology.Detailed <- NULL
clin.col2 <- unique(clin.col)
names(clin.col) <- c("level2", "color")
mergecol <- merge(level2, clin.col, all.x = T) 
new.level2 <- unique(mergecol[,c(2,1,3:ncol(mergecol))])

###color dx/relapse/broad hist/assay
level6$color <- ifelse(level6$level6 == "Diagnosis", "#7FFFD4", 
                       ifelse(level6$level6 == "Relapse", "#EEAEEE",
                              ifelse(level6$level6 == "Post-treatment", "#BABABA", "#FFFFFF")))
level1$color <- ifelse(level1$level1 == "brain", "#FFDAB9",
                       ifelse(level1$level1 == "leukemia", "#FFE4E1", "#FAFAD2"))
level7$color <- ifelse(level7$level7 == "Male", "#CAE1FF", 
                       ifelse(level7$level7 == "Female", "#FFC1C1", "#FFFFFF"))
level3$color <- ifelse(level3$level3 == "WES", "#E5E5E5", "#FFFFFF")
level4$color <- ifelse(level4$level4 == "RNA", "#CCCCCC", "#FFFFFF")
level5$color <- ifelse(level5$level5 == "SNP", "#B3B3B3", "#FFFFFF")


new.col <- bind_rows(list(level1, new.level2, level3, level4, level5, level6, level7))
##plot pie with new colors
p<- sund2b(
  d3_nest(new.col, value_cols = colnames(new.col)[-(1:7)]),
  colors = htmlwidgets::JS(
    "function(name, d){return d.color || '#ccc';}"
  ),
  valueField = "vSize"
)
print(p)
## create .html 
mapshot(p, url = paste0(mainDir, "output/pptc-pdx-pie.html"))

