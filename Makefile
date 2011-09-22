NAME=kde-settings
VERSION=4.7-7
SVNTAG=${NAME}-${VERSION}

release: tag archive upload

tag:
	svn copy "$(shell LANG=en_US.UTF-8 svn info | grep '^URL: ' | sed -e 's/^[^:]*: //')" \
	"$(shell LANG=en_US.UTF-8 svn info | grep '^Repository Root: ' | sed -e 's/^[^:]*: //')/tags/$(SVNTAG)" \
	-m "tagged release $(VERSION)"

archive:
	TMPSUBDIR=$(shell mktemp -d)
	cd "$(TMPSUBDIR)"; svn export --force $(shell LANG=en_US.UTF-8 svn info | grep '^Repository Root: ' | sed -e 's/^[^:]*: //')/tags/$(SVNTAG) "$(TMPSUBDIR)"/${NAME}-${VERSION}
	rm -f "$(TMPSUBDIR)"/${NAME}-${VERSION}/Makefile
	cd "$(TMPSUBDIR)"; tar cvJf ${NAME}-${VERSION}.tar.xz ${NAME}-${VERSION}
	mv "$(TMPSUBDIR)"/${NAME}-${VERSION}.tar.xz .
	rm -rf "$(TMPSUBDIR)"
	echo "The archive is in ${NAME}-${VERSION}.tar.xz"

snapshot:
	TMPSUBDIR=$(shell mktemp -d)
	cd "$(TMPSUBDIR)"; svn export --force $(shell LANG=en_US.UTF-8 svn info | grep '^Repository Root: ' | sed -e 's/^[^:]*: //')/trunk/$(NAME) "$(TMPSUBDIR)"/${NAME}-${VERSION}
	rm -f "$(TMPSUBDIR)"/${NAME}-${VERSION}/Makefile
	cd "$(TMPSUBDIR)"; tar cvJf ${NAME}-${VERSION}-snapshot.tar.xz ${NAME}-${VERSION}
	mv "$(TMPSUBDIR)"/${NAME}-${VERSION}-snapshot.tar.xz .
	rm -rf "$(TMPSUBDIR)"
	echo "The archive is in ${NAME}-${VERSION}-snapshot.tar.xz"

upload:
	scp -p ${NAME}-${VERSION}.tar.xz "$(shell LANG=en_US.UTF-8 svn info | grep '^URL: ' | sed -e 's/^[^:]*: //' -e 's!^[^:]*://!!' -e 's!svn.fedorahosted.org/.*$!!')fedorahosted.org:kde-settings"
