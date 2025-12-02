require "json"
require "open-uri"

categories = [
  "paracetamol", "ibuprofene", "aspirine", "codeine",
  "diclofenac", "ketoprofene", "naproxene",
  "amoxicilline", "azithromycine", "ciprofloxacine",
  "metformine", "insuline", "glibenclamide",
  "amlodipine", "ramipril", "losartan",
  "methotrexate", "fluorouracile", "cyclophosphamide",
  "alprazolam", "bromazepam", "diazepam",
  "sertraline", "fluoxetine", "paroxetine",
  "cetirizine", "loratadine", "desloratadine",
  "omeprazole", "pantoprazole", "esomeprazole"
]

p "Resetting database..."
Medicament.destroy_all
p "All medicaments deleted"

categories.each do |category|
  p "Fetching medicaments for category: #{category}"
  url = "https://medicaments-api.giygas.dev/medicament/#{category}"

  retries = 0
  max_retries = 3

  begin
    medicament_page_serialized = URI.parse(url).read
    medicament_page = JSON.parse(medicament_page_serialized)

    medicament_page.each_with_index do |medicament, index|
      p "Medicament #{index + 1} (#{category}): creation"

      ordonnance = !medicament["conditions"].nil?

      Medicament.create!(
        nom: medicament["elementPharmaceutique"],
        format: medicament["formePharmaceutique"],
        prise: medicament["voiesAdministration"],
        ordonnance: ordonnance
      )

      p "Medicament #{index + 1} (#{category}): created"
    end

    # Pause entre chaque catégorie pour éviter le rate limiting
    sleep(2)

  rescue OpenURI::HTTPError => e
    if e.message.include?("429") && retries < max_retries
      retries += 1
      p "Rate limited on #{category}, waiting 10 seconds... (retry #{retries}/#{max_retries})"
      sleep(10)
      retry
    else
      p "Error fetching #{category}: #{e.message}"
    end
  rescue JSON::ParserError => e
    p "Error parsing JSON for #{category}: #{e.message}"
  end
end

p "Seed completed! #{Medicament.count} medicaments created."



# derniere creation en recuperant depuis l'api a continuer demain
# "Medicament 3 (naproxene): creation"
# "Medicament 3 (naproxene): created"
# "Fetching medicaments for category: amoxicilline"
# "Rate limited on amoxicilline, waiting 10 seconds... (retry 1/3)"
# "Rate limited on amoxicilline, waiting 10 seconds... (retry 2/3)"
# "Rate limited on amoxicilline, waiting 10 seconds... (retry 3/3)"
# "Error fetching amoxicilline: 429 Too Many Requests"
