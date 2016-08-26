
instdir= /usr/local/www/cgi-bin

all: sliderdns-altering

sliderdns-altering:
	cat sliderdns-altering.pl > sliderdns-altering.cgi
.for i in _alt_*.pl _all_*.pl
	cat $(i) >> sliderdns-altering.cgi
.endfor
	chmod 755 sliderdns-altering.cgi
	perl -c sliderdns-altering.cgi

clean:
	rm -f sliderdns-altering.cgi

install:
	scp sliderdns-altering.cgi hst.antares.km.ua:/home/old/
#	install sliderdns-altering.cgi $(instdir)

