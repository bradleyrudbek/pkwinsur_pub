# 002-FeatEng_Prep.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
#	Here we do the variable transformations
#	we will need for modelling, but in the end
#	we decided to do some EDA on the pre-modelling
#	dataset as well for insights, thats why cm2 is inserted back here
#	again
#
#	This will be used for EDA and Modelling Steps
#
#
#


	# we want to perform all transformations at once here
        # before we do any test-set split, to make sure
        # the factor levels will be all aligned
        m2 <- m1

	# Stage 1 Transforms

        m2$VehPower <- as.factor(pmin(m1$VehPower,9))
        m2$VehGas  <- as.factor(m1$VehGas)
        m2$VehAge   <- cut(m1$VehAge, breaks = c(0,2,5,10,15,Inf), include.lowest = TRUE, ordered_result = TRUE)
        m2$DrivAge <-  cut(m1$DrivAge, breaks = c(18,25,35,45,55,Inf), include.lowest = TRUE, ordered_result = TRUE)
        m2$Density <-  cut(m1$Density, breaks = c(0,100,200,500,1000,Inf),  include.lowest = TRUE, ordered_result = TRUE)

        m2$BonusMalus <-  as.integer(pmin(m1$BonusMalus, 150))

	cm2 <- subset(m2, !is.na(sumClaims))
	# Pushing Stage 2 Transformations here to avoid the Hassle of NAs

	cm2$sumClaims <- pmin(cm2$sumClaims,15000)
        cm2$AvgClaims <- cm2$sumClaims/cm2$ClaimNb
        cm2$target <- cm2$AvgClaims/cm2$Exposure
        cm2$target <- pmin(cm2$target,150000)


	# Now we have to merge target and AvgClaims back to m2 so we don't break the
	# Data_Split Pipeline
        m2 <- merge(m2 , subset(cm2, select = c(IDpol,AvgClaims,target)), all.x = TRUE, all.y = TRUE, by = 'IDpol')
