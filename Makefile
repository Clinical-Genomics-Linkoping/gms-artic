SHELL=/bin/bash

CURRENT_CONDA_ENV_NAME=artic-ncov2019-illumina
# Note that the extra activate is needed to ensure that the activate floats env to the front of PATH
CONDA_ACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate $(CURRENT_CONDA_ENV_NAME)

FASTQS?=.github/data/fastqs/

NAME?=test_data

anvandning:
	@echo ""
	@echo "För att köra pipelinen krävs det att conda miljö definierad i: /home/Hanna/Documents/gms-artic/environments/illumina/environment.yml har skapats innan."
	@echo ""
	@echo ""
	@echo "Alternativen för att hantera/köra gms-artic pipelinen:"
	@echo ""
	@echo "make pangoLearn_version"
	@echo "Kollar vilken version av pangoLearn är installerad i conda miljön: $(CURRENT_CONDA_ENV_NAME)"
	@echo ""
	@echo ""
	@echo "make pango_version"
	@echo "Visar vilken version av pangolin är installerad i conda miljön: $(CURRENT_CONDA_ENV_NAME)"
	@echo ""
	@echo ""
	@echo "make uppdatera_pangolin"
	@echo "Uppdaterar både pangolin och pangoLearn till de nyaste versionerna (kräver åtkomst till internet)"
	@echo ""
	@echo ""
	@echo "make ladda_ner_primer_schemes"
	@echo "Kommandot utför följande steg:"
	@echo "1. Raderar bort de gamla primer schemesen från: /home/Hanna/Documents/primer-schemes mappen"
	@echo "2. Laddar ner senaste primer_schemes:en med kommandot: git clone https://github.com/artic-network/primer-schemes.git"
	@echo ""
	@echo ""
	@echo "make starta_gms-artic"
	@echo "Testkör gms-artic pipelinen med test data som kom med ursprungliga klonandet (git clone https://github.com/genomic-medicine-sweden/gms-artic.git) av pipeline mjukvaran"
	@echo ""
	@echo ""
	@echo "make starta_gms-artic FASTQS=/den_absoluta_pathen/till/fastq-filerna/ NAME=GEMENSAMT_NAMN_FÖR_PROVEN"
	@echo "Kör gms-artic med följande kommandoradsinput argumenten:"
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
	@echo "Klonar primer scheman från Github till: /home/Hanna/Documents/"
	@(cd /home/Hanna/Documents/ ; sudo rm -rf primer-schemes)
	@(cd /home/Hanna/Documents/ ; git clone https://github.com/artic-network/primer-schemes.git)

starta_gms-artic:
	@echo "NB: make ladda_ner_primer_schemes måste ha körts innan med internet uppkoppling på."
	@echo "Kör gms-artic pipelinen:"
	@($(CONDA_ACTIVATE) ; cd /home/Hanna/Documents/gms-artic ; nextflow run main.nf -profile conda --illumina --prefix $(NAME) --directory $(FASTQS) --schemeRepoURL /home/Hanna/Documents/primer-schemes/ -resume )
