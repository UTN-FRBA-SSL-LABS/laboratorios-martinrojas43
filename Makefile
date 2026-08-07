LABS = lab-github lab-compilacion-c lab-string laboratorio-testing-c lab-make lab-flex lab-bison

.PHONY: help grade grade-all

help:
	@echo "Uso:"
	@echo "  make grade LAB=lab-flex   Ejecuta y guarda la nota de un laboratorio"
	@echo "  make grade-all            Ejecuta los siete laboratorios"
	@echo ""
	@echo "Laboratorios: $(LABS)"

grade:
	@if [ -z "$(LAB)" ]; then \
		echo "Falta LAB. Ejemplo: make grade LAB=lab-flex"; \
		exit 64; \
	fi
	@./scripts/grade-lab.sh "$(LAB)"

grade-all:
	@status=0; \
	for lab in $(LABS); do \
		./scripts/grade-lab.sh "$$lab" || status=1; \
	done; \
	exit $$status
