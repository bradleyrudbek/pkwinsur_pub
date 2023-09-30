# 001-Data_Import.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
# 
#	Imports data for Exploratoriy data Analysis
#	little to no FE, just checking consistency of keys
#	between datasets
#
#	
#


require('farff')

	if (exists('init.setrenv')) {
		# it means we are running inside R in a Terminal
        	Mfreq <- readARFF(trunk('data/freMTPL2freq.arff'))
        	Msev <- readARFF(trunk('data/freMTPL2sev.arff'))
	} else {
		# it means we are running in a Notebook 
		Mfreq <- readARFF('../trunk/data/freMTPL2freq.arff')
		Msev <- readARFF('../trunk/data/freMTPL2sev.arff')
	}

	# First merging datasets
        Mfreq$Claim <- ifelse(Mfreq$ClaimNb > 0, 1 , 0)
        list_ids_with_claim <- subset(Mfreq, Claim == 1, select = 'IDpol')[[1]]
        list_ids_with_msev <- unique(Msev$IDpol)
        nuMInterc <- sum(list_ids_with_msev %in% list_ids_with_claim) # 29444
        # but we have to remove IDpol 4158255
        msevinfreq <- list_ids_with_msev[list_ids_with_msev %in% Mfreq$IDpol]
        msevinfreq <- msevinfreq[msevinfreq != 4158255]
        # now for these we calculate the sum of claims per IDPol
        msev2 <- subset(Msev, IDpol %in% msevinfreq)
        msev3 <- data.frame(IDpol =  as.numeric(names(tapply(msev2$ClaimAmount, msev2$IDpol, sum))), sumClaims = as.vector(tapply(msev2$ClaimAmount, msev2$IDpol, sum)))
        m1 <- merge(Mfreq , msev3, all.x = TRUE, all.y = FALSE, by = 'IDpol')
        cm1 <- subset(m1, !is.na(sumClaims))
        cm1$target <- cm1$sumClaims/cm1$Exposure
        # We stop here for EDA
