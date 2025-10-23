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



# Etape 3 : Nettoyage des données  ----------------------------------------
ant <- ant[, !(names(ant) %in% c("field_name", "individual_no", "location_code"))]

# 2️⃣ Remplacer les codes de la colonne "pilosity"
ant$pilosity <- recode(ant$pilosity,
  "A" = "No hairs present en alitrunk profile",
  "B" = "Few (<A0) hairs present en alitrunk profile",
  "C" = "Moderately hairy (>A0 hairs present en alitrunk profile)",
  "D" = "Alitrunk densely hairy, or fuzzy in profile"
)

# 3️⃣ Remplacer les codes de la colonne "sculpturing"
ant$sculpturing <- recode(ant$sculpturing,
  "A" = "No marking",
  "B" = "Cuticule appears completely smooth, often shiny",
  "C" = "Shallow wrinkles/pits",
  "D" = "Surface heavily textured with ridges, grooves or pits"
)

# 4️⃣ Remplacer les codes de la colonne "environnement"
ant$environnement <- recode(ant$environnement,
  "OG" = "primary forest",
  "OP" = "oil palm plantation",
  "SF" = "logged forest"
)



# Etape 4 : Ajout des labels et des unités --------------------------------



# Etape 5 : Sauvegarde locale des données retravaillées -------------------

 
