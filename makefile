
TMP = .temp

.PHONY: machines/*

all: clean depend default clean

depend:
	@mkdir users machines 2>/dev/null || true

clean:
	@-rm -rf $(TMP)

machines/*.conf:
	@mkdir -p $(TMP) 2>/dev/null; \
	FNAME=$$(basename $@); \
	ADDR=$$(echo "$$FNAME" | rev | cut -d. -f3- | rev); \
	USER=$$(echo "$$FNAME" | rev | cut -d. -f2 | rev); \
	echo "compiling $$USER@$$ADDR"; \
	mkdir -p $(TMP)/$$ADDR 2>/dev/null; \
	touch $(TMP)/$$ADDR/$$USER; \
	cat machines/$$FNAME | grep . | grep -v '^#' | tail -n+2 | while read y; do \
		echo "adding: $$y"; \
		test -e "users/$$y.pub" && \
			cat users/$$y.pub >> $(TMP)/$$ADDR/$$USER; \
	done; \
	echo "Enter password for \"$$(cat machines/$$FNAME | grep . | grep -v '^#' | head -1)\" if prompted..."; \
	cat $(TMP)/$$ADDR/$$USER | ssh $$USER@$$ADDR 'cat > .ssh/authorized_keys'; \
	echo "$$USER@$$ADDR aka \"$$(cat machines/$$FNAME | grep . | grep -v '^#' | head -1)\" is completed"; \

default:
	@mkdir -p $(TMP) 2>/dev/null; \
	find machines | tail -n+2 | while read x; do \
		make $$x; \
	done

