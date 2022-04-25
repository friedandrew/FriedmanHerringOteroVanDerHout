#TN = Total Nitrogen
#TP = Total Phosphorous
#OIR = Observed Invertibrate Richness
#CGR = Channel Geometry Ratio
#D50 = D50 Pebble Count
#DSK = Dams Per Square Kilometer
# P-Values: _05 = 0.05; _01 =0.01; _001 = 0.001 

TN_05 <- c("RPRN_VEG_CNPY_CVR", "RPRN_VEG_GC", "RPRN_VEG_GC", "LWD_FREQ", "INCSN_HT", "CHN_INCSN", "WTTD_WT", "Dams_per_sqkm", NA, NA, NA, NA)
TN_01 <- c("OBSRVD_INVRT_RCHNSS", "WDRatio", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)

TP_05 <- c("WDRatio", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
TP_01 <- c("ReachLength", "INSTNT_TEMP", "LWD_FREQ", "AMCROINVRTBRTE_CNT", NA, NA, NA, NA, NA, NA, NA, NA)
TP_001 <- c("StreamOrder", "BNK_STBLTY", "D50", NA, NA, NA, NA, NA, NA, NA, NA, NA) 

OIR_05 <- c("StreamOrder", "RPRN_VEG_CNPY_CVR", "RPRN_VEG_UNDRSTRY_CVR", "RPRN_VEG_GC", "NTVE_HRB", "Number_of_dams_upstream.x", "D50", "Dams_per_sqkm", NA, NA, NA, NA)
OIR_01 <- c("LWD_FREQ", "BNK_STBLTY", "INCSN_HT", "CHN_INCSN", "WTTD_WT", "WDRatio", "Catchment_are_sqkm", NA, NA, NA, NA, NA)
OIR_001 <- c("Non_NTVE_HRB", "TotalN", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)

CGR_05 <- c("RPRN_VEG_CNPY_CVR", "RPRN_VEG_GC", "NTVE_HRB", "SDGE_RSH", "BNK_STBLTY", "TotalN", "INCSN_HT", "CHN_INCSN", "WTTD_WT", "Number_of_dams_upstream.x", "D50", "Dams_per_sqkm")
CGR_01 <- c("NON_NTVE_HRB", "LWD_FREQ", "OBSRVD_INVRT_RCHNSS", NA, NA, NA, NA, NA, NA, NA, NA, NA)

D50_05 <- c("StreamOrder", "RPRN_VEG_CNPY_CVR", "NON_NTVE_HRB", "pH", "INCSN_HT", "OBSRVD_INVRT_RCHNSS", "Dams_per_sqkm", NA, NA, NA, NA, NA)
D50_01 <- c("VEG_CMPLXTY", "RPRN_VEG_GC", "SDGE_RSH", "LWD_FREQ", "Number_of_dams_upstream.x", "TotalN", NA, NA, NA, NA, NA, NA)
D50_001 <- c("WTTD_WT", "WDRatio", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)

DSK_05 <- c("VEG_CMPLXTY","RPRN_VEG_CNPY_CVR", "NON_NTVE_HRB", "SDGE_RSH", "pH", "LWDVolume", "INCSN_HT", "OBSRVD_INVRT_RCHNSS", "TotalN", "D50", NA, NA)
DSK_01 <- c("RPRN_VEG_GC", "LWD_FREQ", "WTTD_WT", "Number_of_dams_upstream.x", "WDRatio", NA, NA, NA, NA, NA, NA, NA)

#TN <- data.frame(TN_05, TN_01)
#TP <- data.frame(TP_05, TP_01, TP_001)
#OIR <- data.frame(OIR_05, OIR_01, OIR_001)
#CGR <- data.frame(CGR_05, CGR_01) 
#D50 <- data.frame(D50_05, D50_01, D50_001)

AICResults <- data.frame(TN_05, TN_01, TP_05, TP_01, TP_001, OIR_05, OIR_01, OIR_001, CGR_05, CGR_01, D50_05, D50_01, D50_001, DSK_05, DSK_01)

write.csv(AICResults, "New Data/AICresults.csv")
