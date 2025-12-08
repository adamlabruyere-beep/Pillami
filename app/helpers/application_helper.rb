module ApplicationHelper
  # Pluralisation française pour les mesures et autres mots
  def pluralize_fr(count, singular, plural = nil)
    count = count.to_i
    word = if count <= 1
             singular
           else
             plural || pluralize_french_word(singular)
           end
    "#{count} #{word}"
  end

  private

  def pluralize_french_word(word)
    # Règles de pluralisation françaises pour les mesures courantes
    plurals = {
      "Comprimé" => "Comprimés",
      "comprimé" => "comprimés",
      "Demi comprimé" => "Demi comprimés",
      "demi comprimé" => "demi comprimés",
      "Gélule" => "Gélules",
      "gélule" => "gélules",
      "Capsule" => "Capsules",
      "capsule" => "capsules",
      "Cuillère à café" => "Cuillères à café",
      "cuillère à café" => "cuillères à café",
      "Cuillère à soupe" => "Cuillères à soupe",
      "cuillère à soupe" => "cuillères à soupe",
      "Goutte" => "Gouttes",
      "goutte" => "gouttes",
      "Gouttes" => "Gouttes",
      "gouttes" => "gouttes",
      "Ampoule" => "Ampoules",
      "ampoule" => "ampoules",
      "Sachet" => "Sachets",
      "sachet" => "sachets",
      "Patch" => "Patchs",
      "patch" => "patchs",
      "Injection" => "Injections",
      "injection" => "injections",
      "jour" => "jours",
      "Jour" => "Jours"
    }

    plurals[word] || "#{word}s"
  end
end
