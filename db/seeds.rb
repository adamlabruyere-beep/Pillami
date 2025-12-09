require "json"
require "open-uri"

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

#////////:/regex pour enlever le format aux noms des medicaments//////

# Medicament.find_each { |m| m.update(nom: m.nom.gsub(/,\s*[^,]+$/, '')) }
