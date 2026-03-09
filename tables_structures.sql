CREATE TABLE Localizaciones(
			codigo SMALLINT,
			localidad VARCHAR(25),
			provincia VARCHAR(17),
			cod_pos SMALLINT UNIQUE,
			PRIMARY KEY (codigo)
);

CREATE TABLE Direcciones(
			calle VARCHAR(25),
			num SMALLINT,
			codciu SMALLINT,
			piso SMALLINT,
			depto SMALLINT,
			PRIMARY KEY (calle,num,codciu),
			FOREIGN KEY (codciu) REFERENCES Localizaciones(codigo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Docentes ( 
dni INT,
nombres VARCHAR(30) NOT NULL,
Apellido VARCHAR(25) NOT NULL,
fecha_nac DATE, 
cuit INT NOT NULL UNIQUE,
legajo INT NOT NULL, 
nacionalidad VARCHAR(15) NOT NULL, 
estadocivil VARCHAR(7),
email VARCHAR(35) NOT NULL,
telefono BIGINT NOT NULL,
calle VARCHAR(25),
num SMALLINT NOT NULL,
codciu SMALLINT NOT NULL,
PRIMARY KEY (dni),
FOREIGN KEY(calle,num,codciu) REFERENCES Direcciones (calle, num, codciu) 
)
;


CREATE TABLE Familiares (
		documento INT,
		tipo_doc VARCHAR (5) DEFAULT 'dni',
		nombres VARCHAR (30) NOT NULL, 
		apellido VARCHAR (25) NOT NULL, 
		fecha_nac DATE, 
		PRIMARY KEY (documento)
)
;
CREATE TABLE Obras_Sociales(
	id SMALLINT,
	plan VARCHAR(15) NOT NULL,
	nombreos VARCHAR(30) NOT NULL,
	PRIMARY KEY (id)
)
;
CREATE TABLE Cuenta_con (
	idos SMALLINT,
	docente INT,
	fecha_firma DATE,
	PRIMARY KEY (docente, idos),
	FOREIGN KEY (docente) REFERENCES Docentes (dni)ON DELETE CASCADE,
 	FOREIGN KEY (idos) REFERENCES Obras_Sociales (id)

)
;
CREATE TABLE Alcanzado_por (
	docente INT,
	idos SMALLINT,
	familiar INT,
	parentesco VARCHAR(15) NOT NULL,
	PRIMARY KEY(familiar, docente, idos),
	FOREIGN KEY (familiar) REFERENCES Familiares(documento) ON DELETE CASCADE,
	FOREIGN KEY (docente,idos) REFERENCES Cuenta_con(docente,idos) ON DELETE CASCADE
)
;
CREATE TABLE Idiomas (
	instituto VARCHAR (15),
	certif VARCHAR (15),
	nombre_idioma VARCHAR (10) NOT NULL,
	nivel VARCHAR (2) NOT NULL,
	PRIMARY KEY (instituto, certif)
)
;
CREATE TABLE Saben (
	docente INT,
	instituto VARCHAR (15),
	certif VARCHAR (15),
	PRIMARY KEY (docente, instituto, certif),
	FOREIGN KEY (docente) REFERENCES Docentes(dni) ON DELETE CASCADE,
	FOREIGN KEY (instituto, certif) REFERENCES Idiomas(instituto, certif)
	
)
;
CREATE TABLE Seguros (
	docente INT,
	rsaseg VARCHAR(50),
	fecha_firma DATE,
	tipo_seguro VARCHAR(15) NOT NULL,
	cap_aseg FLOAT (8,2),
	PRIMARY KEY(docente, rsaseg),
	FOREIGN KEY (docente) REFERENCES Docentes (dni) ON DELETE CASCADE 

)
;
CREATE TABLE Se_beneficia (
	rsaseg VARCHAR(50),
	docente INT,
	familiar INT,
	parentesco VARCHAR(15),
	PRIMARY KEY(rsaseg, docente, familiar),
	FOREIGN KEY (docente,rsaseg) REFERENCES Seguros(docente, rsaseg) ON DELETE CASCADE,
	FOREIGN KEY (familiar) REFERENCES Familiares (documento) ON DELETE CASCADE
)
;
	
CREATE TABLE Pasividades (
	id INT,
	nombre VARCHAR (15),
	desde  DATE,
	regimen   VARCHAR(15),
	causa VARCHAR (30) NOT NULL,
	abonado_por VARCHAR (20),
	percibido BOOLEAN NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Publicaciones (
	id_publi SMALLINT,
	nombre VARCHAR (50) NOT NULL,
	referencia VARCHAR (30) NOT NULL,
	año SMALLINT,
	coautores VARCHAR (80),
	PRIMARY KEY (id_publi)
)
;

CREATE TABLE Realizaron_publicaciones (
		docente INT, 
		id_publi SMALLINT, 
		PRIMARY KEY (docente, id_publi),
		FOREIGN KEY (docente) REFERENCES Docentes (dni) ON DELETE CASCADE,
		FOREIGN KEY (id_publi) REFERENCES Publicaciones (id_publi) ON DELETE CASCADE
)
;
	
CREATE TABLE Titulos ( 
		nombre VARCHAR(35), 
		instituto VARCHAR(25),
		nivel VARCHAR(8) NOT NULL, 
		PRIMARY KEY (nombre,instituto) 
)
;

CREATE TABLE Pertenecen(
			docente INT,
			nombre VARCHAR(35),
			instituto VARCHAR(25),
			fecha_i DATE NOT NULL,
			fecha_t DATE, 
			PRIMARY KEY (docente,nombre,instituto),
			FOREIGN KEY (docente) REFERENCES Docentes(dni) ON DELETE CASCADE,
			FOREIGN KEY (nombre,instituto) REFERENCES Titulos(nombre,instituto)
);
CREATE TABLE CursosConferencias (
		id INT, 
		descripcion VARCHAR(30) NOT NULL,
		desde DATE, 
		hasta DATE, 
		PRIMARY KEY (id)
)
;
CREATE TABLE Asisten (
		cursoconf INT,
		docente INT, 
		PRIMARY KEY (cursoconf, docente), 
		FOREIGN KEY (cursoconf) REFERENCES CursosConferencias(id),
		FOREIGN KEY (docente) REFERENCES Docentes (dni) ON DELETE CASCADE
) 
;
CREATE TABLE Investigaciones (
		id_inv INT, 
		institucion VARCHAR(30) NOT NULL, 
		area_ppal VARCHAR(20), 
		categoria VARCHAR(15),
		dedicacion VARCHAR(20) NOT NULL,
		desde DATE, 
		hasta DATE, 
		PRIMARY KEY(id_inv)
)
;
CREATE TABLE Realizan (
		id_inv INT,
		docente INT,
PRIMARY KEY (docente, id_inv),
FOREIGN KEY (id_inv) REFERENCES Investigaciones (id_inv)ON DELETE CASCADE,
FOREIGN KEY (docente) REFERENCES Docentes (dni)ON DELETE CASCADE
)
;
CREATE TABLE R_Cientificas (
		titulo VARCHAR(20),
		f_realizacion DATE, 
		PRIMARY KEY(titulo, f_realizacion)
)
;
		


CREATE TABLE Participan (
			titulo VARCHAR(20),
			f_realizacion DATE, 
			docente INT,
			rol VARCHAR(10),
			PRIMARY KEY (titulo, f_realizacion, docente),
			FOREIGN KEY (titulo, f_realizacion) REFERENCES R_Cientificas(titulo, f_realizacion) ON DELETE CASCADE,
			FOREIGN KEY (docente) REFERENCES Docentes(dni) ON DELETE CASCADE
);
CREATE TABLE Actividades (
			id_activ INT,
			f_ingreso DATE NOT NULL,
			activo_al_reg BOOLEAN NOT NULL,
			fecha_sal DATE,
			cargo VARCHAR(20) NOT NULL, 
			PRIMARY KEY (id_activ)
);
	
CREATE TABLE Otras_Ocupaciones (
id_activ INT,
docente INT,
autonomo BOOLEAN,
dependencia VARCHAR(30),
PRIMARY KEY (id_activ),
FOREIGN KEY (docente) REFERENCES Docentes(dni) ON DELETE CASCADE,
FOREIGN KEY (id_activ) REFERENCES Actividades(id_activ) ON UPDATE CASCADE ON DELETE CASCADE	
);


CREATE TABLE Dependencias_Univ(
				id INT, 
				reparticion_Univ VARCHAR(50) NOT NULL,
				dependencia VARCHAR(50) NOT NULL,
				calle VARCHAR(25) NOT NULL,
				num SMALLINT NOT NULL,
				codciu SMALLINT NOT NULL,
				PRIMARY KEY (id),
				FOREIGN KEY (calle,num,codciu) REFERENCES Direcciones(calle,num,codciu)
				
);
CREATE TABLE Actividades_Univ (
		id_activ INT,
lugar_trab INT NOT NULL, 
		docente INT NOT NULL ,
		catedra VARCHAR(15), 
		acciones VARCHAR(40),
		PRIMARY KEY(id_activ),
		FOREIGN KEY (id_activ) REFERENCES Actividades(id_activ) ON DELETE CASCADE ON UPDATE CASCADE, 
		FOREIGN KEY (docente) REFERENCES Docentes (dni)ON DELETE CASCADE,
		FOREIGN KEY (lugar_trab) REFERENCES Dependencias_Univ(id)
)
;
CREATE TABLE Horarios (
		id SMALLINT, 
		dia VARCHAR(9) NOT NULL , 
		hora_ent TIME NOT NULL, 
		hora_sal TIME NOT NULL, 
		PRIMARY KEY (id)
)
;		
CREATE TABLE Contemplan (
		id_horario SMALLINT, 
		id_activuniv INT, 
        PRIMARY KEY (id_horario,id_activuniv),
		FOREIGN KEY (id_horario) REFERENCES Horarios (id),
 		FOREIGN KEY (id_Activuniv) REFERENCES Actividades_Univ (id_activ) ON DELETE CASCADE
)
;
	     

	      


CREATE TABLE Declaracion_Jurada(
			añofirma SMALLINT, 
			docente INT,
			PRIMARY KEY (añofirma, docente),
			FOREIGN KEY (docente) REFERENCES Docentes(dni) ON DELETE CASCADE 
)

;

CREATE TABLE Declaran(
			añofirma SMALLINT,
			docente INT,
			id_activ INT, 
			PRIMARY KEY (id_activ, docente, añofirma),
			FOREIGN KEY (id_activ) REFERENCES Actividades(id_activ),
			FOREIGN KEY (añofirma, docente) REFERENCES Declaracion_Jurada(añofirma, docente) ON DELETE CASCADE
)
;
CREATE TABLE Declaran_pas(
				idpas INT, 
				docente INT, 
				añofirma SMALLINT, 
				PRIMARY KEY (idpas, docente, añofirma),
				FOREIGN KEY (idpas) REFERENCES Pasividades(id),
				FOREIGN KEY (añofirma, docente) REFERENCES Declaracion_Jurada(añofirma, docente)ON DELETE CASCADE
)
;
CREATE TABLE Se_encarga (
idos SMALLINT,
	id_activ INT,
PRIMARY KEY (idos,id_activ),
FOREIGN KEY (idos) REFERENCES Obras_sociales(id),
FOREIGN KEY (id_activ) REFERENCES Actividades(id_activ)
);			
