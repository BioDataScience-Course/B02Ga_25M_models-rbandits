# Importation et remaniement des données


# Etape 1 : Importation des données brutes --------------------------------

ant<-read$xlsx("https://zenodo.org/records/1198839/files/template_Bishop.xlsx?download=1", cache_file = here::here("data", "cache", "ant.xlsx"), sheet = 4, skip = 9) |> janitor::clean_names()

# Conversion en numérique
ant$head_length   <- as.numeric(ant$head_length)
ant$head_width    <- as.numeric(ant$head_width)
ant$scape_length  <- as.numeric(ant$scape_length)
ant$eye_width     <- as.numeric(ant$eye_width)
ant$eye_length    <- as.numeric(ant$eye_length)
ant$inter_ocular  <- as.numeric(ant$inter_ocular)
ant$mandible_length <- as.numeric(ant$mandible_length)
ant$clypeus_width <- as.numeric(ant$clypeus_width)
ant$clypeus_length <- as.numeric(ant$clypeus_length)
ant$pronotum_width <- as.numeric(ant$pronotum_width)
ant$webers_length <- as.numeric(ant$webers_length)
ant$hind_femur    <- as.numeric(ant$hind_femur)
ant$hind_tibia    <- as.numeric(ant$hind_tibia)

# Conversion en facteur
ant$sting          <- as.factor(ant$sting)
ant$acidipore      <- as.factor(ant$acidipore)
ant$pilosity       <- as.factor(ant$pilosity)
ant$alitrunk_spines <- as.factor(ant$alitrunk_spines)
ant$petiolar_spines <- as.factor(ant$petiolar_spines)
ant$sculpturing    <- as.factor(ant$sculpturing)

# on simplifie les locations en spécificiant juste les 3 environnements au lieu de leur précision exacte 
ant$environnement <- substr(ant$location_code, 1, 2)

# Etape 2 : Description brève des données ---------------------------------

# Les données représentent les mesures morphologiques et l`abondance de 339 morphoespèces de fourmis capturées dans des fosses pédologiques. Ici, nous analysons tout particulièrement les mesures morphométriques des fourmis récoltées comme des valeurs numériques mesurés ou des présences ou non de certains éléments morphologiques selon le genre de la fourmi.
tabularise$headtail(ant) 

skimr::skim(ant)

# Etape 3 : Nettoyage des données  ----------------------------------------
ant <- ant[, !(names(ant) %in% c("field_name", "individual_no", "location_code"))]

# Remplacer les codes de la colonne "pilosity"
ant$pilosity <- recode(ant$pilosity,
  "A" = "No hairs present en alitrunk profile",
  "B" = "Few (<A0) hairs present en alitrunk profile",
  "C" = "Moderately hairy (>A0 hairs present en alitrunk profile)",
  "D" = "Alitrunk densely hairy, or fuzzy in profile"
)

# Remplacer les codes de la colonne "sculpturing"
ant$sculpturing <- recode(ant$sculpturing,
  "A" = "No marking",
  "B" = "Cuticule appears completely smooth, often shiny",
  "C" = "Shallow wrinkles/pits",
  "D" = "Surface heavily textured with ridges, grooves or pits"
)

# Remplacer les codes de la colonne "environnement"
ant$environnement <- recode(ant$environnement,
  "OG" = "primary forest",
  "OP" = "oil palm plantation",
  "SF" = "logged forest",
  "OF" = "primary forest"
)
# Création d'une colonne regroupant les 300 morphes en groupes
ant$morph2 <- stringr::str_remove(ant$morph,"\\d{1,2}")

# ajout d'une colonne de la sous famille 
subfamily_lookup <- tribble(
  ~morph2,          ~subfamily,
  "Acanthomyrmex",  "Myrmicinae",
  "Acropyga",       "Formicinae",
  "Aenictus",       "Dorylinae",
  "Amblyopone",     "Amblyoponinae",
  "Anochetus",      "Ponerinae",
  "Anochetus.Large","Ponerinae",
  "Aphaenogaster",  "Myrmicinae",
  "Calyptomyrmex",  "Myrmicinae",
  "Camponotus",     "Formicinae",
  "Camponotus.Maj", "Formicinae",
  "Cardiocondyla",  "Myrmicinae",
  "Carebara",       "Myrmicinae",
  "Centromyrmex",   "Ponerinae",
  "Cerapachys",     "Dorylinae",
  "Cladomyrma",     "Formicinae",
  "Crematogaster",  "Myrmicinae",
  "Cryptopone",     "Ponerinae",
  "Dacetinops",     "Myrmicinae",
  "Discothyrea",    "Proceratiinae",
  "Dolichoderus",   "Dolichoderinae",
  "Dorylus",        "Dorylinae",
  "Echinopla",      "Formicinae",
  "Euprenolepis",   "Formicinae",
  "Gnamptogenys",   "Ectatomminae",
  "Hypoponera",     "Ponerinae",
  "Leptogenys",     "Ponerinae",
  "Lordomyrma",     "Myrmicinae",
  "Lophomyrmex",    "Myrmicinae",
  "Megalomyrmex",   "Myrmicinae",
  "Meranoplus",     "Myrmicinae",
  "Monomorium",     "Myrmicinae",
  "Myrmecina",      "Myrmicinae",
  "Myrmicaria",     "Myrmicinae",
  "Myrmoteras",     "Formicinae",
  "Odontomachus",   "Ponerinae",
  "Oligomyrmex",    "Myrmicinae",
  "Ooceraea",       "Dorylinae",
  "Pheidole",       "Myrmicinae",
  "Pheidologeton",  "Myrmicinae",
  "Platythyrea",    "Ponerinae",
  "Plagiolepis",    "Formicinae",
  "Prenolepis",     "Formicinae",
  "Proceratium",    "Proceratiinae",
  "Pseudoneoponera","Ponerinae",
  "Recurvidris",    "Myrmicinae",
  "Rhytidoponera",  "Ponerinae",
  "Solenopsis",     "Myrmicinae",
  "Stigmatomma",    "Amblyoponinae",
  "Strumigenys",    "Myrmicinae",
  "Tapinoma",       "Dolichoderinae",
  "Technomyrmex",   "Dolichoderinae",
  "Tetramorium",    "Myrmicinae",
  "Tetraponera",    "Pseudomyrmecinae",
  "Vollenhovia",    "Myrmicinae", 
  "Epelysidris",      "Myrmicinae",
  "Eurhopalothrix",   "Myrmicinae",
  "Iridomyrmex",      "Dolichoderinae",
  "Loweriella",       "Formicinae",
  "Mayriella",        "Myrmicinae",
  "Mystrium",         "Amblyoponinae",
  "Nylanderia",       "Formicinae",
  "Ochetellus",       "Dolichoderinae",
  "Odontoponera",     "Ponerinae",
  "Pachycondyla",     "Ponerinae",
  "Paraparatrechina", "Formicinae",
  "Paratrechina",     "Formicinae",
  "Polyrachis",       "Formicinae",
  "Ponera",           "Ponerinae",
  "Pristomyrmex",     "Myrmicinae",
  "Proatta",          "Myrmicinae",
  "Probolomyrmex",    "Proceratiinae",
  "Proceratinum",     "Proceratiinae",
  "Protanilla",       "Leptanillinae",
  "Pseudolasius",     "Formicinae"
  
)

ant <- ant %>%
  left_join(subfamily_lookup, by = "morph2")

# Etape 4 : Ajout des labels et des unités --------------------------------
ant <- labelise(
  ant,
  
  label = list(
    morph = "Morphotype",
    head_length = "Longueur de la tête",
    head_width = "Largeur de la tête",
    scape_length = "Longueur du scape (antennal)",
    eye_width = "Largeur de l’œil",
    eye_length = "Longueur de l’œil",
    inter_ocular = "Distance interoculaire",
    mandible_length = "Longueur de la mandibule",
    clypeus_width = "Largeur du clypeus",
    clypeus_length = "Longueur du clypeus",
    pronotum_width = "Largeur du pronotum",
    webers_length = "Longueur de Weber",
    hind_femur = "Longueur du fémur postérieur",
    hind_tibia = "Longueur du tibia postérieur",
    sting = "Présence du dard",
    acidipore = "Présence d’un acidipore",
    pilosity = "Densité de la pilosité",
    alitrunk_spines = "Présence d’épines sur le mésosoma (alitrunk)",
    petiolar_spines = "Présence d’épines sur le pétiole",
    sculpturing = "Sculpture de la cuticule",
    environnement = "Type d’environnement"
  ),
  
  units = list(
    morph = NA,
    head_length = "mm",
    head_width = "mm",
    scape_length = "mm",
    eye_width = "mm",
    eye_length = "mm",
    inter_ocular = "mm",
    mandible_length = "mm",
    clypeus_width = "mm",
    clypeus_length = "mm",
    pronotum_width = "mm",
    webers_length = "mm",
    hind_femur = "mm",
    hind_tibia = "mm",
    sting = NA,
    acidipore = NA,
    pilosity = NA,
    alitrunk_spines = NA,
    petiolar_spines = NA,
    sculpturing = NA,
    environnement = NA
  )
)


# Etape 5 : Sauvegarde locale des données retravaillées -------------------
write$rds(ant, "data/ant.rds")

 
