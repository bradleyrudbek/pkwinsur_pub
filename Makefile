.PHONY: clean copy 

clean:
	-rm -rf *.pdf notebooks/* code/*

copy:
	cp ../Rwork/sandbox/frosa-datachallenge.pdf präsi-datachallenge.pdf
	cp ../Rwork/trunk/progs/*R code/
	cp ../Rwork/sandbox/EDA-general.ipynb notebooks/
	cp ../Rwork/sandbox/Model-Training.ipynb notebooks/

push:
	git add .
	git commit -m 'auto commit'
	git push




