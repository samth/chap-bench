run:
	raco make -v *rkt
	echo "Running Racket"
	racket proc-bm.rkt
	echo ""
	echo "Running plain JS"
	js proc-bm.js
	echo "Running Jaegermonkey"
	js -m proc-bm.js
	echo "Running Jaegermonkey + TI"
	js -m -n proc-bm.js
	
