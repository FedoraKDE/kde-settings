NAME=kde-settings
VERSION=19-20
SVNTAG=${NAME}-${VERSION}

release: tag archive upload

tag: uncommitted-changes
	svn copy "$(shell LANG=en_US.UTF-8 svn info | grep '^URL: ' | sed -e 's/^[^:]*: //')" \
	"$(shell LANG=en_US.UTF-8 svn info | grep '^Repository Root: ' | sed -e 's/^[^:]*: //')/tags/$(SVNTAG)" \
	-m "tagged release $(VERSION)"

archive:
	$(eval $@_TMPDIR:=$(shell mktemp -d))
	cd "$($@_TMPDIR)"; svn export --force $(shell LANG=en_US.UTF-8 svn info | grep '^Repository Root: ' | sed -e 's/^[^:]*: //')/tags/$(SVNTAG) "$($@_TMPDIR)"/${NAME}-${VERSION}
	rm -f "$($@_TMPDIR)"/${NAME}-${VERSION}/Makefile
	cd "$($@_TMPDIR)"; tar cvJf ${NAME}-${VERSION}.tar.xz ${NAME}-${VERSION}
	mv "$($@_TMPDIR)"/${NAME}-${VERSION}.tar.xz .
	rm -rf "$($@_TMPDIR)"
	echo "The archive is in ${NAME}-${VERSION}.tar.xz"

snapshot:
	$(eval $@_TMPDIR:=$(shell mktemp -d))
	cd "$($@_TMPDIR)"; svn export --force $(shell LANG=en_US.UTF-8 svn info | grep '^Repository Root: ' | sed -e 's/^[^:]*: //')/trunk/$(NAME) "$($@_TMPDIR)"/${NAME}-${VERSION}
	rm -f "$($@_TMPDIR)"/${NAME}-${VERSION}/Makefile
	cd "$($@_TMPDIR)"; tar cvJf ${NAME}-${VERSION}-snapshot.tar.xz ${NAME}-${VERSION}
	mv "$($@_TMPDIR)"/${NAME}-${VERSION}-snapshot.tar.xz .
	rm -rf "$($@_TMPDIR)"
	echo "The archive is in ${NAME}-${VERSION}-snapshot.tar.xz"

upload:
	scp -p ${NAME}-${VERSION}.tar.xz "$(shell LANG=en_US.UTF-8 svn info | grep '^URL: ' | sed -e 's/^[^:]*: //' -e 's!^[^:]*://!!' -e 's!svn.fedorahosted.org/.*$$!!')fedorahosted.org:kde-settings"

uncommitted-changes:
	@svn status
	@test -z "$(shell LANG=en_US.UTF-8 svn status)"
