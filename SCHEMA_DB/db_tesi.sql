CREATE TABLE utente (
  codice_fiscale CHAR(16) UNIQUE NOT NULL,
  nome VARCHAR(45) NOT NULL,
  cognome VARCHAR(45) NOT NULL,
  email VARCHAR(45) UNIQUE NOT NULL,
  password VARCHAR(45) NOT NULL,
  PRIMARY KEY(codice_fiscale));
  
CREATE TABLE difetto (
  codice_difetto CHAR(16) UNIQUE NOT NULL,
  descrizione_difetto VARCHAR(45) NOT NULL,
  PRIMARY KEY(codice_difetto));
  
CREATE DOMAIN valori_colore_componente AS TEXT
CHECK (VALUE='Verde' OR VALUE='Verde_scuro' OR VALUE='Giallo' OR VALUE='Arancione' OR VALUE='Rosso' OR VALUE='Grigio');

CREATE TABLE scheda_difettologica (
    id_scheda_difettologica SERIAL NOT NULL,
    nome_scheda VARCHAR(45) NOT NULL,
	codice_scheda INT NOT NULL,
	PRIMARY KEY (id_scheda_difettologica)
);

CREATE TABLE compila (
    codice_fiscale_utente CHAR(16) NOT NULL,
    id_scheda_difettologica SERIAL NOT NULL,
	data_compilazione DATE NOT NULL,
	ora_compilazione TIME NOT NULL,
	numero_difetti_lievi INT NOT NULL,
	numero_difetti_medi INT NOT NULL,
	numero_difetti_seri INT NOT NULL,
	numero_difetti_critici INT NOT NULL,
	k REAL NOT NULL,
	average_id REAL NOT NULL,
	ic_ij REAL DEFAULT 100.0 NOT NULL,
	colore_componente valori_colore_componente DEFAULT 'Grigio' NOT NULL,
	PRIMARY KEY (codice_fiscale_utente, id_scheda_difettologica),
	FOREIGN KEY (codice_fiscale_utente) REFERENCES utente(codice_fiscale) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_scheda_difettologica) REFERENCES scheda_difettologica(id_scheda_difettologica) ON UPDATE CASCADE ON DELETE CASCADE);
	
CREATE DOMAIN valori_g AS REAL
DEFAULT 0.0
CHECK (VALUE=0.2 OR VALUE=0.4 OR VALUE=0.6 OR VALUE=0.8 OR VALUE=1.0);

CREATE DOMAIN valori_e_i AS REAL
DEFAULT 0.0
CHECK (VALUE=0.2 OR VALUE=0.4 OR VALUE=0.6 OR VALUE=0.8 OR VALUE=1.0);

CREATE DOMAIN valori_tipologia_difetto AS TEXT
CHECK (VALUE='Slight' OR VALUE='Medium' OR VALUE='Serious' OR VALUE='Critical');

CREATE TABLE composta_da (
    id_scheda_difettologica SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	g valori_g,
	e valori_e_i,
	i valori_e_i,
	ps BOOLEAN,
	alpha REAL,
	id REAL,
	tipologia_difetto valori_tipologia_difetto NOT NULL,
	PRIMARY KEY (id_scheda_difettologica, codice_difetto),
	FOREIGN KEY (id_scheda_difettologica) REFERENCES scheda_difettologica(id_scheda_difettologica) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT);
	
CREATE TABLE materiale_costruttivo (
	id_materiale_costruttivo SERIAL NOT NULL,
	nome_materiale_costruttivo VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_materiale_costruttivo)
);

CREATE TABLE trave (
	id_trave SERIAL NOT NULL,
	id_materiale_costruttivo SERIAL NOT NULL,
	PRIMARY KEY(id_trave),
	FOREIGN KEY (id_materiale_costruttivo) REFERENCES materiale_costruttivo(id_materiale_costruttivo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE giunto (
	id_giunto SERIAL NOT NULL,
	tipologia_giunto VARCHAR(45) NOT NULL,
	larghezza_giunto_spalla REAL NOT NULL,
	larghezza_giunto_pila REAL NOT NULL,
	id_materiale_costruttivo SERIAL NOT NULL,
	PRIMARY KEY(id_giunto),
	FOREIGN KEY (id_materiale_costruttivo) REFERENCES materiale_costruttivo(id_materiale_costruttivo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE spalla (
	id_spalla SERIAL NOT NULL,
	tipologia_spalla VARCHAR(45) NOT NULL,
	fondazioni_spalla VARCHAR(45) NOT NULL,
	id_materiale_costruttivo SERIAL NOT NULL,
	PRIMARY KEY(id_spalla),
	FOREIGN KEY (id_materiale_costruttivo) REFERENCES materiale_costruttivo(id_materiale_costruttivo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE pila (
	id_pila SERIAL NOT NULL,
	tipologia_sezione VARCHAR(45) NOT NULL,
	tipologia_fondazioni VARCHAR(45) NOT NULL,
	altezza_pile REAL NOT NULL,
	geometria_sezione VARCHAR(45) NOT NULL,
	evoluzione_rispetto_fondo_alveo VARCHAR(45) NOT NULL,
	id_materiale_costruttivo SERIAL NOT NULL,
	PRIMARY KEY(id_pila),
	FOREIGN KEY (id_materiale_costruttivo) REFERENCES materiale_costruttivo(id_materiale_costruttivo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE impalcato (
	id_impalcato SERIAL NOT NULL,
	id_materiale_costruttivo SERIAL NOT NULL,
	PRIMARY KEY(id_impalcato),
	FOREIGN KEY (id_materiale_costruttivo) REFERENCES materiale_costruttivo(id_materiale_costruttivo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE cuscinetto (
	id_cuscinetto SERIAL NOT NULL,
	id_materiale_costruttivo SERIAL NOT NULL,
	PRIMARY KEY(id_cuscinetto),
	FOREIGN KEY (id_materiale_costruttivo) REFERENCES materiale_costruttivo(id_materiale_costruttivo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE soletta (
	id_soletta SERIAL NOT NULL,
	id_materiale_costruttivo SERIAL NOT NULL,
	PRIMARY KEY(id_soletta),
	FOREIGN KEY (id_materiale_costruttivo) REFERENCES materiale_costruttivo(id_materiale_costruttivo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE traverso (
	id_traverso SERIAL NOT NULL,
	id_materiale_costruttivo SERIAL NOT NULL,
	PRIMARY KEY(id_traverso),
	FOREIGN KEY (id_materiale_costruttivo) REFERENCES materiale_costruttivo(id_materiale_costruttivo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE sistemi_protezione_apparecchi_appoggio (
	id_sistemi SERIAL NOT NULL,
	tipo_sistema_protezione VARCHAR(45) NOT NULL,
	tipologia_apparecchi_appoggio VARCHAR(45) NOT NULL,
	larghezza_carreggiata REAL NOT NULL,
	tipologia_dispositivi_antisismici VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_sistemi)
);

CREATE TABLE assegnato_difetto_trave (
	id_trave SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_trave, codice_difetto),
	FOREIGN KEY (id_trave) REFERENCES trave(id_trave) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE assegnato_difetto_giunto (
	id_giunto SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_giunto, codice_difetto),
	FOREIGN KEY (id_giunto) REFERENCES giunto(id_giunto) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE assegnato_difetto_spalla (
	id_spalla SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_spalla, codice_difetto),
	FOREIGN KEY (id_spalla) REFERENCES spalla(id_spalla) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE assegnato_difetto_pila (
	id_pila SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_pila, codice_difetto),
	FOREIGN KEY (id_pila) REFERENCES pila(id_pila) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE assegnato_difetto_impalcato (
	id_impalcato SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_impalcato, codice_difetto),
	FOREIGN KEY (id_impalcato) REFERENCES impalcato(id_impalcato) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE assegnato_difetto_cuscinetto (
	id_cuscinetto SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_cuscinetto, codice_difetto),
	FOREIGN KEY (id_cuscinetto) REFERENCES cuscinetto(id_cuscinetto) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE assegnato_difetto_traverso (
	id_traverso SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_traverso,codice_difetto),
	FOREIGN KEY (id_traverso) REFERENCES traverso(id_traverso) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE assegnato_difetto_soletta (
	id_soletta SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_soletta,codice_difetto),
	FOREIGN KEY (id_soletta) REFERENCES soletta(id_soletta) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE assegnato_difetto_sistemi (
	id_sistemi SERIAL NOT NULL,
	codice_difetto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_sistemi, codice_difetto),
	FOREIGN KEY (id_sistemi) REFERENCES sistemi_protezione_apparecchi_appoggio(id_sistemi) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (codice_difetto) REFERENCES difetto(codice_difetto) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE rete_stradale (
	id_rete_stradale SERIAL NOT NULL,
	itinerario_internazionale BOOLEAN NOT NULL,
	rete_ten BOOLEAN NOT NULL,
	rete_emergenza BOOLEAN NOT NULL,
	numero_carreggiate INT NOT NULL,
	numero_corsie_carreggiata INT NOT NULL,
	presenza_curve BOOLEAN NOT NULL,
	traffico_medio_giornaliero INT NOT NULL,
	traffico_medio_giornaliero_veicoli_commerciali INT NOT NULL,
	traffico_medio_giornaliero_veicoli_commerciali_singolo INT NOT NULL,
	limitazione_carico REAL,
	presenza_alternative_stradali BOOLEAN NOT NULL,
	durata_deviazione_kilometri REAL,
	durata_deviazione_minuti INT,
	categoria_percorso_alternativo VARCHAR(45),
	studi_trasportistici_specifici BOOLEAN NOT NULL,
	allegato_studi_trasportistici INT,
	PRIMARY KEY(id_rete_stradale)
);

CREATE TABLE classe_conseguenza (
	id_classe_conseguenza SERIAL NOT NULL,
	nome_classe VARCHAR(15) NOT NULL,
	descrizione_classe VARCHAR(60),
	PRIMARY KEY(id_classe_conseguenza)
);

CREATE TABLE morfologia_sito (
	id_morfologia_sito SERIAL NOT NULL,
	nome_morfologia VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_morfologia_sito)
);

CREATE TABLE tipologia_strutturale (
	id_tipologia_strutturale SERIAL NOT NULL,
	nome_tipologia VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_tipologia_strutturale)
);

CREATE TABLE stato_opera (
	id_stato_opera SERIAL NOT NULL,
	nome_stato VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_stato_opera)
);

CREATE TABLE tipo_collegamento (
	id_tipo_collegamento SERIAL NOT NULL,
	nome_collegamento VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_tipo_collegamento)
);

CREATE TABLE classificazione_uso_stradale (
	id_classificazione_uso_stradale SERIAL NOT NULL,
	nome_classificazione VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_classificazione_uso_stradale)
);

CREATE TABLE autore_progettazione (
	id_autore_progettazione SERIAL NOT NULL,
	nome_autore VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_autore_progettazione)
);

CREATE TABLE proprietario (
	id_proprietario SERIAL NOT NULL,
	nome_proprietario VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_proprietario)
);

CREATE TABLE ente_vigilante (
	id_ente_vigilante SERIAL NOT NULL,
	nome_ente_vigilante VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_ente_vigilante)
);

CREATE TABLE ente_approvatore (
	id_ente_approvatore SERIAL NOT NULL,
	nome_ente_approvatore VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_ente_approvatore)
);

CREATE TABLE concessionario (
	id_concessionario SERIAL NOT NULL,
	nome_concessionario VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_concessionario)
);

CREATE TABLE progettista (
	id_progettista SERIAL NOT NULL,
	nome_progettista VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_progettista)
);

CREATE DOMAIN valori_tracciato AS TEXT
CHECK (VALUE='Rettilineo' OR VALUE='In_curva');

CREATE TABLE caratteristiche_geometriche (
	id_caratteristiche_geometriche SERIAL NOT NULL,
	luce_complessiva_estesa REAL NOT NULL,
	larghezza_totale_impalcato REAL NOT NULL,
	numero_campate INT NOT NULL,
	luce_campate REAL NOT NULL,
	tracciato valori_tracciato NOT NULL,
	PRIMARY KEY(id_caratteristiche_geometriche)
);

CREATE TABLE regione (
	codice_regione SERIAL NOT NULL,
	descrizione_regione VARCHAR(30) NOT NULL,
	PRIMARY KEY(codice_regione)
);

CREATE TABLE provincia (
	codice_provincia SERIAL NOT NULL,
	descrizione_provincia VARCHAR(30) NOT NULL,
	PRIMARY KEY(codice_provincia)
);

CREATE TABLE comune (
	codice_comune SERIAL NOT NULL,
	descrizione_comune VARCHAR(30) NOT NULL,
	PRIMARY KEY(codice_comune)
);

CREATE DOMAIN valori_tipo_coordinate_geografiche AS TEXT
CHECK (VALUE='ETRF2000' OR VALUE='WGS84');

CREATE TABLE localizzazione (
	id_localizzazione SERIAL NOT NULL,
	localita VARCHAR(45) NOT NULL,
	sismicita_area REAL NOT NULL,
	tipo_coordinate_geografiche valori_tipo_coordinate_geografiche NOT NULL,
	quota_slm_iniziale REAL NOT NULL,
	longitudine_iniziale DOUBLE PRECISION NOT NULL,
	latitudine_iniziale DOUBLE PRECISION NOT NULL,
	quota_slm_centro REAL NOT NULL,
	longitudine_centro DOUBLE PRECISION NOT NULL,
	latitudine_centro DOUBLE PRECISION NOT NULL,
	quota_slm_finale REAL NOT NULL,
	longitudine_finale DOUBLE PRECISION NOT NULL,
	latitudine_finale DOUBLE PRECISION NOT NULL,
	codice_regione SERIAL NOT NULL,
	codice_provincia SERIAL NOT NULL,
	codice_comune SERIAL NOT NULL,
	PRIMARY KEY(id_localizzazione),
	FOREIGN KEY (codice_regione) REFERENCES regione(codice_regione) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (codice_provincia) REFERENCES provincia(codice_provincia) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (codice_comune) REFERENCES comune(codice_comune) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE DOMAIN valori_fenomeni_erosivi_franosi_alluvionamento AS TEXT
CHECK (VALUE='Assenti' OR VALUE='Già_valutati' OR VALUE='Da_verificare');

CREATE DOMAIN valori_tipo_anno_data AS TEXT
CHECK (VALUE='Effettivo' OR VALUE='Presunto');

CREATE TABLE ponte (
	codice_iop CHAR(18) NOT NULL UNIQUE,
	strada_appartenteza VARCHAR(45) NOT NULL,
	nome_ponte VARCHAR(45) NOT NULL,
	progressiva_km_iniziale REAL NOT NULL,
	progressiva_km_finale REAL NOT NULL,
	provvedimenti_tutela VARCHAR(45) NOT NULL,
	norma_progetto VARCHAR(45) NOT NULL,
	inserimento_ponte_piani_paesaggistici VARCHAR(45) NOT NULL,
	ics REAL NOT NULL DEFAULT 100.0,
	fenomeni_franosi valori_fenomeni_erosivi_franosi_alluvionamento NOT NULL,
	fenomeni_erosivi_alluvionamento valori_fenomeni_erosivi_franosi_alluvionamento NOT NULL,
	anno_ultimazione_costruzione DATE NOT NULL,
	tipo_anno_ultimazione valori_tipo_anno_data NOT NULL,
	anno_interventi_sostanziali DATE NOT NULL,
	tipo_anno_interventi valori_tipo_anno_data NOT NULL,
	data_inizio_ponte DATE NOT NULL,
    tipo_data_inizio valori_tipo_anno_data NOT NULL,
	data_fine_ponte DATE NOT NULL,
	tipo_data_fine valori_tipo_anno_data NOT NULL,
	data_approvazione_ponte DATE NOT NULL,
	tipo_data_approvazione valori_tipo_anno_data NOT NULL,
	id_rete_stradale SERIAL NOT NULL,
	id_classe_conseguenza SERIAL NOT NULL,
	id_morfologia_sito SERIAL NOT NULL,
	id_tipologia_strutturale SERIAL NOT NULL,
	id_stato_opera SERIAL NOT NULL,
	id_tipo_collegamento SERIAL NOT NULL,
	id_classificazione_uso_stradale SERIAL NOT NULL,
	id_autore_progettazione SERIAL NOT NULL,
	id_proprietario SERIAL NOT NULL,
	id_ente_vigilante SERIAL NOT NULL,
	id_ente_approvatore SERIAL NOT NULL,
	id_concessionario SERIAL NOT NULL,
	id_progettista SERIAL NOT NULL,
	id_caratteristiche_geometriche SERIAL NOT NULL,
	id_localizzazione SERIAL NOT NULL,
	PRIMARY KEY (codice_iop),
	FOREIGN KEY (id_rete_stradale) REFERENCES rete_stradale(id_rete_stradale) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_classe_conseguenza) REFERENCES classe_conseguenza(id_classe_conseguenza) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_morfologia_sito) REFERENCES morfologia_sito(id_morfologia_sito) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_tipologia_strutturale) REFERENCES tipologia_strutturale(id_tipologia_strutturale) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_stato_opera) REFERENCES stato_opera(id_stato_opera) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_tipo_collegamento) REFERENCES tipo_collegamento(id_tipo_collegamento) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_classificazione_uso_stradale) REFERENCES classificazione_uso_stradale(id_classificazione_uso_stradale) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_autore_progettazione) REFERENCES autore_progettazione(id_autore_progettazione) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_proprietario) REFERENCES proprietario(id_proprietario) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_ente_vigilante) REFERENCES ente_vigilante(id_ente_vigilante) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_ente_approvatore) REFERENCES ente_approvatore(id_ente_approvatore) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_concessionario) REFERENCES concessionario(id_concessionario) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_progettista) REFERENCES progettista(id_progettista) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_caratteristiche_geometriche) REFERENCES caratteristiche_geometriche(id_caratteristiche_geometriche) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (id_localizzazione) REFERENCES localizzazione(id_localizzazione) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_trave (
	id_trave SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	PRIMARY KEY (id_trave, codice_iop_ponte),
	FOREIGN KEY (id_trave) REFERENCES trave(id_trave) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_giunto (
	id_giunto SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	numero_giunti_totale INT NOT NULL,
	PRIMARY KEY (id_giunto, codice_iop_ponte),
	FOREIGN KEY (id_giunto) REFERENCES giunto(id_giunto) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_spalla (
	id_spalla SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	numero_fondazioni_spalla INT NOT NULL,
	numero_fondazioni_totale INT NOT NULL,
	PRIMARY KEY (id_spalla, codice_iop_ponte),
	FOREIGN KEY (id_spalla) REFERENCES spalla(id_spalla) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_pila (
	id_pila SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	numero_fondazioni_pila INT NOT NULL,
	PRIMARY KEY (id_pila, codice_iop_ponte),
	FOREIGN KEY (id_pila) REFERENCES pila(id_pila) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_impalcato (
	id_impalcato SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	PRIMARY KEY (id_impalcato, codice_iop_ponte),
	FOREIGN KEY (id_impalcato) REFERENCES impalcato(id_impalcato) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_cuscinetto (
	id_cuscinetto SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	PRIMARY KEY (id_cuscinetto, codice_iop_ponte),
	FOREIGN KEY (id_cuscinetto) REFERENCES cuscinetto(id_cuscinetto) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_sistemi (
	id_sistemi SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	PRIMARY KEY (id_sistemi, codice_iop_ponte),
	FOREIGN KEY (id_sistemi) REFERENCES sistemi_protezione_apparecchi_appoggio(id_sistemi) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE intervento_strutturale (
    id_intervento_strutturale SERIAL NOT NULL,
	nome_intervento_strutturale VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_intervento_strutturale)
);

CREATE TABLE effettuato_su_strutturale (
	id_intervento_strutturale SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	descrizione_intervento_strutturale VARCHAR(45),
	PRIMARY KEY(id_intervento_strutturale, codice_iop_ponte),
	FOREIGN KEY(id_intervento_strutturale) REFERENCES intervento_strutturale(id_intervento_strutturale) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY(codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE piano_manutenzione (
    id_piano_manutenzione SERIAL NOT NULL,
	nome_piano_manutenzione VARCHAR(45) NOT NULL,
	numero_interventi INT NOT NULL,
	data_ultimo_intervento DATE NOT NULL,
	periodicita_manutenzione VARCHAR(45),
	PRIMARY KEY(id_piano_manutenzione)
);

CREATE TABLE intervento_manutenzione (
    id_intervento_manutenzione SERIAL NOT NULL,
	tipo_manutenzione VARCHAR(45) NOT NULL,
	numero_allegato_intervento INT NOT NULL,
	PRIMARY KEY(id_intervento_manutenzione)
);

CREATE TABLE composto_manutenzione (
	id_piano_manutenzione SERIAL NOT NULL,
	id_intervento_manutenzione SERIAL NOT NULL,
	PRIMARY KEY(id_piano_manutenzione,id_intervento_manutenzione),
	FOREIGN KEY(id_piano_manutenzione) REFERENCES piano_manutenzione(id_piano_manutenzione),
	FOREIGN KEY(id_intervento_manutenzione) REFERENCES intervento_manutenzione(id_intervento_manutenzione)
);

CREATE TABLE effettuato_su_manutenzione (
	id_intervento_manutenzione SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	data_manutenzione DATE NOT NULL,
	PRIMARY KEY(id_intervento_manutenzione,codice_iop_ponte),
	FOREIGN KEY(id_intervento_manutenzione) REFERENCES intervento_manutenzione(id_intervento_manutenzione),
	FOREIGN KEY(codice_iop_ponte) REFERENCES ponte(codice_iop)
);

CREATE TABLE programma_ispezione (
	id_programma_ispezione SERIAL NOT NULL,
	nome_programma_ispezione VARCHAR(45) NOT NULL,
	numero_ispezioni INT NOT NULL,
	data_ultima_ispezione DATE NOT NULL,
	periodicita_ispezione VARCHAR(45),
	PRIMARY KEY(id_programma_ispezione)
);

CREATE TABLE ente_ispezione (
	id_ente_ispettivo SERIAL NOT NULL,
	nome_ente_ispettivo VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_ente_ispettivo)
);

CREATE TABLE ispezione_pregressa (
	id_ispezione_pregressa SERIAL NOT NULL,
	tipo_ispezione VARCHAR(45) NOT NULL,
	numero_allegato_ispezione INT NOT NULL,
	risultato VARCHAR(45),
	id_ente_ispettivo SERIAL NOT NULL,
	PRIMARY KEY(id_ispezione_pregressa),
	FOREIGN KEY(id_ente_ispettivo) REFERENCES ente_ispezione(id_ente_ispettivo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_ispezione (
	id_programma_ispezione SERIAL NOT NULL,
	id_ispezione_pregressa SERIAL NOT NULL,
	PRIMARY KEY(id_programma_ispezione,id_ispezione_pregressa),
	FOREIGN KEY(id_programma_ispezione) REFERENCES programma_ispezione(id_programma_ispezione) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY(id_ispezione_pregressa) REFERENCES ispezione_pregressa(id_ispezione_pregressa) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE effettuata_ispezione (
	id_ispezione_pregressa SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	PRIMARY KEY(id_ispezione_pregressa,codice_iop_ponte),
	FOREIGN KEY(id_ispezione_pregressa) REFERENCES ispezione_pregressa(id_ispezione_pregressa) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY(codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE monitoraggio_pregresso_in_corso (
    id_monitoraggio SERIAL NOT NULL,
	tipo_rilevamento VARCHAR(45) NOT NULL,
	metodologia_monitoraggio VARCHAR(45) NOT NULL,
	tipologia_strumentazione VARCHAR(45) NOT NULL,
	grandezze_misurate VARCHAR(45) NOT NULL,
	risultati VARCHAR(45),
	livello_allerta VARCHAR(45) NOT NULL,
	documentazione VARCHAR(45),
	numero_allegato_documentazione INT,
	PRIMARY KEY(id_monitoraggio)
);

CREATE TABLE assegnato (
	id_monitoraggio SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	data_inizio_monitoraggio DATE,
	data_ultimo_aggiornamento DATE,
	data_fine_monitoraggio DATE,
	PRIMARY KEY(id_monitoraggio,codice_iop_ponte),
	FOREIGN KEY(id_monitoraggio) REFERENCES monitoraggio_pregresso_in_corso(id_monitoraggio) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY(codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE documento_progettuale (
    id_documento_progettuale SERIAL NOT NULL,
	nome_documento VARCHAR(45) NOT NULL, 
	PRIMARY KEY(id_documento_progettuale)
);

CREATE TABLE appartenente (
	id_documento_progettuale SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	fonte_documento VARCHAR(45) NOT NULL,
	numero_allegato_progettuale INT NOT NULL,
	PRIMARY KEY(id_documento_progettuale,codice_iop_ponte),
	FOREIGN KEY(id_documento_progettuale) REFERENCES documento_progettuale(id_documento_progettuale) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY(codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_traverso (
	id_traverso SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	PRIMARY KEY(id_traverso,codice_iop_ponte),
	FOREIGN KEY (id_traverso) REFERENCES traverso(id_traverso) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE composto_soletta (
	id_soletta SERIAL NOT NULL,
	codice_iop_ponte CHAR(18) NOT NULL,
	PRIMARY KEY(id_soletta,codice_iop_ponte),
	FOREIGN KEY (id_soletta) REFERENCES soletta(id_soletta) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (codice_iop_ponte) REFERENCES ponte(codice_iop) ON UPDATE CASCADE ON DELETE RESTRICT
);

