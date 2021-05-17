SHELL = /bin/bash

CURRENT_CONDA_ENV_NAME = artic-ncov2019-illumina
# Note that the extra activate is needed to ensure that the activate floats env to the front of PATH
CONDA_ACTIVATE = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate $(CURRENT_CONDA_ENV_NAME)

FASTQS = .github/data/fastqs/

SCHEMES_PATH = /home/Hanna/Documents/

NAME = test_data

define colourcyan
      @tput setaf 6
      @echo $1
      @tput sgr0
endef

define colourred
      @tput setaf 1
      @echo $1
      @tput sgr0
endef

define colourgreen
      @tput setaf 2
      @echo $1
      @tput sgr0
endef


anvandning:
	@echo ""
	$(call colourred, "För att köra pipelinen krävs det att conda miljö definierad i: environments/illumina/environment.yml har skapats innan.")
	@echo ""
	@echo ""
	@echo "Alternativen för att hantera/köra gms-artic pipelinen:"
	$(call colourgreen, "make pangoLearn_version")
	@echo "Kollar vilken version av pangoLearn är installerad i conda miljön: $(CURRENT_CONDA_ENV_NAME)"
	@echo ""
	@echo ""
	$(call colourgreen, "make pango_version")
	@echo "Visar vilken version av pangolin är installerad i conda miljön: $(CURRENT_CONDA_ENV_NAME)"
	@echo ""
	@echo ""
	$(call colourgreen, "make uppdatera_pangolin")
	@echo "Uppdaterar både pangolin och pangoLearn till de nyaste versionerna (kräver åtkomst till internet)"
	@echo ""
	@echo ""
	$(call colourgreen, "make ladda_ner_primer_schemes")
	@echo "Kommandot utför följande steg:"
	@echo "1. Raderar bort de gamla primer schemesen från: '$(SCHEMES_PATH)primer-schemes'-mappen"
	@echo "2. Laddar ner de senaste primer schemes:en med kommandot: git clone https://github.com/artic-network/primer-schemes.git"
	@echo "   primer schemesen laddas ner till den mapp som definieras i make variabeln på rad 9 in Makefile:n"
	@echo ""
	@echo ""
	$(call colourgreen, "make starta_gms-artic")
	@echo "Testkör gms-artic pipelinen med test data som kom med ursprungliga klonandet (git clone https://github.com/genomic-medicine-sweden/gms-artic.git) av pipeline mjukvaran"
	@echo ""
	@echo ""
	$(call colourgreen, "make starta_gms-artic FASTQS=/den_absoluta_pathen/till/fastq-filerna/ NAME=GEMENSAMT_NAMN_FÖR_PROVEN")
	@echo "Kör gms-artic med följande kommandoradsinputargumenten:"
	@echo -e "FASTQS:\tDen absoluta sökvägen (pathen) till input fastq-filerna"
	@echo -e "NAME:\tEtt gemensamt namn till alla input filerna (resultat mappen för konsensus-sekvensen/sekvenserna kommer att heta det här)"
	@echo ""

pangoLearn_version:
	@echo "Kollar vilken version av pangoLearn är installerad just nu i $(CURRENT_CONDA_ENV_NAME) conda miljöön..."
	@($(CONDA_ACTIVATE) ; pangolin -pv )

pango_version:
	@echo "Kollar vilken version av pangolin är installerad just nu i $(CURRENT_CONDA_ENV_NAME) conda miljöön..."
	@($(CONDA_ACTIVATE) ; pangolin -v )

uppdatera_pangolin:
	@echo "Uppdaterar pangolin..."
	@($(CONDA_ACTIVATE) ; pangolin --update )

ladda_ner_primer_schemes:
	@echo "Raderar eventualla primer scheman från mappen: $(SCHEMES_PATH)"
	@(cd $(SCHEMES_PATH) ; sudo rm -rf primer-schemes)
	@echo "Klonar primer scheman från Github till: $(SCHEMES_PATH)"
	@(cd $(SCHEMES_PATH) ; git clone https://github.com/artic-network/primer-schemes.git)

starta_gms-artic:
	@echo "NB: make ladda_ner_primer_schemes måste ha körts innan med internet uppkoppling på."
	@echo "Kör gms-artic pipelinen:"
	@($(CONDA_ACTIVATE) ; nextflow run main.nf -profile conda --illumina --prefix $(NAME) --directory $(FASTQS) --schemeRepoURL $(SCHEMES_PATH)primer-schemes/ -resume )
