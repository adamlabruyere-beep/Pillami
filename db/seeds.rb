require "json"
require "open-uri"





# p "reseting database"
# p "remove every user"
# User.delete_all
# p "all user deleted"
# p "creating TestMan"
# User.create(prenom: "TestMan", nom: "Disease", email: "testman@gmail.com", password: "password" )
# p "created"


url = "https://medicaments-api.giygas.dev/database/1"
medicament_page_serialized = URI.parse(url).read
medicament_page = JSON.parse(medicament_page_serialized)

Medicament.destroy_all

medicament_page["data"].each_with_index do |medicament, index|
  p "medicamant #{index + 1} : creation"
  if medicament["conditions"].nil?
    Medicament.create(nom: medicament["elementPharmaceutique"], format: medicament["formePharmaceutique"], prise: medicament["voiesAdministration"], ordonnance: false)
  else
    Medicament.create(nom: medicament["elementPharmaceutique"], format: medicament["formePharmaceutique"], prise: medicament["voiesAdministration"], ordonnance: true)
  end
  p "medicamant #{index + 1} : cree"
end
