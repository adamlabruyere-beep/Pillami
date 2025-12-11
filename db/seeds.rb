require "json"
require "open-uri"

# ============================================================
# SEED DE DÉVELOPPEMENT - Users, Médicaments, Reminders, Sensations
# ============================================================

puts "Nettoyage des données existantes..."
Sensation.destroy_all
Reminder.destroy_all
User.destroy_all
# On ne détruit pas les médicaments car ils viennent de l'API

# ============================================================
# UTILISATEURS
# ============================================================
puts "Création des utilisateurs..."

maxence = User.create!(
  email: "maxence@gmail.com",
  password: "password",
  prenom: "Maxence",
  nom: "Maho"
)

mamie = User.create!(
  email: "mamie@gmail.com",
  password: "password",
  prenom: "Mamie",
  nom: "Maho"
)

papa = User.create!(
  email: "papa@gmail.com",
  password: "password",
  prenom: "Papa",
  nom: "Maho"
)

puts "3 utilisateurs créés"

# ============================================================
# PILLATHÈQUE - Médicaments par utilisateur
# ============================================================
puts "Ajout des médicaments aux pillathèques..."

# Maxence - Gastro
PillathequeMedicament.create!(pillatheque: maxence.pillatheque, medicament: Medicament.find_by(nom: "DOLIPRANECAPS 1000 mg"))
PillathequeMedicament.create!(pillatheque: maxence.pillatheque, medicament: Medicament.find_by(nom: "SMECTA 3 g FRAISE"))
PillathequeMedicament.create!(pillatheque: maxence.pillatheque, medicament: Medicament.find_by(nom: "IMODIUMCAPS 2 mg"))

# Mamie - Diabète
PillathequeMedicament.create!(pillatheque: mamie.pillatheque, medicament: Medicament.find_by(nom: "METFORMINE ACCORD 1000 mg"))
PillathequeMedicament.create!(pillatheque: mamie.pillatheque, medicament: Medicament.find_by(nom: "JANUVIA 100 mg"))
PillathequeMedicament.create!(pillatheque: mamie.pillatheque, medicament: Medicament.find_by(nom: "INSULINE ASPARTE SANOFI 100 unités/ml"))
PillathequeMedicament.create!(pillatheque: mamie.pillatheque, medicament: Medicament.find_by(nom: "OZEMPIC 1 mg, solution injectable en stylo prérempli"))

# ============================================================
# ENTOURAGES
# ============================================================
puts "Configuration des entourages..."

# Créer les entourages pour chaque utilisateur
maxence_entourage = Entourage.create!(user: maxence, name: "Entourage de Maxence")
mamie_entourage = Entourage.create!(user: mamie, name: "Entourage de Mamie")
papa_entourage = Entourage.create!(user: papa, name: "Entourage de Papa")

# Maxence suit Mamie (Maxence est membre de l'entourage de Mamie)
mamie_entourage.add_member(maxence)

# Papa est accompagnant de Maxence (Papa est membre de l'entourage de Maxence)
maxence_entourage.add_member(papa)

# ============================================================
# REMINDERS
# ============================================================
puts "Création des reminders..."

# Maxence - Gastro (1 semaine de traitement)
Reminder.create!(
  user: maxence,
  calendrier: maxence.calendrier,
  medicament: Medicament.find_by(nom: "DOLIPRANECAPS 1000 mg"),
  time: Time.parse("12:00"),
  days_of_week: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday],
  quantity: 1,
  measure: "comprimé",
  active: true,
  repeat_for_weeks: 1
)

Reminder.create!(
  user: maxence,
  calendrier: maxence.calendrier,
  medicament: Medicament.find_by(nom: "SMECTA 3 g FRAISE"),
  time: Time.parse("14:00"),
  days_of_week: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday],
  quantity: 1,
  measure: "sachet",
  active: true,
  repeat_for_weeks: 1
)

Reminder.create!(
  user: maxence,
  calendrier: maxence.calendrier,
  medicament: Medicament.find_by(nom: "IMODIUMCAPS 2 mg"),
  time: Time.parse("10:00"),
  days_of_week: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday],
  quantity: 2,
  measure: "gélule",
  active: true,
  repeat_for_weeks: 1
)

# Mamie - Diabète type 2 (traitement de fond)
Reminder.create!(
  user: mamie,
  calendrier: mamie.calendrier,
  medicament: Medicament.find_by(nom: "METFORMINE ACCORD 1000 mg"),
  time: Time.parse("12:00"),
  days_of_week: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday],
  quantity: 1,
  measure: "comprimé",
  active: true,
  repeat_for_weeks: 10
)

# Alternative au combo Sitagliptine/Metformine (doublon de Metformine) :
# Medicament.find_by(nom: "JANUVIA 100 mg") - Sitagliptine seule, 1x/jour

Reminder.create!(
  user: mamie,
  calendrier: mamie.calendrier,
  medicament: Medicament.find_by(nom: "JANUVIA 100 mg"),
  time: Time.parse("08:00"),
  days_of_week: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday],
  quantity: 1,
  measure: "comprimé",
  active: true,
  repeat_for_weeks: 10
)

Reminder.create!(
  user: mamie,
  calendrier: mamie.calendrier,
  medicament: Medicament.find_by(nom: "INSULINE ASPARTE SANOFI 100 unités/ml"),
  time: Time.parse("20:00"),
  days_of_week: %w[Monday Wednesday Friday Sunday],
  quantity: 1,
  measure: "injection",
  active: true,
  repeat_for_weeks: 10
)

# Mamie - Ozempic 1x/semaine (injection hebdomadaire)
# Reminder.create!(
#   user: mamie,
#   calendrier: mamie.calendrier,
#   medicament: Medicament.find_by(nom: "OZEMPIC 1 mg, solution injectable en stylo prérempli"),
#   time: Time.parse("09:00"),
#   days_of_week: %w[Sunday],
#   quantity: 1,
#   measure: "injection",
#   active: true,
#   repeat_for_weeks: 10
# )


# ============================================================
# SENSATIONS
# ============================================================
puts "Création des sensations..."

# Maxence - 1 semaine de gastro
Sensation.create!(user: maxence, content: "Début de la gastro, nausées et crampes abdominales.", created_at: 7.days.ago)
Sensation.create!(user: maxence, content: "Nuit difficile, diarrhée fréquente. Très fatigué.", created_at: 6.days.ago)
Sensation.create!(user: maxence, content: "Le Smecta semble aider, moins de crampes.", created_at: 5.days.ago)
Sensation.create!(user: maxence, content: "Toujours fatigué mais les symptômes diminuent.", created_at: 4.days.ago)
Sensation.create!(user: maxence, content: "Meilleur appétit, j'ai pu manger un peu de riz.", created_at: 3.days.ago)
Sensation.create!(user: maxence, content: "Presque rétabli, juste une légère fatigue.", created_at: 2.days.ago)
Sensation.create!(user: maxence, content: "RAS, je me sens bien. Fin du traitement.", created_at: 1.day.ago)

# Mamie - 2 semaines de suivi diabète
Sensation.create!(user: mamie, content: "Glycémie stable ce matin : 1.2 g/L.", created_at: 14.days.ago)
Sensation.create!(user: mamie, content: "Légère fatigue en fin de journée.", created_at: 13.days.ago)
Sensation.create!(user: mamie, content: "Injection Ozempic bien tolérée.", created_at: 12.days.ago)
Sensation.create!(user: mamie, content: "Glycémie un peu haute après le repas : 1.8 g/L.", created_at: 11.days.ago)
Sensation.create!(user: mamie, content: "Bonne journée, pas de malaise.", created_at: 10.days.ago)
Sensation.create!(user: mamie, content: "Petit vertige ce matin, glycémie basse : 0.7 g/L.", created_at: 9.days.ago)
Sensation.create!(user: mamie, content: "Mieux aujourd'hui après ajustement du repas.", created_at: 8.days.ago)
Sensation.create!(user: mamie, content: "RAS, glycémie normale.", created_at: 7.days.ago)
Sensation.create!(user: mamie, content: "Injection Ozempic dimanche, légère nausée.", created_at: 6.days.ago)
Sensation.create!(user: mamie, content: "Nausée passée, tout va bien.", created_at: 5.days.ago)
Sensation.create!(user: mamie, content: "Glycémie stable : 1.1 g/L.", created_at: 4.days.ago)
Sensation.create!(user: mamie, content: "Bonne forme générale.", created_at: 3.days.ago)
Sensation.create!(user: mamie, content: "Légère soif inhabituelle.", created_at: 2.days.ago)
Sensation.create!(user: mamie, content: "RAS, contrôle glycémique satisfaisant.", created_at: 1.day.ago)


# ============================================================
# RÉSUMÉ
# ============================================================
puts ""
puts "=" * 60
puts "SEED TERMINÉ AVEC SUCCÈS!"
puts "=" * 60
puts "Utilisateurs: #{User.count}"
puts "Médicaments: #{Medicament.count}"
puts "Reminders: #{Reminder.count}"
puts "Sensations: #{Sensation.count}"
puts ""
puts "Comptes de test:"
puts "  - maxence@gmail.com / password"
puts "  - mamie@gmail.com / password"
puts "  - papa@gmail.com / password"
puts "=" * 60









































#//////////// SEED POUR MEDICAMENTS COURANTS EN FRANCE /////////////

# Médicaments les plus couramment utilisés en France
# MEDICAMENTS_COURANTS = [
#   # Douleur / Fièvre
#   "paracetamol", "doliprane", "efferalgan", "dafalgan",
#   "ibuprofene", "advil", "nurofen", "aspirine", "aspegic",
#   # Anti-inflammatoires
#   "ketoprofene", "diclofenac", "voltarene", "naproxene",
#   # Antibiotiques
#   "amoxicilline", "augmentin", "azithromycine", "zithromax",
#   "ciprofloxacine", "ofloxacine", "metronidazole",
#   "doxycycline", "penicilline", "cefixime",
#   # Allergies
#   "cetirizine", "zyrtec", "loratadine", "clarityne",
#   "desloratadine", "aerius", "bilastine",
#   # Estomac / Digestion
#   "omeprazole", "mopral", "pantoprazole", "esomeprazole",
#   "gaviscon", "smecta", "spasfon", "domperidone", "motilium",
#   "loperamide", "imodium", "lansoprazole",
#   # Cardiovasculaire
#   "amlodipine", "ramipril", "losartan", "valsartan",
#   "atenolol", "bisoprolol", "lisinopril", "enalapril",
#   "furosemide", "lasilix", "hydrochlorothiazide",
#   # Cholestérol
#   "atorvastatine", "tahor", "simvastatine", "rosuvastatine",
#   "pravastatine", "fenofibrate",
#   # Diabète
#   "metformine", "glucophage", "insuline", "glibenclamide",
#   "gliclazide", "sitagliptine", "januvia",
#   # Thyroïde
#   "levothyrox", "euthyrox",
#   # Anxiolytiques / Sommeil
#   "alprazolam", "xanax", "bromazepam", "lexomil",
#   "diazepam", "valium", "lorazepam", "temesta",
#   "zolpidem", "stilnox", "zopiclone", "imovane",
#   # Antidépresseurs
#   "sertraline", "zoloft", "fluoxetine", "prozac",
#   "paroxetine", "deroxat", "escitalopram", "seroplex",
#   "venlafaxine", "effexor", "duloxetine", "cymbalta",
#   # Respiratoire / Toux
#   "ventoline", "salbutamol", "seretide", "symbicort",
#   "flixotide", "singulair", "montelukast",
#   "codeine", "bronchokod", "carbocisteine", "acetylcysteine",
#   # Corticoïdes
#   "prednisolone", "solupred", "prednisone", "cortancyl",
#   "betamethasone", "dexamethasone",
#   # Anticoagulants
#   "kardegic", "plavix", "clopidogrel", "xarelto",
#   "eliquis", "pradaxa", "previscan",
#   # Contraception / Hormones
#   "pilule", "levonorgestrel", "ethinylestradiol",
#   "duphaston", "utrogestan", "progesterone",
#   # Douleurs neuropathiques
#   "pregabaline", "lyrica", "gabapentine", "neurontin",
#   # Migraine
#   "triptan", "sumatriptan", "zomig",
#   # Peau
#   "fucidine", "acide fusidique", "betadine", "biafine",
#   "dexeryl", "cicatryl", "diprosone",
#   # Yeux
#   "collyre", "vitamine a", "dulcilarme",
#   # Vitamines / Suppléments
#   "vitamine d", "uvedose", "vitamine b12", "fer", "tardyferon",
#   "magnesium", "magne b6", "acide folique", "speciafoldine",
#   # Autres courants
#   "tramadol", "lamaline", "toplexil", "humex", "actifed",
#   "fervex", "rhinadvil", "strepsil", "lysopaïne"
# ]

# # ============================================================
# # CONFIGURATION: Pour reprendre après un arrêt, modifier cette valeur
# # avec le nom du médicament affiché lors de l'arrêt
# # Mettre nil pour commencer depuis le début
# # ============================================================
# REPRENDRE_DEPUIS = "lysopaïne"

# MAX_RETRIES_429 = 5

# # Ne pas détruire les médicaments existants si on reprend
# if REPRENDRE_DEPUIS.nil?
#   Medicament.destroy_all
#   puts "Base nettoyée"
# else
#   puts "Reprise depuis: #{REPRENDRE_DEPUIS}"
# end

# # Charger les noms existants pour éviter les doublons
# noms_existants = Set.new(Medicament.pluck(:nom))
# puts "#{noms_existants.size} médicaments déjà en base"

# # Trouver l'index de départ
# start_index = 0
# if REPRENDRE_DEPUIS
#   start_index = MEDICAMENTS_COURANTS.index(REPRENDRE_DEPUIS)
#   if start_index.nil?
#     puts "ERREUR: '#{REPRENDRE_DEPUIS}' non trouvé dans la liste!"
#     exit
#   end
# end

# medicaments_crees = 0

# MEDICAMENTS_COURANTS[start_index..].each_with_index do |terme, idx|
#   index = start_index + idx
#   puts "Recherche #{index + 1}/#{MEDICAMENTS_COURANTS.size}: #{terme}..."

#   retries_429 = 0

#   begin
#     url = "https://medicaments-api.giygas.dev/medicament/#{URI.encode_www_form_component(terme)}"
#     response = URI.parse(url).read
#     items = JSON.parse(response)

#     next if items.nil?

#     items.each do |med|
#       nom = med["elementPharmaceutique"]
#       next if nom.blank? || noms_existants.include?(nom)

#       # Sauvegarde immédiate en base
#       Medicament.create!(
#         nom: nom,
#         format: med["formePharmaceutique"],
#         prise: med["voiesAdministration"],
#         ordonnance: !med["conditions"].nil?
#       )

#       noms_existants.add(nom)
#       medicaments_crees += 1
#       puts "  -> Créé: #{nom}"
#     end

#     sleep(0.35) # Respecte le rate limit de 3/sec

#   rescue OpenURI::HTTPError => e
#     if e.message.include?("429")
#       retries_429 += 1
#       puts "Rate limited (#{retries_429}/#{MAX_RETRIES_429}), pause 2s..."

#       if retries_429 >= MAX_RETRIES_429
#         puts ""
#         puts "=" * 60
#         puts "ARRÊT: 5 erreurs 429 consécutives sur '#{terme}'"
#         puts "=" * 60
#         puts "Pour reprendre, modifiez la ligne suivante dans seeds.rb:"
#         puts ""
#         puts "  REPRENDRE_DEPUIS = \"#{terme}\""
#         puts ""
#         puts "Médicaments créés cette session: #{medicaments_crees}"
#         puts "Total en base: #{Medicament.count}"
#         puts "=" * 60
#         exit
#       end

#       sleep(2)
#       retry
#     else
#       puts "Erreur pour #{terme}: #{e.message}"
#     end
#   rescue JSON::ParserError => e
#     puts "Erreur JSON pour #{terme}: #{e.message}"
#   end
# end

# puts ""
# puts "=" * 60
# puts "Terminé avec succès!"
# puts "Médicaments créés cette session: #{medicaments_crees}"
# puts "Total en base: #{Medicament.count} médicaments"
# puts "=" * 60

# ////////:/regex pour enlever le format aux noms des medicaments//////

# Medicament.find_each { |m| m.update(nom: m.nom.gsub(/,\s*[^,]+$/, '')) }
