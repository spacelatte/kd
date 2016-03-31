
TMP = .temp

all: clean depend default

depend:
	@mkdir users machines 2>/dev/null || true

clean:
	@-rm -rf $(TMP)

default:
	@mkdir $(TMP); \
	find machines | tail -n+2 | while read x; do \
		FNAME=$$(basename $$x); \
		ADDR=$$(echo "$$FNAME" | rev | cut -d. -f3- | rev); \
		USER=$$(echo "$$FNAME" | rev | cut -d. -f2 | rev); \
		echo "compiling $$USER@$$ADDR"; \
		mkdir $(TMP)/$$ADDR; \
		touch $(TMP)/$$ADDR/$$USER; \
		cat machines/$$FNAME | grep . | grep -v '^#' | tail -n+2 | while read y; do \
			echo "adding: $$y"; \
			cat users/$$y.pub >> $(TMP)/$$ADDR/$$USER; \
		done; \
		echo "Enter password for \"$$(cat machines/$$FNAME | grep . | grep -v '^#' | head -1)\" if prompted..."; \
		cat $(TMP)/$$ADDR/$$USER | ssh $$USER@$$ADDR 'cat > .ssh/authorized_keys'; \
		echo "$$USER@$$ADDR aka \"$$(cat machines/$$FNAME | grep . | grep -v '^#' | head -1)\" is completed"; \
	done
