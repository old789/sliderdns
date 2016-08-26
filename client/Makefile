
Targa= sliderdns-client.pl
instdir= /usr/local/sbin/

all:
	cat sliderdns-client_.pl > $(Targa)
.for i in _*.pl 
	cat $(i) >> $(Targa)
.endfor
	chmod 755 $(Targa)
	perl -c $(Targa)

clean:
	rm -f $(Targa)

install:
	install $(Targa) $(instdir)

